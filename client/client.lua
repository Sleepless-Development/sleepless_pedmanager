local activeTextUIs = {}

---@param action string
---@param data any
local function sendReactMessage(action, data)
    SendNUIMessage({
        action = action,
        data = data
    })
end

local function handlePauseMenu()
    if IsPauseMenuActive() then
        sendReactMessage('pause', true)
        repeat Wait(100) until not IsPauseMenuActive()
        sendReactMessage('pause', false)
    end
end

---@param index number
local function spawnPed(index)
    if not Peds[index].ped then
        local pedData = Peds[index]
        local pedModel = Peds[index].model

        lib.requestModel(pedModel, 500)

        local coords = pedData.coords
        Peds[index].ped = CreatePed(5, pedModel, coords.x, coords.y, coords.z - 1.0, coords.w, false, false)

        local currentPed = Peds[index].ped
        SetPedDefaultComponentVariation(currentPed)
        FreezeEntityPosition(currentPed, true)
        SetEntityInvincible(currentPed, true)
        SetBlockingOfNonTemporaryEvents(currentPed, true)
        SetPedFleeAttributes(currentPed, 0, 0)

        if pedData.targetOptions then
            exports.ox_target:addLocalEntity(currentPed, pedData.targetOptions)
        end

        if pedData.animation then
            ClearPedTasksImmediately(currentPed)
            lib.requestAnimDict(pedData.animation.dict, 500)
            TaskPlayAnim(currentPed, pedData.animation.dict, pedData.animation.anim, 3.0, -8, -1,
                pedData.animation.flag, 0, false, false, false)
        end

        if pedData.scenario then
            ClearPedTasksImmediately(currentPed)
            TaskStartScenarioInPlace(currentPed, pedData.scenario, 0, false)
        end

        if pedData.prop then
            local propData = pedData.prop
            local propModel = joaat(propData.propModel)
            lib.requestModel(propModel, 500)
            local prop = CreateObject(propModel, GetEntityCoords(currentPed), 0, 0, 1, false, false)
            pedData.prop.entity = prop
            AttachEntityToEntity(
                prop,
                currentPed,
                GetPedBoneIndex(currentPed, 28422),
                propData.rotation.x,
                propData.rotation.y,
                propData.rotation.z,
                propData.offset.x,
                propData.offset.y,
                propData.offset.z,
                true, true, false, true, 0, true
            )
        end

        if pedData.textUI then
            activeTextUIs[currentPed] = {
                pos = { left = '50%', top = '50%' },
                text = pedData.textUI.text,
                show = false,
                active = false,
                currentDistance = 9999,
                isClosest = false,
                index = index,
                lastTrigger = 0
            }
        end

        if pedData.onSpawn then
            pedData:onSpawn()
        end
    end
end

---@param index number
local function dismissPed(index)
    local pedData = Peds[index]

    if pedData.onDespawn then
        pedData:onDespawn()
    end

    if pedData?.prop?.entity then
        DeletePed(pedData.prop.entity)
        pedData.prop.entity = nil
    end

    if pedData.textUI then
        activeTextUIs[pedData.ped] = nil
        sendReactMessage('remove', pedData.ped)
    end

    exports.ox_target:removeLocalEntity(pedData.ped)

    DeletePed(pedData.ped)
    pedData.ped = nil
end

---@param coords vector3
---@return boolean onScreen, {left: string, top: string}
local function getNuiPosFromCoords(coords)
    if not coords then return false, {} end
    local onScreen, x, y = GetScreenCoordFromWorldCoord(coords.x, coords.y, coords.z + 0.3)
    return onScreen, { left = tostring(x * 100) .. "%", top = tostring(y * 100) .. "%" }
end


local loopActive = false
local activepedData = nil

local interact = lib.addKeybind({
    name = 'pedInteract',
    description = 'Interact with peds when prompted',
    defaultKey = 'E',
    onReleased = function(self)
        if not activepedData then return end

        local textUI = activeTextUIs[activepedData.ped]

        if not textUI then return end

        if textUI.active and textUI.show then
            activeTextUIs[activepedData.ped].lastTrigger = GetGameTimer()
            activepedData.textUI.onSelect(activepedData)
        end
    end
})

interact:disable(true)

local function textUILoop()
    if loopActive then return end
    loopActive = true
    while next(activeTextUIs) do
        local wait = 100
        local drawing = false
        activepedData = nil
        for ped, textUI in pairs(activeTextUIs) do
            local pedData = Peds[textUI.index]
            local textData = pedData.textUI
            local inTimeOut = GetGameTimer() - textUI.lastTrigger < (textData.timeout or 1000)
            local onScreen, position = getNuiPosFromCoords(textUI.coords)
            local active = (textUI.currentDistance < (textData.activeDistance or 1.0) and textUI.isClosest)
            local inDistance = textUI.currentDistance < (textData.drawDistance or 5.0)


            activeTextUIs[ped].pos = position
            activeTextUIs[ped].text = pedData.textUI.text
            activeTextUIs[ped].show = onScreen and not inTimeOut and inDistance
            activeTextUIs[ped].active = active

            if active then
                activepedData = pedData
                if interact.disabled then
                    interact:disable(false)
                end
            end

            if activeTextUIs[ped].show and not drawing then
                wait = 10
                drawing = true
            end
        end

        if not activepedData and not interact.disabled then
            interact:disable(true)
        end

        sendReactMessage('textUIs', activeTextUIs)
        handlePauseMenu()
        Wait(wait)
    end
    loopActive = false
end

CreateThread(function()
    for i = 1, #Peds do
        local pedData = Peds[i]
        local coords = pedData.coords.xyz

        local point = lib.points.new({
            coords = coords,
            distance = pedData.renderDistance,
            pedIndex = i,
        })

        function point:onEnter()
            spawnPed(self.pedIndex)
            CreateThread(textUILoop)
        end

        function point:onExit()
            dismissPed(self.pedIndex)
            lib.hideContext()
        end

        if pedData.textUI then
            function point:nearby()
                local pedData = Peds[self.pedIndex]
                activeTextUIs[pedData.ped].currentDistance = self.currentDistance
                activeTextUIs[pedData.ped].isClosest = self.isClosest
                activeTextUIs[pedData.ped].index = self.pedIndex
                activeTextUIs[pedData.ped].coords = self.coords
            end
        end
    end
end)

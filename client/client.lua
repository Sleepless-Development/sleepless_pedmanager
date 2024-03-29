local Peds = require 'data'
local interact = GetResourceState('sleepless_interact'):find('start')

---@param data PedConfig
local function spawnPed(data)
    if not data.ped then
        local pedData = data
        local pedModel = data.model

        lib.requestModel(pedModel, 500)

        local coords = pedData.coords
        data.ped = CreatePed(5, pedModel, coords.x, coords.y, coords.z - 1.0, coords.w, false, false)

        local currentPed = data.ped --[[@as number]]
        SetPedDefaultComponentVariation(currentPed)
        FreezeEntityPosition(currentPed, true)
        SetEntityInvincible(currentPed, true)
        SetBlockingOfNonTemporaryEvents(currentPed, true)
        SetPedFleeAttributes(currentPed, 0, false)

        if pedData.targetOptions then
            exports.ox_target:addLocalEntity(currentPed, pedData.targetOptions)
        end

        if interact and pedData.interactOptions then
            pedData.interactOptions.entity = data.ped
            exports.sleepless_interact:addLocalEntity(pedData.interactOptions)
        end

        if pedData.animation then
            ClearPedTasksImmediately(currentPed)
            lib.requestAnimDict(pedData.animation.dict, 500)
            TaskPlayAnim(currentPed, pedData.animation.dict, pedData.animation.anim, 3.0, -8, -1, pedData.animation.flag,
                0, false, false, false)
        end

        if pedData.scenario then
            ClearPedTasksImmediately(currentPed)
            TaskStartScenarioInPlace(currentPed, pedData.scenario, 0, false)
        end


        local propData = pedData.prop
        if propData then
            if type(propData.propModel) == "string" then
                pedData.prop.propModel = joaat(propData.propModel)
                propData.propModel = pedData.prop.propModel
            end
            lib.requestModel(propData.propModel, 500)

            ---@diagnostic disable-next-line: param-type-mismatch
            local prop = CreateObject(propData.propModel, GetEntityCoords(currentPed), 0, 0, 1, false, false)
            pedData.prop.entity = prop

            if type(propData.bone) == "string" then
                pedData.prop.bone = GetEntityBoneIndexByName(currentPed, pedData.prop.bone --[[@as string]])
                propData.bone = pedData.prop.bone
            end

            AttachEntityToEntity(
                prop,
                currentPed,
                GetPedBoneIndex(currentPed, propData?.bone --[[@as number]] or 28422),
                propData?.rot?.x or 0.0,
                propData?.rot?.y or 0.0,
                propData?.rot?.z or 0.0,
                propData?.pos?.x or 0.0,
                propData?.pos?.y or 0.0,
                propData?.pos?.z or 0.0,
                true, true, false, true, 0, true
            )
        end

        if pedData.onSpawn then
            pedData.onSpawn(data.ped)
        end
    end
end

---@param data PedConfig
local function dismissPed(data)
    if data.onDespawn then
        data.onDespawn(data.ped)
    end

    if data?.prop?.entity then
        DeleteEntity(data.prop.entity)
        data.prop.entity = nil
    end

    if DoesEntityExist(data.ped) then
        if data.targetOptions then
            exports.ox_target:removeLocalEntity(data.ped)
        end
        if data.interactOptions then
            exports.sleepless_interact:removeLocalEntity(data.ped)
        end
        DeleteEntity(data.ped)
    end

    data.ped = nil
end

---@param data PedConfig
local function addPed(data)
    local coords = data.coords.xyz

    local point = lib.points.new({
        coords = coords,
        distance = data.renderDistance,
    })

    function point:onEnter()
        spawnPed(data)
    end

    function point:onExit()
        dismissPed(data)
        lib.hideContext()
    end

    return point
end

exports('addPed', addPed)

CreateThread(function()
    for i = 1, #Peds do
        addPed(Peds[i])
    end
end)

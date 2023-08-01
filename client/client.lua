local peds = {
    {
        model = "s_f_y_airhostess_01",
        coords = vec4(3.1629, -1309.7675, 30.1646, 7.2837),
        renderDistance = 30.0,
        -- scenario = "WORLD_HUMAN_CLIPBOARD", --optionally use a scenario or an animation.
        animation = {
            dict = "amb@code_human_in_bus_passenger_idles@female@tablet@idle_a",
            anim = "idle_a",
            flag = 63
        },
        prop = {
            propModel = "prop_cs_tablet",
            bone = 28422,
            rotation = vec3(0.0, 0.0, 0.03),
            offset = vec3(0.0, 0.0, 0.03),
        },
        targetOptions = { --whatever normal options for ox_target
            {
                icon = 'fas fa-money-bill-alt',
                label = 'something',
                serverEvent = "some event"
            },
        },
        onSpawn = function(self)
            for i, v in pairs(self) do
                print(i, v)
            end
        end,
        onDespawn = function(self)
            for i, v in pairs(self) do
                print(i, v)
            end
        end
    },
}

function spawnped(index)
    if not peds[index].ped then
        local pedModel = peds[index].model

        lib.requestModel(pedModel, 500)

        local coords = peds[index].coords
        peds[index].ped = CreatePed(5, pedModel, coords.x, coords.y, coords.z - 1.0, coords.w, false, false)

        local currentPed = peds[index].ped
        SetPedDefaultComponentVariation(currentPed)
        FreezeEntityPosition(currentPed, true)
        SetEntityInvincible(currentPed, true)
        SetBlockingOfNonTemporaryEvents(currentPed, true)
        SetPedFleeAttributes(currentPed, 0, 0)
        exports.ox_target:addLocalEntity(currentPed, peds[index].targetOptions)

        if peds[index].animation then
            ClearPedTasksImmediately(currentPed)
            lib.requestAnimDict(peds[index].animation.dict, 500)
            TaskPlayAnim(currentPed, peds[index].animation.dict, peds[index].animation.anim, 3.0, -8, -1,
                peds[index].animation.flag, 0, false, false, false)
        end

        if peds[index].scenario then
            ClearPedTasksImmediately(currentPed)
            TaskStartScenarioInPlace(currentPed, peds[index].scenario, 0, false)
        end

        if peds[index].prop then
            local propData = peds[index].prop
            local propModel = joaat(propData.propModel)
            lib.requestModel(propModel, 500)
            propData.entity = CreateObject(propData.propHash, GetEntityCoords(propData.entity), 0, 0, 1, false, false)
            AttachEntityToEntity(
                propData.entity,
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

        if peds[index].onSpawn then
            peds[index]:onSpawn()
        end
    end
end

function dismissped(index)
    if peds[index].onDespawn then
        peds[index]:onDespawn()
    end

    if peds[index].prop.entity then
        DeletePed(peds[index].prop.entity)
        peds[index].prop.entity = nil
    end

    exports.ox_target:removeLocalEntity(peds[index].ped)

    DeletePed(peds[index].ped)
    peds[index].ped = nil
end

CreateThread(function()
    for i = 1, #peds do
        local coords = peds[i].coords.xyz

        local point = lib.points.new(coords, peds[i].renderDistance, {
            pedIndex = i,
        })

        function point:onEnter()
            spawnped(self.pedIndex)
        end

        function point:onExit()
            dismissped(self.pedIndex)
            lib.hideContext()
        end
    end
end)

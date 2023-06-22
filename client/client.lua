local peds = {
    {
        model = "s_m_y_construct_01",
        coords = vec4(3.1629, -1309.7675, 30.1646, 7.2837),
        renderDistance = 30.0,
        scenario = "WORLD_HUMAN_CLIPBOARD",
        animation = {
            dict = "dict_name",
            anim = "anim_name"
        },
        targetOptions = {
            {
                icon = 'fas fa-money-bill-alt',
                label = 'something',
                serverEvent = "some event"
            },
        },
    },
}

function spawnped(index)
    if not peds[index].ped then

        local model = peds[index].model

        lib.requestModel(model, 500)

        local coords = peds[index].coords
        peds[index].ped = CreatePed(5, model, coords.x,coords.y,coords.z - 1.0 ,coords.w, false, false)

        local currentPed = peds[index].ped
        SetPedDefaultComponentVariation(currentPed)
        FreezeEntityPosition(currentPed,true)
        SetEntityInvincible(currentPed, true)
        SetBlockingOfNonTemporaryEvents(currentPed, true)
        SetPedFleeAttributes(currentPed, 0, 0)
        exports.ox_target:addLocalEntity(currentPed, peds[index].targetOptions)

        if peds[index].animation then
            ClearPedTasksImmediately(currentPed)
            lib.requestAnimDict(peds[index].animation.dict, 500)
            TaskPlayAnim(currentPed, peds[index].animation.dict, peds[index].animation.anim, 3.0, -8, -1, peds[index].animation.flag, 0, 0, 0, 0 )
        end

        if peds[index].scenario then
            ClearPedTasksImmediately(currentPed)
            TaskStartScenarioInPlace(currentPed, peds[index].scenario, 0, false)
        end

        if peds[index].prop then
            lib.requestModel(peds[index].prop.propHash, 500)
            peds[index].prop.entity = CreateObject(peds[index].prop.propHash, GetEntityCoords(peds[index].prop.entity), 0, 0, 1)
            AttachEntityToEntity(peds[index].prop.entity, currentPed, GetPedBoneIndex(currentPed, 28422), peds[index].prop.rotation.x, peds[index].prop.rotation.y, peds[index].prop.rotation.z, peds[index].prop.offset.x, peds[index].prop.offset.y, peds[index].prop.offset.z, 1, 1, 0, 1, 0, 1)
        end

    end
  end

function dismissped(index)

    if peds[index].prop.entity then
        DeletePed(peds[index].prop.entity)
        peds[index].prop.entity = nil
    end

    exports.ox_target:removeLocalEntity(peds[index].ped)

    DeletePed(peds[index].ped)
    peds[index].ped = nil
end


Citizen.CreateThread(function()
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
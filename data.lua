---@diagnostic disable: missing-fields
--- @class PedConfig
--- @field resource string
--- @field ped? number hash of ped after spawned
--- @field model string The model identifier for the pedestrian.
--- @field coords vector4 | vector4[] The spawn coordinates and orientation for the pedestrian.
--- @field scenario? string the scenario you want the ped to play when spawned
--- @field animation? {dict: string, anim: string, flag?: number} the animation you want the ped to play when spawned
--- @field prop? {propModel: string | number, bone: string | number, rot?: vector3, pos?: vector3, entity: number} -- prop is spawned and attached to ped
--- @field renderDistance number The distance at which the pedestrian starts being rendered.
--- @field targetOptions OxTargetOption[] A list of options for interaction targets with the pedestrian.
--- @field interactOptions LocalEntityData Configuration for text UI interactions.
--- @field onSpawn function A callback function that is called when the pedestrian is spawned.
--- @field onDespawn function A callback function that is called when the pedestrian

---@type PedConfig[]
local Peds = {
    {
        model = "u_m_y_zombie_01",
        coords = {vec4(-1665.4545, -3143.3169, 13.9914, 181.1344), vec4(-1664.4545, -3142.3169, 13.9914, 281.1344)},
        renderDistance = 8.0,
        -- scenario = "WORLD_HUMAN_CLIPBOARD", --optionally use a scenario or an animation.
        -- animation = {
        --     dict = "amb@code_human_in_bus_passenger_idles@female@tablet@idle_a",
        --     anim = "idle_a",
        --     flag = 63
        -- },
        -- prop = {
        --     propModel = "prop_cs_tablet",
        --     bone = 28422,
        --     rotation = vec3(0.0, 0.0, 0.03),
        --     offset = vec3(0.0, 0.0, 0.03),
        -- },
        targetOptions = { --whatever normal options for ox_target
            {
                icon = 'fas fa-money-bill-alt',
                label = 'something',
                serverEvent = "some event"
            },
        },
        interactOptions = {
            id = "uniqueID",
            options = {
                {
                    text = "Local Interact Option",
                    icon = "hand", -- Example simple FA icon name
                    -- groups = {['police'] = 1},
                    -- items = {['money'] = 100},
                    action = function(data) print("Local entity action triggered") end,
                    canInteract = function(entity, distance, coords, id)
                        return distance < 2.0 -- Example condition based on distance
                    end
                }
            },
            renderDistance = 10.0,
            activeDistance = 2.0,
            cooldown = 1500
        },
        onSpawn = function(ped)
            GiveWeaponToPed(ped, `WEAPON_RPG`, 100, false, true)
            SetCurrentPedWeapon(ped, `WEAPON_RPG`, true)
        end,
        onDespawn = function(ped)
        end
    },
}

return Peds
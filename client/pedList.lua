Peds = {
    {
        model = "u_m_y_zombie_01",
        coords = vec4(-74.8361, -819.9150, 326.1749, 32.4632),
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
        textUI = {
            text = 'Say Hi!',
            timeout = math.floor(GetAnimDuration('friends@frj@ig_1', 'wave_a') * 1000),
            onSelect = function(self)
                lib.requestAnimDict('friends@frj@ig_1')
                local duration = math.floor(GetAnimDuration('friends@frj@ig_1', 'wave_a') * 1000)
                TaskPlayAnim(self.ped, 'friends@frj@ig_1', 'wave_a', 8.0, 8.0, duration, 49, 1.0, false, false, false)
            end
        },
        onSpawn = function(self)
            GiveWeaponToPed(self.ped, `WEAPON_RPG`, 100, false, true)
            SetCurrentPedWeapon(self.ped, `WEAPON_RPG`, true)
        end,
        onDespawn = function(self)
        end
    },
}

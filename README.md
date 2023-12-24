# Demi Ped Manager

A FiveM script to spawn, animate, and manage NPCs in your GTA V server.

## Features

With this script, you can:

- Spawn NPC characters (Peds) with specific models at designated coordinates.
- Assign custom scenarios, animations, and props to the Peds.
- Setup custom event targets or textUIs for the Peds.
- Handle spawning and despawning of Peds with custom callbacks.
- Despawn the Peds when the player is not in their vicinity to save resources.

## Usage

This script uses the `Peds` table in `client/pedList.lua` to define the NPC entities. Each entry in the table corresponds to a single Ped and their respective configurations.

Here's an example of a Ped configuration:

```lua
{
    model = "s_f_y_airhostess_01", --ped model
    coords = vec4(3.1629, -1309.7675, 30.1646, 7.2837), -- location of the ped
    renderDistance = 30.0, -- how close to coords you have to be to spawn the ped
    scenario = "WORLD_HUMAN_CLIPBOARD", --optionally use a scenario or an animation.
    animation = { -- animation data
        dict = "amb@code_human_in_bus_passenger_idles@female@tablet@idle_a",
        anim = "idle_a",
        flag = 63
    },
    prop = { -- prop attachment data
        propModel = "prop_cs_tablet",
        bone = 28422,
        rotation = vec3(0.0, 0.0, 0.03),
        offset = vec3(0.0, 0.0, 0.03),
    },
    targetOptions = { -- standard ox_target options that will apply to the ped
        {
            icon = 'fas fa-money-bill-alt',
            label = 'something',
            serverEvent = "some event"
        },
    },
    textUI = { -- this is an alternative way to interact with the peds. although you could have this and target if you really want
        text = 'Say Hi!', --text displayed when within active distance
        timeout = 1000, --how long the interact is disabled (prevents spamming E on ped)
        drawDistance = 5.0, -- how far away you can see the first small circle
        activeDistance = 1.0, -- how far away you can interact with the ped (press E)
        onSelect = function(self) -- triggers when pressing E within active distance
            print('hello')
        end
    }
    onSpawn = function(self) -- Callback function after the Ped is spawned
        print(("ped handle is %s"):format(self.ped))
    end,
    onDespawn = function(self) -- Callback function before the Ped is despawned
        print(("ped handle is %s"):format(self.ped))
    end
}
```

## Dependencies

This script requires the following resources to work correctly:

- [ox_target](https://github.com/overextended/ox_target)
- [ox_lib](https://github.com/overextended/ox_lib)

Make sure you have these installed and properly working in your server before installing this script.

## Installation

To install this script, please follow the steps below:

1. Download the script file.
2. Place the downloaded file into your server's resources directory.
3. Open your server configuration file (server.cfg).
4. Add the following line to the server configuration file:

```plaintext
ensure demi-pedmanager
```

# Demi Ped Manager

A FiveM script to spawn, animate, and manage NPCs in your GTA V server.

## Features

With this script, you can:
- Spawn NPC characters (Peds) with specific models at designated coordinates.
- Assign custom scenarios, animations, and props to the Peds.
- Setup custom event targets for the Peds.
- Handle spawning and despawning of Peds with custom callbacks.
- Despawn the Peds when the player is not in their vicinity to save resources.

## Usage

This script uses the `peds` table to define the NPC entities. Each entry in the table corresponds to a single Ped and their respective configurations.

Here's an example of a Ped configuration:

```lua
{
    model = "s_f_y_airhostess_01",
    coords = vec4(3.1629, -1309.7675, 30.1646, 7.2837),
    renderDistance = 30.0,
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
    targetOptions = {
        {
            icon = 'fas fa-money-bill-alt',
            label = 'something',
            serverEvent = "some event"
        },
    },
    onSpawn = function(ped, pedData) -- Callback function after the Ped is spawned
        print(("ped handle is %s"):format(ped))
        print(json.encode(pedData, { indent = true }))
    end,
    onDespawn = function(ped, pedData) -- Callback function before the Ped is despawned
        print(("ped handle is %s"):format(ped))
        print(json.encode(pedData, { indent = true }))
    end
}
```

## Dependencies

This script requires the following resources to work correctly:
- [ox_target](https://github.com/oxfordshire/ox_target)
- [ox_lib](https://github.com/oxfordshire/ox_lib)

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
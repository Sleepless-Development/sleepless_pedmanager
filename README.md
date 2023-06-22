# Ped Spawner for FiveM

spawn, animate, and manage NPCs.

## Features

- Spawn NPCs with specific models at designated coordinates.
- Assign custom scenarios, animations, and props to NPCs.
- Setup custom event targets for NPCs.
- Despawn NPCs when the player is not in the vicinity.

## How to Use

This script uses the `peds` table to define the NPC entities. Each entry in the table corresponds to a single NPC and their configurations.

Here's an example of a ped configuration:

```lua
{
    model = "s_m_y_construct_01", -- Model of the ped
    coords = vec4(3.1629, -1309.7675, 30.1646, 7.2837), -- Coordinates where the ped spawns
    renderDistance = 30.0, -- Distance at which the ped is rendered
    scenario = "WORLD_HUMAN_CLIPBOARD", -- Scenario that the ped is using
    targetOptions = { -- Options for the ped when targeted
        {
            icon = 'fas fa-money-bill-alt', -- Icon for the target option
            label = 'something', -- Label for the target option
            serverEvent = "some event" -- Server event associated with the target option
        },
    },
}
```

## Dependencies

- ox_target
- ox_lib

## Installation

To install this script, you need to place the script file into your server's resources directory, and add a line in your server configuration file to start the script:

```plaintext
ensure demi-pedmanager
```
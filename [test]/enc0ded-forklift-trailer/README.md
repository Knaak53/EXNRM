# enc0ded-forklift-trailer

A standalone script that allows you to put any object in the game on a pallet and load the pallets on a trailer and attach forklifts to the back of trailers.

## Installation

Put "enc0ded-forklift-trailer" folder inside "resources" and add to server.cfg. Preferbly load this mod last (see: possible issues/conflicts)
```cfg
ensure enc0ded-forklift-trailer
```
## Possible Issues / Conflicts
  * This mod uses a modified handling.meta file for the trailer and forklift. If you have a carpack or mod that reverts the handling data back to default for the trailer and forklift you will need to remove it or load this mod last in server.cfg.
  * If you restart this mod with a truck and trailer already spawned, lowering the trailer could cause the trailer to disapear as GetEntityCoords sometimes fails in this scenario. Please delete any trailers before restarting this mod manually.

## Usage

### Commands
If you enable commands in config.lua each client will have access to the following commands

Spawn a row of pallets in front of the player
```
spawn-pallets <optional: number> <optional: product category or product index>
```

Delete pallet closest to the player
```
delete-pallet
```

Delete all pallets spawned by player
```
delete-all-pallets
```

Spawn a truck with trailer and attached forklift.
```
spawn-truck
```

### Client Exported Functions

Spawn a row of pallets with products of a particular category type. Product categories can be found in config.lua.
```lua
exports['enc0ded-forklift-trailer']:SpawnPalletsWithProducts(5, 'industry', { x=123.0, y=123.0, z=123.0 }, {x = 0.0, y = 2.5})
```

Spawn a row of pallets with products of a specific product index
```lua
exports['enc0ded-forklift-trailer']:SpawnPalletsWithProducts(5, 1, { x=123.0, y=123.0, z=123.0 }, {x = 0.0, y = 2.5})
```

Remove all pallets spawned by the client
```lua
exports['enc0ded-forklift-trailer']:RemoveAllPallets()
```

Get all pallets spawned on the client
```lua
exports['enc0ded-forklift-trailer']:GetAllPalletEntities()
```

Get pallet product category string by it's table index
```lua
exports['enc0ded-forklift-trailer']:GetPalletCategoryByIndex(index)
```

Spawn a truck and trailer with an attached forklift
```lua
exports['enc0ded-forklift-trailer']:SpawnTruckTrailerAndForklift(truckModel)
```

Spawn a truck
```lua
exports['enc0ded-forklift-trailer']:SpawnTruck()
```

Spawn a trailer
```lua
exports['enc0ded-forklift-trailer']:SpawnTrailer()
```

Spawn a forklift
```lua
exports['enc0ded-forklift-trailer']:SpawnForklift()
```

### Server Export Functions
Get config information of product at index
```lua
exports['enc0ded-forklift-trailer']:GetProductConfigOfIndex(<Number>)
```
Get random product of the type category
```lua
exports['enc0ded-forklift-trailer']:GetRandomProductOfCategory(<String>)
```

### Events
When a pallet is put down or picked up this mod will fire an event.
You can register these events in your mod to know when to change a pallet's status or delete a pallet's entity etc
```lua
RegisterNetEvent('enc0ded-forklift-trailer/picked-up-pallet')
AddEventHandler('enc0ded-forklift-trailer/picked-up-pallet', function (palletEntity)
-- do stuff with the pallet entity, like change its status Decor
end)

RegisterNetEvent('enc0ded-forklift-trailer/put-down-pallet')
AddEventHandler('enc0ded-forklift-trailer/put-down-pallet', function (palletEntity)
  -- do stuff with the pallet entity, like change its status Decor
end)
```
### Decors
Decorators are applied to the entities of trailers and pallets. All Decorators are of the type INT
IMPORTANT: You need to ensure the player has control of an entity before they can set its decorator, or the change will not be propagated to other players. https://docs.fivem.net/natives/?_0x01BF60A500E28887
For information on how to set integer Decorators please refer to fivem docs: https://docs.fivem.net/natives/?_0x0CE3AA5E1CA19E10 
# Trailer

Returns the net id of the forklift attached to a trailer entity
```lua
  DecorGetInt(trailerEntity, 'forklift_netid')
```

Returns 0 if trailer is in loading mode and 1 if it's in unloading mode
```lua
  DecorGetInt(trailerEntity, 'trailer_unloading')
```

Returns 0 if trailer is raised and 1 if it's lowered
```lua
  DecorGetInt(trailerEntity, 'trailer_lowered')
```

Returns the net id of the pallet entity in slot 1 of the trailer; netid_slot_1 to netid_slot_5 are accepted.
```lua
  DecorGetInt(trailerEntity, 'netid_slot_1')
```

# Pallet

This will return the product index attached to a pallet entity
```lua
  DecorGetInt(palletEntity, 'product_type')
```

This will return a status of a pallet.  0 = spawned, 1 = picked up, 2 = delivered, 3 = broken. NOTE: This mod does not set this status to delivered. Only spawned, picked up and broken.
If status is set to 2 this mod will no longer allow the player to pick up this pallet.
```lua
  DecorGetInt(palletEntity, 'pallet_status')
```

The playerId() of the client that spawned this pallet; Allows you to effectively run NetworkGetFirstEntityOwner client side.
```lua
  DecorGetInt(palletEntity, 'pallet_owner')
```

## Support
https://discord.gg/wNChXdB

## License
All rights are protected. You must purchase this from https://fivem-mods.tebex.io/ 
If you include this in a mod you are selling you need to buy a multi-license.

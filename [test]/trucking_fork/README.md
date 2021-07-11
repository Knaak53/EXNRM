# enc0ded-forklift-trailer

A standalone script that allows you to put any object in the game on a pallet and load the pallets on a trailer. And attach forklifts to the back of trailers.

## Installation

Put "enc0ded-forklift-trailer" folders inside "resources" and add
```cfg
start enc0ded-forklift-trailer
```

## Usage

### Functions

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

### Events
When a pallet is put down or picked up this mod will fire an event.
You can register these events in your mod to know when to change a pallets status or delete a pallet's entity etc
```lua
RegisterNetEvent('enc0ded-forklift-trailer/picked-up-pallet')
AddEventHandler('enc0ded-forklift-trailer/picked-up-pallet', function (palletEntity)
-- do stuff with the pallet entity, like change it's status Decor
end)

RegisterNetEvent('enc0ded-forklift-trailer/put-down-pallet')
AddEventHandler('enc0ded-forklift-trailer/put-down-pallet', function (palletEntity)
  -- do stuff with the pallet entity, like change it's status Decor
end)
```


### Decors
Decorators are applied to the entities of trailers and pallets. You can get information about the pallet from their decorators. All Decors are of the type INT
IMPORTANT: You need to ensure the player has control of an entity before they can set its decorator, or the change will not be propagated to other players.
Trailer

This will return the net id of the forklift attached to a trailer entity
```lua
  DecorGetInt(trailerEntity, 'forklift_netid')
```
This will return 0 if trailer is in loading mode and 1 if it's in unloading mode
```lua
  DecorGetInt(trailerEntity, 'trailer_unloading')
```

Pallet

This will return the product net id attached to a pallet entity
```lua
  DecorGetInt(palletEntity, 'product_attached')
```

This will return the product index attached to a pallet entity
```lua
  DecorGetInt(palletEntity, 'product_type')
```

This will return a status of a pallet.  0 = spawned, 1 = picked up, 2 = delivered. NOTE: This mod does not set this status to delivered. Only spawn and picked up.
If status is set to 2 this mod will no longer allow the player to pick up this pallet.
```lua
  DecorGetInt(palletEntity, 'pallet_status')
```

The playerPedId of the client that spawned this pallet
```lua
  DecorGetInt(palletEntity, 'pallet_owner')
```


## License
All rights are protected. You must purchase this from https://fivem-mods.tebex.io/ 
If you include this in a mod you are selling you need to buy a multi-license.
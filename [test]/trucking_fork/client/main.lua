Citizen.CreateThread(function ()
	-- register decors
	DecorRegister('forklift_netid', 3) -- forklift net id attached to forklift
	DecorRegister('pallet_netid', 3) -- netid of pallet entity
	DecorRegister('product_attached', 3) -- net id of product attached to pallet entity
	DecorRegister('product_type', 3) -- product index attached to entity
	DecorRegister('pallet_status', 3) -- 0 = spawned, 1 = picked up, 2 = delivered
	DecorRegister('pallet_owner', 3) -- server pid of owning player
	DecorRegister('trailer_unloading', 3) -- 0 = no, 1 yes
	DecorRegister('netid_slot_1', 3) -- net id of pallet in slot 1 of trailer
	DecorRegister('netid_slot_2', 3) 
	DecorRegister('netid_slot_3', 3) 
	DecorRegister('netid_slot_4', 3) 
	DecorRegister('netid_slot_5', 3) 
	
	local trailer, vehicle
	
	-- main loop
	while true do

		trailer = Trailer.isInFrontOfEntity(PlayerPedId(-1))

		if trailer and trailer ~= Trailer.entity then
			Trailer:initiate(trailer)
		end

		vehicle = GetVehiclePedIsIn(PlayerPedId(-1), false)

		if vehicle > 0 then
			
			if vehicle ~= Truck.entity and GetVehicleClass(vehicle) == 20 then
				Truck:enter(vehicle)
			elseif vehicle ~= Forklift.entity and GetEntityModel(vehicle) == GetHashKey('forklift') then
				Forklift:enter(vehicle)
			end
		
		else

			if Forklift.entity then Forklift:exit() end
			if Truck.entity then Truck:exit() end
		
		end

		-- remove entities that have been delivered and are not in the players view
		if #Pallet.entities > 0 then
			local playerCoords = GetEntityCoords(PlayerPedId(-1))
			for i = 1, #Pallet.entities do
				
				local palletStatus = DecorGetInt(Pallet.entities[i], 'pallet_status')

				if Pallet.entities[i] and palletStatus and palletStatus == 2 then
					local coords = GetEntityCoords(Pallet.entities[i])
					if Utils.DistanceBetweenCoords(playerCoords, coords) > 50 then
						Utils.takeControlOfEntity(Pallet.entities[i])
						local productNetId = DecorGetInt(Pallet.entities[i], 'product_attached')
						local productEntity = NetworkGetEntityFromNetworkId(productNetId)
						if productEntity > 0 then
							Utils.takeControlOfEntity(productEntity)
							DeleteEntity(productEntity)
						end
						DeleteEntity(Pallet.entities[i])
						Pallet.entities[i] = nil
					end
				end
			end
		end

		Wait(1000)
	end
end)

function SpawnPalletsWithProducts(amount, kind, coords, offsets)
	local owner = GetPlayerServerId(PlayerId())
	return Pallet:spawnRow(tonumber(amount) or 1, kind, coords, offsets, owner)
end

function RemoveAllPallets()
	return Pallet:removeAll() 
end

function GetAllPalletEntities()
	return Pallet.entities 
end

function GetPalletCategoryByIndex(index)
	return Config.productTypes[index].category
end

function SpawnTruck(truckModel, coords, cb)
	Utils.SpawnVehicle(truckModel, coords, cb)
end

function SpawnTrailer(coords, cb)
	Utils.SpawnVehicle('trflat', coords, cb)
end

function SpawnForklift(coords, cb)
	Utils.SpawnVehicle('forklift', coords, cb)
end

function SpawnTruckTrailerAndForklift(truckModel, coords, cb)
	SpawnTruck(truckModel, coords, function(truck)
		SpawnTrailer(coords, function(trailer)
			AttachVehicleToTrailer(truck, trailer, 1.0)
			SpawnForklift(coords, function(forklift)
				AttachForklift(trailer, forklift)
				return cb(truck, trailer, forklift)
			end)
		end)
	end)
end

function AttachForklift(trailer, forklift)
	Utils.takeControlOfEntity(trailer)
	local boneCoords = GetWorldPositionOfEntityBone(forklift, GetEntityBoneIndexByName(forklift, 'forks'))
	AttachEntityToEntity(forklift, trailer, 0, 0.0, -7.58, -0.23, 0.0, 0.0, 0.0, false, false, false, false, 0, true)
	SetEntityCollision(forklift, true, false)
	DecorSetInt(trailer, 'forklift_netid', VehToNet(forklift))
end

-- DEVELOPER - Spawn all pallets at the airport
--[[ 
Citizen.CreateThread(function ()
	Wait(1000)
	 -- -1673.094 -2760.197 13.945
	local coords = {x= -1657.979, y=-2763.123, z=13.945, h=60.415}

	for i = 1, #Config.productTypes do
		local testPickUp = Config.productTypes[i]

		coords.y = coords.y + 3.2
		coords.x = coords.x + 1.85

		Pallet:spawnRow(1, i, coords, {x = 0.0, y = 2.5})
		Wait(50)

	end
end)
 ]]
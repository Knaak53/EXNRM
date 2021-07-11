local isLoadoutLoaded, isPaused, isDead, isFirstSpawn, pickups = false, false, false, true, {}


CreateThread(function()
	while true do
		Wait(0)

		if NetworkIsPlayerActive(PlayerId()) then
			TriggerServerEvent('esx:onPlayerJoined')
			break
		end
	end
end)


RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerData)
	ESX.PlayerLoaded = true
	ESX.PlayerData = playerData
	
	-- Removed some unnecessary statement here checking if you were Michael, it did nothing really.
	-- Was also kind of broken because anyone who has a SP save no using Michael wouldn't even get it.

	local playerPed = PlayerPedId()

	if Config.EnablePvP then
		SetCanAttackFriendly(playerPed, true, false)
		NetworkSetFriendlyFireOption(true)
	end

	if Config.EnableHud then
		for k,v in pairs(playerData.accounts) do
			local accountTpl = '<div><img src="img/accounts/' .. v.name .. '.png"/>&nbsp;{{money}}</div>'
			ESX.UI.HUD.RegisterElement('account_' .. v.name, k, 0, accountTpl, {money = ESX.Math.GroupDigits(v.money)})
		end

		local jobTpl = '<div>{{job_label}} - {{grade_label}}</div>'

		if playerData.job.grade_label == '' or playerData.job.grade_label == playerData.job.label then
			jobTpl = '<div>{{job_label}}</div>'
		end

		ESX.UI.HUD.RegisterElement('job', #playerData.accounts, 0, jobTpl, {
			job_label = playerData.job.label,
			grade_label = playerData.job.grade_label
		})
	end

	-- Using spawnmanager now to spawn the player, this is the right way to do it, and it transitions better.
	--if not Config.kashcharacterEnabled then
		exports.spawnmanager:spawnPlayer({
			x = playerData.coords.x,
			y = playerData.coords.y,
			z = playerData.coords.z,
			heading = playerData.coords.heading,
			model = Config.DefaultPlayerModel,
			skipFade = false
		}, function()
			isLoadoutLoaded = true
			TriggerServerEvent('esx:onPlayerSpawn')
			TriggerEvent('esx:onPlayerSpawn')
			TriggerEvent('esx:restoreLoadout')
		end)
	--else
	--	isLoadoutLoaded = true
	--	TriggerServerEvent('esx:onPlayerSpawn')
	--	TriggerEvent('esx:onPlayerSpawn')
	--	TriggerEvent('esx:restoreLoadout')
	--end
	local wpercent = (playerData.weight / playerData.maxWeight) * 100

	Citizen.CreateThread(function()     
		DisablePlayerVehicleRewards(-1)
		RemoveWeaponDrops()
		Citizen.CreateThread(function()
			while true do Wait(0)
				if IsPedInAnyPoliceVehicle(PlayerPedId()) or IsPedInAnyHeli(PlayerPedId()) then
					DisablePlayerVehicleRewards(PlayerId())
				end
			end
		end)
	end)
end)

RegisterNetEvent('es:activateMoney')
AddEventHandler('es:activateMoney', function(money)
	ESX.PlayerData.money = money
end)

RegisterNetEvent('esx:setMaxWeight')
AddEventHandler('esx:setMaxWeight', function(newMaxWeight) ESX.PlayerData.maxWeight = newMaxWeight end)

AddEventHandler('esx:onPlayerSpawn', function() isDead = false end) -- TODO Temporally
AddEventHandler('esx:onPlayerDeath', function() isDead = true end)

--AddEventHandler('skinchanger:loadDefaultModel', function() isLoadoutLoaded = false end)

--TODO poner en el futuro en un mejor sitio
function RemoveWeaponDrops()
	local pickupList = {"PICKUP_AMMO_BULLET_MP","PICKUP_AMMO_FIREWORK","PICKUP_AMMO_FLAREGUN","PICKUP_AMMO_GRENADELAUNCHER","PICKUP_AMMO_GRENADELAUNCHER_MP","PICKUP_AMMO_HOMINGLAUNCHER","PICKUP_AMMO_MG","PICKUP_AMMO_MINIGUN","PICKUP_AMMO_MISSILE_MP","PICKUP_AMMO_PISTOL","PICKUP_AMMO_RIFLE","PICKUP_AMMO_RPG","PICKUP_AMMO_SHOTGUN","PICKUP_AMMO_SMG","PICKUP_AMMO_SNIPER","PICKUP_ARMOUR_STANDARD","PICKUP_CAMERA","PICKUP_CUSTOM_SCRIPT","PICKUP_GANG_ATTACK_MONEY","PICKUP_HEALTH_SNACK","PICKUP_HEALTH_STANDARD","PICKUP_MONEY_CASE","PICKUP_MONEY_DEP_BAG","PICKUP_MONEY_MED_BAG","PICKUP_MONEY_PAPER_BAG","PICKUP_MONEY_PURSE","PICKUP_MONEY_SECURITY_CASE","PICKUP_MONEY_VARIABLE","PICKUP_MONEY_WALLET","PICKUP_PARACHUTE","PICKUP_PORTABLE_CRATE_FIXED_INCAR","PICKUP_PORTABLE_CRATE_UNFIXED","PICKUP_PORTABLE_CRATE_UNFIXED_INCAR","PICKUP_PORTABLE_CRATE_UNFIXED_INCAR_SMALL","PICKUP_PORTABLE_CRATE_UNFIXED_LOW_GLOW","PICKUP_PORTABLE_DLC_VEHICLE_PACKAGE","PICKUP_PORTABLE_PACKAGE","PICKUP_SUBMARINE","PICKUP_VEHICLE_ARMOUR_STANDARD","PICKUP_VEHICLE_CUSTOM_SCRIPT","PICKUP_VEHICLE_CUSTOM_SCRIPT_LOW_GLOW","PICKUP_VEHICLE_HEALTH_STANDARD","PICKUP_VEHICLE_HEALTH_STANDARD_LOW_GLOW","PICKUP_VEHICLE_MONEY_VARIABLE","PICKUP_VEHICLE_WEAPON_APPISTOL","PICKUP_VEHICLE_WEAPON_ASSAULTSMG","PICKUP_VEHICLE_WEAPON_COMBATPISTOL","PICKUP_VEHICLE_WEAPON_GRENADE","PICKUP_VEHICLE_WEAPON_MICROSMG","PICKUP_VEHICLE_WEAPON_MOLOTOV","PICKUP_VEHICLE_WEAPON_PISTOL","PICKUP_VEHICLE_WEAPON_PISTOL50","PICKUP_VEHICLE_WEAPON_SAWNOFF","PICKUP_VEHICLE_WEAPON_SMG","PICKUP_VEHICLE_WEAPON_SMOKEGRENADE","PICKUP_VEHICLE_WEAPON_STICKYBOMB","PICKUP_WEAPON_ADVANCEDRIFLE","PICKUP_WEAPON_APPISTOL","PICKUP_WEAPON_ASSAULTRIFLE","PICKUP_WEAPON_ASSAULTSHOTGUN","PICKUP_WEAPON_ASSAULTSMG","PICKUP_WEAPON_AUTOSHOTGUN","PICKUP_WEAPON_BAT","PICKUP_WEAPON_BATTLEAXE","PICKUP_WEAPON_BOTTLE","PICKUP_WEAPON_BULLPUPRIFLE","PICKUP_WEAPON_BULLPUPSHOTGUN","PICKUP_WEAPON_CARBINERIFLE","PICKUP_WEAPON_COMBATMG","PICKUP_WEAPON_COMBATPDW","PICKUP_WEAPON_COMBATPISTOL","PICKUP_WEAPON_COMPACTLAUNCHER","PICKUP_WEAPON_COMPACTRIFLE","PICKUP_WEAPON_CROWBAR","PICKUP_WEAPON_DAGGER","PICKUP_WEAPON_DBSHOTGUN","PICKUP_WEAPON_FIREWORK","PICKUP_WEAPON_FLAREGUN","PICKUP_WEAPON_FLASHLIGHT","PICKUP_WEAPON_GRENADE","PICKUP_WEAPON_GRENADELAUNCHER","PICKUP_WEAPON_GUSENBERG","PICKUP_WEAPON_GOLFCLUB","PICKUP_WEAPON_HAMMER","PICKUP_WEAPON_HATCHET","PICKUP_WEAPON_HEAVYPISTOL","PICKUP_WEAPON_HEAVYSHOTGUN","PICKUP_WEAPON_HEAVYSNIPER","PICKUP_WEAPON_HOMINGLAUNCHER","PICKUP_WEAPON_KNIFE","PICKUP_WEAPON_KNUCKLE","PICKUP_WEAPON_MACHETE","PICKUP_WEAPON_MACHINEPISTOL","PICKUP_WEAPON_MARKSMANPISTOL","PICKUP_WEAPON_MARKSMANRIFLE","PICKUP_WEAPON_MG","PICKUP_WEAPON_MICROSMG","PICKUP_WEAPON_MINIGUN","PICKUP_WEAPON_MINISMG","PICKUP_WEAPON_MOLOTOV","PICKUP_WEAPON_MUSKET","PICKUP_WEAPON_NIGHTSTICK","PICKUP_WEAPON_PETROLCAN","PICKUP_WEAPON_PIPEBOMB","PICKUP_WEAPON_PISTOL","PICKUP_WEAPON_PISTOL50","PICKUP_WEAPON_POOLCUE","PICKUP_WEAPON_PROXMINE","PICKUP_WEAPON_PUMPSHOTGUN","PICKUP_WEAPON_RAILGUN","PICKUP_WEAPON_REVOLVER","PICKUP_WEAPON_RPG","PICKUP_WEAPON_SAWNOFFSHOTGUN","PICKUP_WEAPON_SMG","PICKUP_WEAPON_SMOKEGRENADE","PICKUP_WEAPON_SNIPERRIFLE","PICKUP_WEAPON_SNSPISTOL","PICKUP_WEAPON_SPECIALCARBINE","PICKUP_WEAPON_STICKYBOMB","PICKUP_WEAPON_STUNGUN","PICKUP_WEAPON_SWITCHBLADE","PICKUP_WEAPON_VINTAGEPISTOL","PICKUP_WEAPON_WRENCH", "PICKUP_WEAPON_RAYCARBINE"}
	for a = 1, #pickupList do
		N_0x616093ec6b139dd9(PlayerId(), GetHashKey(pickupList[a]), false)
	end
end

AddEventHandler('skinchanger:modelLoaded', function()
	while not ESX.PlayerLoaded do
		Wait(100)
	end

	TriggerEvent('esx:restoreLoadout')
end)

AddEventHandler('esx:restoreLoadout', function()
	local playerPed = PlayerPedId()
	local ammoTypes = {}

	RemoveAllPedWeapons(playerPed, true)

	for k,v in pairs(ESX.PlayerData.loadout) do
		local weaponName = v.name

		GiveWeaponToPed(playerPed, weaponName, 0, false, false)
		SetPedWeaponTintIndex(playerPed, weaponName, v.tintIndex)

		local ammoType = GetPedAmmoTypeFromWeapon(playerPed, weaponName)

		for k2,v2 in pairs(v.components) do
			local componentHash = ESX.GetWeaponComponent(weaponName, v2).hash

			GiveWeaponComponentToPed(playerPed, weaponName, componentHash)
		end

		if not ammoTypes[ammoType] then
			AddAmmoToPed(playerPed, weaponName, v.ammo)
			ammoTypes[ammoType] = true
		end
	end

	isLoadoutLoaded = true
end)

RegisterNetEvent('esx:setAccountMoney')
AddEventHandler('esx:setAccountMoney', function(account)
	for k,v in pairs(ESX.PlayerData.accounts) do
		if v.name == account.name then
			ESX.PlayerData.accounts[k] = account
			break
		end
	end

	if Config.EnableHud then
		ESX.UI.HUD.UpdateElement('account_' .. account.name, {
			money = ESX.Math.GroupDigits(account.money)
		})
	end
end)

RegisterNetEvent('esx:addInventoryItem')
AddEventHandler('esx:addInventoryItem', function(item, count, showNotification, newItem, wpercent)
	local found = false
	--print("PESO: "..wpercent)
	for k,v in pairs(ESX.PlayerData.inventory) do
		if v.name == item then
			ESX.UI.ShowInventoryItemNotification(true, v.name, count - v.count, v.label)
			ESX.PlayerData.inventory[k].count = count

			found = true
			break
		end
	end

	-- If the item wasn't found in your inventory -> run
	if(found == false and newItem --[[Just a check if there is a newItem]])then
		-- Add item newItem to the players inventory
		ESX.PlayerData.inventory[#ESX.PlayerData.inventory + 1] = {
			name = newItem.name,
			count = count,
			label = newItem.label,
			weight = newItem.weight,
			limit = newItem.limit,
			usable = newItem.usable,
			rare = newItem.rare,
			canRemove = newItem.canRemove
		}

		-- Show a notification that a new item was added
		ESX.UI.ShowInventoryItemNotification(true, newItem.name, count, newItem.label)
	else
		-- Don't show this error for now
		-- print("^1[ExtendedMode]^7 Error: there is an error while trying to add an item to the inventory, item name: " .. item)
	end

	if ESX.UI.Menu.IsOpen('default', 'es_extended', 'inventory') then
		ESX.ShowInventory()
	end
end)

RegisterNetEvent('esx:removeInventoryItem')
AddEventHandler('esx:removeInventoryItem', function(item, count, showNotification, wpercent)
	local label 
	for k,v in pairs(ESX.PlayerData.inventory) do
		if v.name == item then
			label = v.label
			ESX.UI.ShowInventoryItemNotification(false, v.name, v.count - count, v.label)
			ESX.PlayerData.inventory[k].count = count
			break
		end
	end

	if showNotification then
		ESX.UI.ShowInventoryItemNotification(false, item, count, label)
	end

	if ESX.UI.Menu.IsOpen('default', 'es_extended', 'inventory') then
		ESX.ShowInventory()
	end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

RegisterNetEvent('esx:addWeapon')
AddEventHandler('esx:addWeapon', function(weaponName, ammo)
	-- Removed PlayerPedId() from being stored in a variable, not needed
	-- when it's only being used once, also doing it in a few
	-- functions below this one
	GiveWeaponToPed(PlayerPedId(), weaponName, ammo, false, false)
end)

RegisterNetEvent('esx:addWeaponComponent')
AddEventHandler('esx:addWeaponComponent', function(weaponName, weaponComponent)
	local componentHash = ESX.GetWeaponComponent(weaponName, weaponComponent).hash
	GiveWeaponComponentToPed(PlayerPedId(), weaponName, componentHash)
end)

RegisterNetEvent('esx:setWeaponAmmo')
AddEventHandler('esx:setWeaponAmmo', function(weaponName, weaponAmmo)
	SetPedAmmo(PlayerPedId(), weaponName, weaponAmmo)
end)

RegisterNetEvent('esx:setWeaponTint')
AddEventHandler('esx:setWeaponTint', function(weaponName, weaponTintIndex)
	SetPedWeaponTintIndex(PlayerPedId(), weaponName, weaponTintIndex)
end)

RegisterNetEvent('esx:removeWeapon')
AddEventHandler('esx:removeWeapon', function(weaponName)
	local playerPed = PlayerPedId()
	RemoveWeaponFromPed(playerPed, weaponName)
	SetPedAmmo(playerPed, weaponName, 0) -- remove leftover ammo
end)

RegisterNetEvent('esx:removeWeaponComponent')
AddEventHandler('esx:removeWeaponComponent', function(weaponName, weaponComponent)
	local componentHash = ESX.GetWeaponComponent(weaponName, weaponComponent).hash
	RemoveWeaponComponentFromPed(PlayerPedId(), weaponName, componentHash)
end)

RegisterNetEvent('esx:teleport')
AddEventHandler('esx:teleport', function(coords)
	-- The coords x, y and z were having 0.0 added to them here to make them floats
	-- Since we are forcing vectors in the teleport function now we don't need to do it
	ESX.Game.Teleport(PlayerPedId(), coords)
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	if Config.EnableHud then
		ESX.UI.HUD.UpdateElement('job', {
			job_label   = job.label,
			grade_label = job.grade_label
		})
	end
end)

RegisterNetEvent('esx:spawnVehicle')
AddEventHandler('esx:spawnVehicle', function(vehicle)
	if IsModelInCdimage(vehicle) then
		local playerPed = PlayerPedId()
		local playerCoords, playerHeading = GetEntityCoords(playerPed), GetEntityHeading(playerPed)

		ESX.Game.SpawnVehicle(vehicle, playerCoords, playerHeading, function(vehicle)
			TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
			TriggerServerEvent('garage:addKeys', GetVehicleNumberPlateText(vehicle))
		end, true)
	else
		TriggerEvent('chat:addMessage', { args = { '^1SYSTEM', 'Invalid vehicle model.' } })
	end
end)

-- Removed drawing pickups here immediately and decided to add them to a table instead
-- Also made createMissingPickups use the other pickup function instead of having the
-- same code twice, further down we cull pickups when not needed

function AddPickup(pickupId, pickupLabel, pickupCoords, pickupType, pickupName, pickupComponents, pickupTint, pickupmodel)
	pickups[pickupId] = {
		label = pickupLabel,
		textRange = false,
		coords = pickupCoords,
		type = pickupType,
		name = pickupName,
		components = pickupComponents,
		tint = pickupTint,
		object = nil,
		deleteNow = false,
		model = pickupmodel
	}
end

RegisterNetEvent('esx:createPickup')
AddEventHandler('esx:createPickup', function(pickupId, label, playerId, pickupType, name, components, tintIndex, isInfinity, pickupCoords, model)
    local playerPed, entityCoords, forward, objectCoords
    
    if isInfinity then
        objectCoords = pickupCoords
    else
        playerPed = GetPlayerPed(GetPlayerFromServerId(playerId))
        entityCoords = GetEntityCoords(playerPed)
        forward = GetEntityForwardVector(playerPed)
        objectCoords = (entityCoords + forward * 1.0)
    end

    AddPickup(pickupId, label, objectCoords, pickupType, name, components, tintIndex, model)
end)

RegisterNetEvent('esx:createMissingPickups')
AddEventHandler('esx:createMissingPickups', function(missingPickups)
	for pickupId, pickup in pairs(missingPickups) do
		AddPickup(pickupId, pickup.label, vec(pickup.coords.x, pickup.coords.y, pickup.coords.z), pickup.type, pickup.name, pickup.components, pickup.tintIndex)
	end
end)

RegisterNetEvent('esx:registerSuggestions')
AddEventHandler('esx:registerSuggestions', function(registeredCommands)
	for name,command in pairs(registeredCommands) do
		if command.suggestion then
			TriggerEvent('chat:addSuggestion', ('/%s'):format(name), command.suggestion.help, command.suggestion.arguments)
		end
	end
end)

RegisterNetEvent('esx:removePickup')
AddEventHandler('esx:removePickup', function(id)
	local pickup = pickups[id]
	if pickup and pickup.object then
		ESX.Game.DeleteObject(pickup.object)
		if pickup.type == 'item_weapon' then
			RemoveWeaponAsset(pickup.name)
		else
			SetModelAsNoLongerNeeded(Config.DefaultPickupModel)
		end
		pickup.deleteNow = true
	end
end)

RegisterNetEvent('esx:setVehicleProperties')
AddEventHandler('esx:setVehicleProperties', function(vehNetId, props)
	--print("entityVeh:"..NetToVeh(vehNetId).. "props: "..props)
	Citizen.CreateThread(function() 
		while not DoesEntityExist(NetToVeh(vehNetId)) do
			Wait(500)
		end
		ESX.Game.SetVehiclePropertiesToThisVehicle(NetToVeh(vehNetId) ,props)
	end)
	
end)

RegisterNetEvent("esx:setVehicleDoorState")
AddEventHandler("esx:setVehicleDoorState", function(vehNetId, doorState) 
	SetVehicleDoorsLocked(NetToVeh(vehNetId), doorState)
end)


RegisterNetEvent('esx:deleteVehicle')
AddEventHandler('esx:deleteVehicle', function(radius)
	local playerPed = PlayerPedId()

	if radius and tonumber(radius) then
		radius = tonumber(radius) + 0.01
		local vehicles = ESX.Game.GetVehiclesInArea(GetEntityCoords(playerPed), radius)

		for k,entity in pairs(vehicles) do
			local attempt = 0

			while not NetworkHasControlOfEntity(entity) and attempt < 100 and DoesEntityExist(entity) do
				Wait(100)
				NetworkRequestControlOfEntity(entity)
				attempt = attempt + 1
			end

			if DoesEntityExist(entity) and NetworkHasControlOfEntity(entity) then
				ESX.Game.DeleteVehicle(entity)
			end
		end
	else
		local vehicle, attempt = ESX.Game.GetVehicleInDirection(), 0

		if IsPedInAnyVehicle(playerPed, true) then
			vehicle = GetVehiclePedIsIn(playerPed, false)
		end

		while not NetworkHasControlOfEntity(vehicle) and attempt < 100 and DoesEntityExist(vehicle) do
			Wait(100)
			NetworkRequestControlOfEntity(vehicle)
			attempt = attempt + 1
		end

		if DoesEntityExist(vehicle) and NetworkHasControlOfEntity(vehicle) then
			ESX.Game.DeleteVehicle(vehicle)
		end
	end
end)

-- Pause menu disables HUD display
if Config.EnableHud then
	CreateThread(function()
		while true do
			Wait(300)

			if IsPauseMenuActive() and not isPaused then
				isPaused = true
				ESX.UI.HUD.SetDisplay(0.0)
			elseif not IsPauseMenuActive() and isPaused then
				isPaused = false
				ESX.UI.HUD.SetDisplay(1.0)
			end
		end
	end)
end

-- Keep track of ammo usage
CreateThread(function()
	while true do
		Wait(0)

		if isDead then
			Wait(1500)
		else
			local playerPed = PlayerPedId()

			if IsPedShooting(playerPed) then
				local _, weaponHash = GetCurrentPedWeapon(playerPed, true)
				local weapon = ESX.GetWeaponFromHash(weaponHash)

				if weapon then
					Wait(500)
					local ammoCount = GetAmmoInPedWeapon(playerPed, weaponHash)
					TriggerServerEvent('esx:updateWeaponAmmo', weapon.name, ammoCount)
				end
			end
		end
	end
end)

--CreateThread(function()
--	while true do
--		Wait(0)
--
--		if isDead then
--			Wait(500)
--		else
--			local playerPed = PlayerPedId()
--
--			if IsPedShooting(playerPed) then
--				local _, weaponHash = GetCurrentPedWeapon(playerPed, true)
--				local weapon = ESX.GetWeaponFromHash(weaponHash)
--
--				if weapon then
--					local ammoCount = GetAmmoInPedWeapon(playerPed, weaponHash)
--					TriggerServerEvent('esx:updateWeaponAmmo', weapon.name, ammoCount)
--				end
--			end
--		end
--	end
--end)

CreateThread(function()
	while true do -- Reducido el daño 
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_UNARMED"), 0.1) 
		Wait(0)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_NIGHTSTICK"), 0.2)
		Wait(0)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_BAT"), 0.23)
        Wait(0)
        N_0x4757f00bc6323cfe(GetHashKey("WEAPON_HAMMER"), 0.23)
        Wait(0)
        N_0x4757f00bc6323cfe(GetHashKey("WEAPON_HAMMER"), 0.23)
        Wait(0)
        N_0x4757f00bc6323cfe(GetHashKey("WEAPON_GOLFCLUB "), 0.23)
        Wait(0)
        N_0x4757f00bc6323cfe(GetHashKey("WEAPON_CROWBAR"), 0.23)
		Wait(0)
		N_0x4757f00bc6323cfe(GetHashKey("WEAPON_FLASHLIGHT"), 0.1)
	end
end)

--CreateThread(function()
--	while true do
--		Wait(0)
--
--		if IsControlJustReleased(0, 289) then
--			print("Released")
--			if ESX.UI.Menu.IsOpen('default', 'es_extended', 'inventory') then
--				print("Already opened")
--			end
--			if IsInputDisabled(0) and not isDead and not ESX.UI.Menu.IsOpen('default', 'es_extended', 'inventory') then
--				print("Opening")
--				ESX.ShowInventory()
--			end
--		end
--	end
--end)

-- Disable wanted level
if Config.DisableWantedLevel then
	-- Previous they were creating a contstantly running loop to check if the wanted level
	-- changed and then setting back to 0. This is all thats needed to disable a wanted level.
	SetMaxWantedLevel(0)
end

-- Pickups
CreateThread(function()
	while true do
		Wait(0)
		local playerPed = PlayerPedId()
		local playerCoords, letSleep = GetEntityCoords(playerPed), true
		-- For whatever reason there was a constant check to get the closest player here when it
		-- wasn't even being used
		
		-- Major refactor here, this culls the pickups if not within range.

		for pickupId, pickup in pairs(pickups) do
			local distance = #(playerCoords - pickup.coords)
			if pickup.deleteNow then
				pickup = nil
			else
				if distance < 50 then
					if not DoesEntityExist(pickup.object) then
						letSleep = false
						if pickup.type == 'item_weapon' then
							ESX.Streaming.RequestWeaponAsset(pickup.name)
							pickup.object = CreateWeaponObject(pickup.name, 50, pickup.coords, true, 1.0, 0)
							SetWeaponObjectTintIndex(pickup.object, pickup.tint)

							for _, comp in pairs(pickup.components) do
								local component = ESX.GetWeaponComponent(pickup.name, comp)
								GiveWeaponComponentToWeaponObject(pickup.object, component.hash)
							end
							
							SetEntityAsMissionEntity(pickup.object, true, false)
							PlaceObjectOnGroundProperly(pickup.object)
							SetEntityRotation(pickup.object, 90.0, 0.0, 0.0)
							local model = GetEntityModel(pickup.object)
							local heightAbove = GetEntityHeightAboveGround(pickup.object)
							local currentCoords = GetEntityCoords(pickup.object)
							local modelDimensionMin, modelDimensionMax = GetModelDimensions(model)
							local size = (modelDimensionMax.y - modelDimensionMin.y) / 2
							SetEntityCoords(pickup.object, currentCoords.x, currentCoords.y, (currentCoords.z - heightAbove) + size)
						else
							if pickup.model ~= nil then
								ESX.Game.SpawnLocalObject(pickup.model , pickup.coords, function(obj)
									pickup.object = obj
								end)
							else
								ESX.Game.SpawnLocalObject(Config.DefaultPickupModel, pickup.coords, function(obj)
									pickup.object = obj
								end)
							end
							

							while not pickup.object do
								Wait(200)
							end
							Wait(100)
							SetEntityAsMissionEntity(pickup.object, true, false)
							PlaceObjectOnGroundProperly(pickup.object)
						end

						FreezeEntityPosition(pickup.object, true)
						SetEntityCollision(pickup.object, false, true)
					end
				else
					if DoesEntityExist(pickup.object) then
						DeleteObject(pickup.object)
						if pickup.type == 'item_weapon' then
							RemoveWeaponAsset(pickup.name)
						else
							SetModelAsNoLongerNeeded(Config.DefaultPickupModel)
						end
					end
				end
				
				if distance < 5 then
					local label = pickup.label
					letSleep = false

					if distance < 1 then
						if IsControlJustReleased(0, 38) then
							-- Removed the closestDistance check here, not needed
							if IsPedOnFoot(playerPed) and not pickup.textRange then
								pickup.textRange = true

								local dict, anim = 'weapons@first_person@aim_rng@generic@projectile@sticky_bomb@', 'plant_floor'
								-- Lets use our new function instead of manually doing it
								ExM.Game.PlayAnim(dict, anim, true, 1000)
								Wait(1000)

								TriggerServerEvent('esx:onPickup', pickupId)
								PlaySoundFrontend(-1, 'PICK_UP', 'HUD_FRONTEND_DEFAULT_SOUNDSET', false)
							end
						end

						label = ('%s~n~%s'):format(label, _U('standard_pickup_prompt'))
					end
					
					local pickupCoords = GetEntityCoords(pickup.object)
					ESX.Game.Utils.DrawText3D(vec(pickupCoords.x, pickupCoords.y, pickupCoords.z + 0.5), label, 1.2, 4)
				elseif pickup.textRange then
					pickup.textRange = false
				end
			end
		end

		if letSleep then
			Wait(500)
		end
	end
end)

-- Update current player coords
CreateThread(function()
	-- wait for player to restore coords
	while not isLoadoutLoaded do
		Wait(1000)
	end
	
	local previousCoords = vector3(ESX.PlayerData.coords.x, ESX.PlayerData.coords.y, ESX.PlayerData.coords.z)
	local playerHeading = ESX.PlayerData.heading
	local formattedCoords = {x = ESX.Math.Round(previousCoords.x, 1), y = ESX.Math.Round(previousCoords.y, 1), z = ESX.Math.Round(previousCoords.z, 1), heading = playerHeading}

	while true do
		-- update the players position every second instead of a configed amount otherwise
		-- serverside won't catch up
		Wait(1000)
		local playerPed = PlayerPedId()
		local playerCoords = GetEntityCoords(playerPed)
		local distance = #(playerCoords - previousCoords)

		if distance > 5 then
			previousCoords = playerCoords
			playerHeading = ESX.Math.Round(GetEntityHeading(playerPed), 1)
			formattedCoords = {x = ESX.Math.Round(playerCoords.x, 1), y = ESX.Math.Round(playerCoords.y, 1), z = ESX.Math.Round(playerCoords.z, 1), heading = playerHeading}
			TriggerServerEvent('esx:updateCoords', formattedCoords)
			if distance > 1 then
				TriggerServerEvent('esx:updateCoords', formattedCoords)
			end
		end
	end
end)

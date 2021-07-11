function CreateExtendedCar(model, class, plate, ownerId, ownerIdentifier, coords, carProperties, inventory, job,  state, variables)
	--TODO AÑADIR A ESX.VEHICLES source, model, vehicleprops, plate, source, xPlayer.getIdentifier(), {}, 0, 100, nil, vector3(pos.x,pos.y,pos.z)
	local self = {}
	local functions = {}

	self.entity = nil
	self.class = class
    self.netId = nil
	self.model = model
	self.vehIndentifier = GetHashKey(plate)
	self.coords = vector3(coords.x, coords.y,coords.z)
	self.weight = 0
	self.maxWeight = Config.VehicleWeightLimit[class]
	self.OwnerId = ownerId
	self.PlayerOwner = ownerIdentifier
	self.spawned = false
	self.pendingToSpawn = false

	if type(coords) == "vector3" then
		self.heading = false
	elseif type(coords) == "table" then
		if coords.h then
			self.heading = coords.h
		end
		if coords.w then
			self.heading = coords.w
		end
	elseif type(coords) == "vector4" then
		self.heading = coords.w
	end
	

	self.plate = plate

	if inventory then
		self.inventory = inventory
	else
		self.inventory = {}
	end
	if job then
		self.job = job
	else
		self.job = ""
	end

	if carProperties then
		self.properties = carProperties
		self.properties.plate = self.plate
	else
		self.properties = {}
	end
	if variables then
		self.variables = variables
	else
		self.variables = {}
	end

	if state then
		self.state = state
	else
		self.state = ESX.VehiclesStates.permissive.STANDARD
	end

	self.doorState = ESX.VehicleLockStatus.Unlocked
	
	for k,v in pairs(self.variables) do
		self[k] = v
	end

	functions.plate = plate
	





	functions.refreshDoorState = function()
		functions.triggerEvent("esx:setVehicleDoorState", self.doorState)
	end

	functions.updateEngineHealth = function(health)
		if DoesEntityExist(self.entity) then
			if health and type(health) == "number" then
				self.properties.engineHealth = health
				functions.refreshProperties()
			elseif not health then
				self.properties.engineHealth = GetVehicleEngineHealth(self.entity)
			end
		end
	end

	functions.updateBodyHealth = function(health)
		if DoesEntityExist(self.entity) then
			if health and type(health) == "number" then
				self.properties.bodyHealth = health
				functions.refreshProperties()
			elseif not health then
				self.properties.bodyHealth = GetVehicleEngineHealth(self.entity)
			end
		end
	end

	functions.getEngineHealth = function()
		return self.properties.engineHealth
	end

	functions.getBodyHealth = function()
		return self.properties.bodyHealth
	end


	functions.setHeading = function(coords)
		if type(coords) == "vector3" then
			self.heading = false
		elseif type(coords) == "table" then
			if coords.h then
				self.heading = coords.h
			end
		elseif type(coords) == "vector4" then
			self.heading = coords.w
		end
		if self.heading and DoesEntityExist(self.entity) then
			SetEntityHeading(self.entity, self.heading)
		end
	end

	functions.setVehicleDoorState = function(doorState)
		for k,v in pairs(ESX.VehicleLockStatus) do
			if v == doorState then
				self.doorState = doorState
				functions.triggerEvent("esx:setVehicleDoorState", self.netId, doorState)
				return true
			end
		end
		return false
	end

	functions.warpPed = function(ped, seat)
		if DoesEntityExist(ped) and DoesEntityExist(self.entity) then
			--TODO CHECK VALID SEAT?
			TaskWarpPedIntoVehicle(ped, self.entity, seat)
		end
	end

	functions.getVehicleDoorState = function()
		return self.doorState
	end
	functions.afterSpawn = function()
		FreezeEntityPosition(self.entity, self.variables.freezed)
		functions.triggerEvent("esx:setVehicleDoorState", self.netId, self.doorState)
	end

	functions.deSpawn = function()
		if DoesEntityExist(self.entity) then
			DeleteEntity(self.entity)
			self.entity = false
			self.netId = false
			self.spawned = false
		end
	end

	functions.getVariables = function()
		return self.variables
	end

	functions.getClass = function()
		return self.class
	end

	functions.getState = function()
		return self.state
	end

	functions.getSaveableData = function()
		if self.spawned and DoesEntityExist(self.entity) then
			self.heading = GetEntityHeading(self.entity)
			Wait(50)
			local cco = GetEntityCoords(self.entity)
			self.coords = vector4(cco.x, cco.y,cco.z, self.heading)
		end
		self.variables.doorState = self.doorState
		local saveable = {
			model = functions.getModel(),
			class = functions.getClass(),
			coords = functions.getCoords(),
			plate = functions.plate,
			inventory = functions.getInventory(),
			job = functions.getJob(),
			props = functions.getVehicleProperties(),
			maxWeight = functions.getMaxWeight(),
			owner = functions.getPlayerOwner(),
			variables = functions.getVariables(),
			state = functions.getState()
		}
		return saveable
	end

	functions.getPlayerOwner = function()
		return self.PlayerOwner
	end

	functions.isSpawned = function()
		return self.spawned
	end

	functions.triggerEvent = function(eventName, ...)
		print("owner id: "..functions.getNetOwnerId() )
		if functions.getNetOwnerId() ~= -1 and functions.getNetOwnerId() ~= 0 then
			print("owner id: "..functions.getNetOwnerId().." Entity:".. self.entity)
			TriggerClientEvent(eventName, functions.getNetOwnerId(), ...)
		else
			Citizen.CreateThread(functions.pendingTrigger(eventName, ...))
		end
	end

	functions.pendingTrigger = function(eventName, ...)
		local PendingTrigger = true
		local PendingTriggerName = eventName
		while PendingTrigger do
			Wait(5000)
			print("owner id: "..functions.getNetOwnerId().." Entity:".. self.entity)
			if functions.getNetOwnerId() ~= -1 and functions.getNetOwnerId() ~= 0 then
				TriggerClientEvent(eventName, functions.getNetOwnerId(), ...)
				PendingTrigger = false
			end
		end
	end

	functions.setVariables = function(vars)
		self.variables = vars
	end

	functions.refreshProperties = function()
		functions.triggerEvent("esx:setVehicleProperties", self.netId, self.properties)
	end

	functions.setVehicleProperties = function(props)
		for k,v in pairs(props) do
			self.properties[k] = v
		end
		functions.triggerEvent("esx:setVehicleProperties", self.netId, props)
	end

	functions.getVehicleProperties = function()
		return self.properties
	end

	functions.getModel = function()
		return self.model
	end

	functions.getOwnerId = function()
		return self.OwnerId
	end

	functions.setOwnerId = function(ownerId)
		if ESX.Players[ownerId] then
			self.OwnerId = ownerId
		end
	end


	functions.getNetOwnerId = function()
		return NetworkGetEntityOwner(self.entity)
	end

	functions.setCoords = function(coords)
		functions.updateCoords(coords)
		functions.setHeading(coords)
		--local svId = NetworkGetEntityOwner(self.entity)
		if DoesEntityExist(self.entity) then
			SetEntityCoords(self.entity, coords.x, coords.y, coords.z)
		end
		--functions.triggerEvent("esx:setCarPos", coords)
        --if svId ~= self.NetworkOwner then
        --    self.NetworkOwner = svId
        --end
        --TriggerClientEvent("esx:setCarPos", self.NetworkOwner, coords)
	end

	functions.updateCoords = function(coords)
		--self.coords = {x = ESX.Math.Round(coords.x, 1), y = ESX.Math.Round(coords.y, 1), z = ESX.Math.Round(coords.z, 1), heading = ESX.Math.Round(coords.heading or 0.0, 1)}
		self.coords = coords
	end

	functions.getCoords = function(vector)
		if DoesEntityExist(self.entity) then
			local cco = GetEntityCoords(self.entity)
			Wait(50)
			self.heading = GetEntityHeading(self.entity)
			self.coords = vector4(cco.x, cco.y,cco.z, self.heading)
		end
		if vector then
			return vector4(self.coords.x, self.coords.y, self.coords.z, self.heading)
		else
			return self.coords
		end
	end

	functions.setMoney = function(money, recursion)
		money = ESX.Math.Round(money)
		functions.setAccountMoney('money', money)

		if(not recursion)then
			TriggerEvent("es:getPlayerFromId", self.source, function(user) user.setMoney(money) end)
		end
	end

	functions.getMoney = function()
		return functions.getAccount('money').money
	end

	functions.addMoney = function(money, recursion)
		money = ESX.Math.Round(money)
		functions.addAccountMoney('money', money)

		if(not recursion)then
			TriggerEvent("es:getPlayerFromId", self.source, function(user) user.addMoney(money, true) end)
		end
	end

	functions.removeMoney = function(money, recursion)
		if(not recursion)then
			TriggerEvent("es:getPlayerFromId", self.source, function(user) user.removeMoney(money, true) end)
		end

		money = ESX.Math.Round(money)
		functions.removeAccountMoney('money', money)
	end

	functions.getIdentifier = function()
		return self.identifier
	end

	functions.setGroup = function(newGroup, recursion)
		if(not recursion)then
			TriggerEvent("es:getPlayerFromId", self.source, function(user) user.set("group", newGroup) end)
		end

		ExecuteCommand(('remove_principal identifier.%s group.%s'):format(self.identifier, self.group))
		self.group = newGroup
		ExecuteCommand(('add_principal identifier.%s group.%s'):format(self.identifier, self.group))
	end

	functions.getGroup = function()
		return self.group
	end

	functions.set = function(k, v, recursion)
		if(not recursion)then
			TriggerEvent("es:getPlayerFromId", self.source, function(user) if(user)then user.set(k, v) end end)
		end

		self.variables[k] = v
	end

	functions.get = function(k)
		return self.variables[k]
	end

	functions.getAccounts = function(minimal)
		if minimal then
			local minimalAccounts = {}

			for k,v in pairs(self.accounts) do
				minimalAccounts[v.name] = v.money
			end

			return minimalAccounts
		else
			return self.accounts
		end
	end

	functions.getAccount = function(account)
		for k,v in pairs(self.accounts) do
			if v.name == account then
				return v
			end
		end
	end

	functions.getInventory = function(minimal)
		if minimal then
			local minimalInventory = {}

			for k,v in pairs(self.inventory) do
				if v.count > 0 then
					minimalInventory[v.name] = v.count
				end
			end

			return minimalInventory
		else
			return self.inventory
		end
	end

	functions.getJob = function()
		if self.job then
			return self.job
		end
		return ""
	end

	functions.getLoadout = function(minimal)
		if minimal then
			local minimalLoadout = {}

			for k,v in pairs(self.loadout) do
				minimalLoadout[v.name] = {ammo = v.ammo}
				if v.tintIndex > 0 then minimalLoadout[v.name].tintIndex = v.tintIndex end

				if #v.components > 0 then
					local components = {}

					for k2,component in pairs(v.components) do
						if component ~= 'clip_default' then
							table.insert(components, component)
						end
					end

					if #components > 0 then
						minimalLoadout[v.name].components = components
					end
				end
			end

			return minimalLoadout
		else
			return self.loadout
		end
	end

	functions.getName = function()
		return self.name
	end

	functions.setName = function(newName)
		self.name = newName
	end

	functions.setAccountMoney = function(accountName, money)
		if money >= 0 then
			local account = functions.getAccount(accountName)

			if account then
				local prevMoney = account.money
				local newMoney = ESX.Math.Round(money)
				account.money = newMoney

				functions.triggerEvent('esx:setAccountMoney', account)
			end
		end
	end

	functions.addAccountMoney = function(accountName, money)
		if money > 0 then
			local account = functions.getAccount(accountName)

			if account then
				local newMoney = account.money + ESX.Math.Round(money)
				account.money = newMoney

				functions.triggerEvent('esx:setAccountMoney', account)
			end
		end
	end

	functions.removeAccountMoney = function(accountName, money)
		if money > 0 then
			local account = functions.getAccount(accountName)

			if account then
				local newMoney = account.money - ESX.Math.Round(money)
				account.money = newMoney

				functions.triggerEvent('esx:setAccountMoney', account)
			end
		end
	end

	functions.getInventoryItem = function(name)
		local found = false
		local newItem

		for k,v in pairs(self.inventory) do
			if v.name == name then
				found = true
				return v
			end
		end

		-- Ran only if the item wasn't found in your inventory
		local item = ESX.Items[name]

		-- if item exists -> run
		if(item)then
			-- Create new item
			newItem = {
				name = name,
				count = 0,
				label = item.label,
				weight = item.weight,
				limit = item.limit,
				usable = ESX.UsableItemsCallbacks[name] ~= nil,
				rare = item.rare,
				canRemove = item.canRemove,
				prop = item.prop
			}

			-- Insert into players inventory
			table.insert(self.inventory, newItem)

			-- Return the item that was just added
			return newItem
		end

		return
	end

	functions.addInventoryItem = function(name, count)
		local item = functions.getInventoryItem(name)

		if item then
			count = ESX.Math.Round(count)
			item.count = item.count + count
			self.weight = self.weight + (item.weight * count)

			TriggerEvent('esx:onAddInventoryItem', self.source, item.name, item.count)
			functions.triggerEvent('esx:addInventoryItem', item.name, item.count, false, item)
		end
	end

	functions.removeInventoryItem = function(name, count)
		local item = functions.getInventoryItem(name)

		if item then
			count = ESX.Math.Round(count)
			local newCount = item.count - count

			if newCount >= 0 then
				item.count = newCount
				self.weight = self.weight - (item.weight * count)

				TriggerEvent('esx:onRemoveInventoryItem', self.source, item.name, item.count)
				functions.triggerEvent('esx:removeInventoryItem', item.name, item.count)
			end
		end
	end

	functions.setInventoryItem = function(name, count)
		local item = functions.getInventoryItem(name)

		if item and count >= 0 then
			count = ESX.Math.Round(count)

			if count > item.count then
				functions.addInventoryItem(item.name, count - item.count)
			else
				functions.removeInventoryItem(item.name, item.count - count)
			end
		end
	end

	functions.getWeight = function()
		return self.weight
	end

	functions.getMaxWeight = function()
		return self.maxWeight
	end

	functions.canCarryItem = function(name, count)
		local currentWeight, itemWeight = self.weight, ESX.Items[name].weight
		local newWeight = currentWeight + (itemWeight * count)
		local inventoryitem = functions.getInventoryItem(name)

		if ESX.Items[name].limit ~= nil and ESX.Items[name].limit ~= -1 then
			if count > ESX.Items[name].limit then
				return false
			elseif (inventoryitem.count + count) > ESX.Items[name].limit then
				return false
			end
		end
		return newWeight <= self.maxWeight
	end

	functions.canCarryWeapon = function(name)
		local weight = ESX.GetWeaponWeight(name)
		local currentWeight, itemWeight = self.weight, weight
		local newWeight = currentWeight + itemWeight
		return newWeight <= self.maxWeight
	end

	functions.canSwapItem = function(firstItem, firstItemCount, testItem, testItemCount)
		local firstItemObject = functions.getInventoryItem(firstItem)
		local testItemObject = functions.getInventoryItem(testItem)

		if firstItemObject.count >= firstItemCount then
			local weightWithoutFirstItem = ESX.Math.Round(self.weight - (firstItemObject.weight * firstItemCount))
			local weightWithTestItem = ESX.Math.Round(weightWithoutFirstItem + (testItemObject.weight * testItemCount))

			return weightWithTestItem <= self.maxWeight
		end

		return false
	end

	functions.setMaxWeight = function(newWeight)
		self.maxWeight = newWeight
		functions.triggerEvent('esx:setMaxWeight', self.maxWeight)
	end


	functions.freeze = function(state)
		if DoesEntityExist(self.entity) then
			FreezeEntityPosition(self.entity, state)
			self.variables.freezed = state
			return true
		else
			return false
		end
	end

	functions.isfreezed = function()
		return self.variables.freezed
	end

	functions.setJob = function(job, grade)
		grade = tostring(grade)
		local lastJob = json.decode(json.encode(self.job))

		if ESX.DoesJobExist(job, grade) then
			local jobObject, gradeObject = ESX.Jobs[job], ESX.Jobs[job].grades[grade]

			self.job.id    = jobObject.id
			self.job.name  = jobObject.name
			self.job.label = jobObject.label

			self.job.grade        = tonumber(grade)
			self.job.grade_name   = gradeObject.name
			self.job.grade_label  = gradeObject.label
			self.job.grade_salary = gradeObject.salary

			if gradeObject.skin_male then
				self.job.skin_male = gradeObject.skin_male
			else
				self.job.skin_male = {}
			end

			if gradeObject.skin_female then
				self.job.skin_female = gradeObject.skin_female
			else
				self.job.skin_female = {}
			end

			TriggerEvent('esx:setJob', self.source, self.job, lastJob)
			functions.triggerEvent('esx:setJob', self.job)
		else
			print(('[ExtendedMode] [^3WARNING^7] Ignoring invalid .setJob() usage for "%s"'):format(self.identifier))
		end
	end

	functions.addWeapon = function(weaponName, ammo)
		if not functions.hasWeapon(weaponName) then
			local weaponLabel = ESX.GetWeaponLabel(weaponName)
			local weaponWeight = ESX.GetWeaponWeight(weaponName)
			table.insert(self.loadout, {
				name = weaponName,
				ammo = ammo,
				label = weaponLabel,
				components = {},
				tintIndex = 0,
				weight = weaponWeight,
			})

			functions.triggerEvent('esx:addWeapon', weaponName, ammo)
			functions.triggerEvent('esx:addInventoryItem', weaponLabel, false, true)
			self.weight = self.weight + weaponWeight
		end
	end

	functions.addWeaponComponent = function(weaponName, weaponComponent)
		local loadoutNum, weapon = functions.getWeapon(weaponName)

		if weapon then
			local component = ESX.GetWeaponComponent(weaponName, weaponComponent)

			if component then
				if not functions.hasWeaponComponent(weaponName, weaponComponent) then
					table.insert(self.loadout[loadoutNum].components, weaponComponent)
					functions.triggerEvent('esx:addWeaponComponent', weaponName, weaponComponent)
					functions.triggerEvent('esx:addInventoryItem', component.label, false, true)
				end
			end
		end
	end

	functions.addWeaponAmmo = function(weaponName, ammoCount)
		local loadoutNum, weapon = functions.getWeapon(weaponName)

		if weapon then
			weapon.ammo = weapon.ammo + ammoCount
			functions.triggerEvent('esx:setWeaponAmmo', weaponName, weapon.ammo)
		end
	end

	functions.updateWeaponAmmo = function(weaponName, ammoCount)
		local loadoutNum, weapon = functions.getWeapon(weaponName)

		if weapon then
			if ammoCount < weapon.ammo then
				weapon.ammo = ammoCount
			end
		end
	end

	functions.setWeaponTint = function(weaponName, weaponTintIndex)
		local loadoutNum, weapon = functions.getWeapon(weaponName)

		if weapon then
			local weaponNum, weaponObject = ESX.GetWeapon(weaponName)

			if weaponObject.tints and weaponObject.tints[weaponTintIndex] then
				self.loadout[loadoutNum].tintIndex = weaponTintIndex
				functions.triggerEvent('esx:setWeaponTint', weaponName, weaponTintIndex)
				functions.triggerEvent('esx:addInventoryItem', weaponObject.tints[weaponTintIndex], false, true)
			end
		end
	end

	functions.getWeaponTint = function(weaponName)
		local loadoutNum, weapon = functions.getWeapon(weaponName)

		if weapon then
			return weapon.tintIndex
		end

		return 0
	end

	functions.removeWeapon = function(weaponName)
		local weaponLabel
		local weaponWeight
		for k,v in pairs(self.loadout) do
			if v.name == weaponName then
				weaponLabel = v.label
				weaponWeight = v.weight

				for k2,v2 in pairs(v.components) do
					functions.removeWeaponComponent(weaponName, v2)
				end

				self.weight = self.weight - weaponWeight
				table.remove(self.loadout, k)
				break
			end
		end

		if weaponLabel then
			functions.triggerEvent('esx:removeWeapon', weaponName)
			functions.triggerEvent('esx:removeInventoryItem', weaponLabel, false, true)
		end
	end

	functions.removeWeaponComponent = function(weaponName, weaponComponent)
		local loadoutNum, weapon = functions.getWeapon(weaponName)

		if weapon then
			local component = ESX.GetWeaponComponent(weaponName, weaponComponent)

			if component then
				if functions.hasWeaponComponent(weaponName, weaponComponent) then
					for k,v in pairs(self.loadout[loadoutNum].components) do
						if v == weaponComponent then
							table.remove(self.loadout[loadoutNum].components, k)
							break
						end
					end

					functions.triggerEvent('esx:removeWeaponComponent', weaponName, weaponComponent)
					functions.triggerEvent('esx:removeInventoryItem', component.label, false, true)
				end
			end
		end
	end

	functions.removeWeaponAmmo = function(weaponName, ammoCount)
		local loadoutNum, weapon = functions.getWeapon(weaponName)

		if weapon then
			weapon.ammo = weapon.ammo - ammoCount
			functions.triggerEvent('esx:setWeaponAmmo', weaponName, weapon.ammo)
		end
	end

	functions.hasWeaponComponent = function(weaponName, weaponComponent)
		local loadoutNum, weapon = functions.getWeapon(weaponName)

		if weapon then
			for k,v in pairs(weapon.components) do
				if v == weaponComponent then
					return true
				end
			end

			return false
		else
			return false
		end
	end

	functions.hasWeapon = function(weaponName)
		for k,v in pairs(self.loadout) do
			if v.name == weaponName then
				return true
			end
		end

		return false
	end

	functions.getWeapon = function(weaponName)
		for k,v in pairs(self.loadout) do
			if v.name == weaponName then
				return k, v
			end
		end

		return
	end


	functions.isInPermissiveState = function()
		for k,v in pairs(ESX.VehiclesStates.permissive) do
			if self.state == v then
				return true
			end
		end
		return false
	end

	functions.showNotification = function(msg, flash, saveToBrief, hudColorIndex)
		functions.triggerEvent('esx:showNotification', msg, flash, saveToBrief, hudColorIndex)
	end

	functions.showHelpNotification = function(msg, thisFrame, beep, duration)
		functions.triggerEvent('esx:showHelpNotification', msg, thisFrame, beep, duration)
	end

	functions.isPossibleToSpawn = function()
		local players = GetPlayers()
		local comparedCoords = vector3(self.coords.xyz)
		if #players < 1 then
			return false
		elseif self.OwnerId then
			print(#(GetEntityCoords(GetPlayerPed(self.OwnerId)) - comparedCoords))
			if #(GetEntityCoords(GetPlayerPed(self.OwnerId)) - comparedCoords) < 350 then
				return true
			else
				for k,v in pairs(players) do
					print(#(GetEntityCoords(GetPlayerPed(v)) - comparedCoords))
					if #(GetEntityCoords(GetPlayerPed(v)) - comparedCoords) < 350 then
						return true
					end
				end
				return false
			end		
		else
			for k,v in pairs(players) do
				print(#(GetEntityCoords(GetPlayerPed(v)) - comparedCoords))
				if #(GetEntityCoords(GetPlayerPed(v)) - comparedCoords) < 350 then
					return true
				end
			end
			return false
		end
		return false
	end

	functions.parkGarageVehicle = function()
		self.state = ESX.VehiclesStates.restrictions.INGARAGE
	end
	functions.unparkGarageVehicle = function()
		self.state = ESX.VehiclesStates.permissive.STANDARD
	end

	functions.impoundGarageVehicle = function()
		self.state = ESX.VehiclesStates.restrictions.IMPOUNDED
	end

	functions.finalySpawn = function(ignoreRestrictions)
		if ignoreRestrictions == nil or not ignoreRestrictions then
			for k,v in pairs(ESX.VehiclesStates.restrictions) do
				if self.state == v then
					return false, self.state
				end
			end
		end

		self.entity = ExM.Game.SpawnVehicle(self.model, vector3(self.coords.x, self.coords.y,self.coords.z) , self.plate)

		while not DoesEntityExist(self.entity) or functions.getNetOwnerId() == -1 or functions.getNetOwnerId() == 0 do
			Wait(500)
		end
		Wait(500)

		Entity(self.entity).state.vehIdentifier = self.vehIndentifier
		self.netId = NetworkGetNetworkIdFromEntity(self.entity)
		--ExecuteCommand(('add_principal identifier.%s group.%s'):format(self.identifier, self.group))

		SetVehicleNumberPlateText(self.entity , self.plate)
		while GetVehicleNumberPlateText(self.entity) ~= self.plate do
			Wait(1000)
			SetVehicleNumberPlateText(self.entity , self.plate)
		end
		Wait(200)
		if self.heading then
			print("poniendo heading! "..self.heading)
			SetEntityHeading(self.entity, self.heading)
		end

		functions.netId = self.netId 
		functions.entity = self.entity 
		print(json.encode(self.properties))
		functions.refreshProperties()

		print("ANtes estadop")
		self.state = ESX.VehiclesStates.permissive.STANDARD
		self.spawned = true
		print("Despues estado")
		functions.afterSpawn()

		return true
	end

	functions.spawnVehicle = function(ignoreRestrictions,coords)
		self.pendingToSpawn = false
		if not self.spawned then
			print("spawn?")
			if functions.isPossibleToSpawn() then
				functions.finalySpawn(ignoreRestrictions)
			else
				print("Not possible to spawn")
				Citizen.CreateThread(function() 
					self.pendingToSpawn = true
					while self.pendingToSpawn  do
						print("checking if now possible")
						Wait(30000)
						if self.pendingToSpawn  then
							if functions.isPossibleToSpawn() then
								print("now is possible")
								functions.finalySpawn(ignoreRestrictions)
								self.pendingToSpawn  = false
							end
						end
					end
				end)
			end
		end
	end

	if functions.isInPermissiveState() then
		functions.spawnVehicle(self.coords)
	end

	functions.forceFullVehicleSave = function()
		if self.PlayerOwner then
			local vehicles = ESX.getsData().get("vehicles")
			vehicles[self.plate] = functions.getSaveableData()
			ESX.getsData().set("vehicles", vehicles)
		end
	end

	return functions
end


CreateThread(function() 
	local count = 0
	while true do
		if tablelength(ESX.Vehicles) > 0 then
			for k,v in pairs(ESX.Vehicles) do
				count = count + 1
				if count % 15 == 0 then
					Wait(100)
				end
				v.updateEngineHealth()
				v.updateBodyHealth()
			end
		end
		Wait(30000)
	end
end)
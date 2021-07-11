function CreateExtendedPlayer(playerId, identifier, group, accounts, inventory, weight, job, loadout, name, coords)
	local self = {}
	local functions = {}

	self.accounts = accounts
	self.coords = coords
	self.group = group
	self.identifier = identifier
	self.inventory = inventory
	self.job = job
	self.loadout = loadout
	self.name = name
	self.playerId = playerId
	self.source = playerId
	self.variables = {}
	self.weight = weight
	self.maxWeight = Config.MaxWeight
	
	functions.source = playerId

	functions.identifier = identifier

	ExecuteCommand(('add_principal identifier.%s group.%s'):format(self.identifier, self.group))

	functions.getPlayerVariables = function()
		return self.variables
	end


	functions.setPlayerVariables = function(vars)
		self.variables = vars
	end

	functions.triggerEvent = function(eventName, ...)
		TriggerClientEvent(eventName, self.source, ...)
	end

	functions.setCoords = function(coords)
		functions.updateCoords(coords)
		functions.triggerEvent('esx:teleport', coords)
	end

	functions.updateCoords = function(coords)
		--self.coords = {x = ESX.Math.Round(coords.x, 1), y = ESX.Math.Round(coords.y, 1), z = ESX.Math.Round(coords.z, 1), heading = ESX.Math.Round(coords.heading or 0.0, 1)}
		self.coords = {x = coords.x, y = coords.y, z = coords.z, heading = coords.heading or 0.0}
	end

	functions.getCoords = function(vector)
		if vector then
			return vector3(self.coords.x, self.coords.y, self.coords.z)
		else
			return self.coords
		end
	end

	functions.kick = function(reason)
		DropPlayer(self.source, reason)
	end

	functions.canPay = function(quantity)
		return functions.getMoney() >= tonumber(quantity)
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

	functions.getExternal = function(k, cb)
		ESX.exposedDB.getDocument(GetHashKey(k), function(result) 
			cb(result)
		end)
	end

	functions.setExternal = function(k, data, cb)
		ESX.exposedDB.updateOrCreateDocument(GetHashKey(k), data ,function(result) 
			cb(result)
		end)
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
		return self.job
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
				minimalLoadout[v.name].serial = v.serial
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
			if functions.canCarryItem(name, count) then
				count = ESX.Math.Round(count)
				item.count = item.count + count
				self.weight = self.weight + (item.weight * count)

				local weightPercent = (self.weight / self.maxWeight) * 100
				TriggerEvent('esx:onAddInventoryItem', self.source, item.name, item.count)
				functions.triggerEvent('esx:addInventoryItem', item.name, item.count, false, item, weightPercent)
			else
				functions.showNotification("No puedes llevar más "..ESX.Items[name].label)
			end
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

				local weightPercent = (self.weight / self.maxWeight) * 100
				TriggerEvent('esx:onRemoveInventoryItem', self.source, item.name, item.count)
				functions.triggerEvent('esx:removeInventoryItem', item.name, item.count, false, weightPercent)
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
		return (newWeight <= self.maxWeight)
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

	functions.addWeapon = function(weaponName, ammo, serialParam)
		if not functions.hasWeapon(weaponName) then
			local weaponLabel = ESX.GetWeaponLabel(weaponName)
			local weaponWeight = ESX.GetWeaponWeight(weaponName)
			local newserial = GetHashKey(weaponName..os.time())
			if serialParam then
				newserial = serialParam
			end
			table.insert(self.loadout, {
				name = weaponName,
				ammo = ammo,
				label = weaponLabel,
				components = {},
				tintIndex = 0,
				weight = weaponWeight,
				serial = newserial
			})
			self.weight = self.weight + weaponWeight
			local wpercent = (self.weight / self.maxWeight) * 100
			functions.triggerEvent('esx:addWeapon', weaponName, ammo)
			functions.triggerEvent('esx:addInventoryItem', weaponName, false, true, false, wpercent)
		end
	end

	functions.addWeaponComponent = function(weaponName, weaponComponent)
		local loadoutNum, weapon = functions.getWeapon(weaponName)

		if weapon then
			local component = ESX.GetWeaponComponent(weaponName, weaponComponent)
			print("DANDO COMPONENTE".. loadoutNum)
			if component then
				if not functions.hasWeaponComponent(weaponName, weaponComponent) then
					table.insert(self.loadout[loadoutNum].components, weaponComponent)
					print(json.encode(self.loadout))
					functions.triggerEvent('esx:addWeaponComponent', weaponName, weaponComponent)
					--functions.triggerEvent('esx:addInventoryItem', component.label, false, true)
					print("COMPONENTE DADO")
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
				--functions.triggerEvent('esx:addInventoryItem', weaponObject.tints[weaponTintIndex], false, true)
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
			local weightPercent = (self.weight / self.maxWeight) * 100
			functions.triggerEvent('esx:removeWeapon', weaponName)
			functions.triggerEvent('esx:removeInventoryItem', weaponName, false, true, weightPercent)
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
					--functions.triggerEvent('esx:removeInventoryItem', component.label, false, true)
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
				print("RETURN: "..json.encode(v))
				return k, v
			end
		end

		return
	end

	functions.showNotification = function(msg, flash, saveToBrief, hudColorIndex)
		functions.triggerEvent('esx:showNotification', msg, flash, saveToBrief, hudColorIndex)
	end

	functions.showHelpNotification = function(msg, thisFrame, beep, duration)
		functions.triggerEvent('esx:showHelpNotification', msg, thisFrame, beep, duration)
	end

	functions.isVehicleOwner = function(plate)
		if self.variables["vehicles"] then
			if self.variables["vehicles"][plate] then
				return true
			end
		end
		return false
	end

	return functions
end

function stringsplit(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end

	local t={} ; i=1
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		t[i] = str
		i = i + 1
	end

	return t
end

function CreateDataStore(name, owner, data, temp)
	local self = {}
	local functions = {}

	self.temp  = temp
	self.name  = name
	self.owner = owner
	self.data  = data
	self.savingState = false

	local timeoutCallbacks = {}

	functions.set = function(key, val)
		self.data[key] = val
		functions.save()
	end

	functions.getName = function()
		return self.name
	end

	functions.getData = function()
		return self.data
	end

	functions.get = function(key, i)
		local path = stringsplit(key, '.')
		local obj  = self.data

		for i=1, #path, 1 do
			obj = obj[path[i]]
		end

		if i == nil then
			return obj
		else
			return obj[i]
		end
	end

	functions.count = function(key, i)
		local path = stringsplit(key, '.')
		local obj  = self.data

		for k,v in pairs(path) do
			obj = obj[v]
		end

		if i ~= nil then
			obj = obj[i]
		end

		if obj == nil then
			return 0
		else
			return #obj
		end
	end

	functions.save = function()
		if self.owner == nil then
			 --asd
		else
			if not self.savingState and not self.temp then
				self.savingState = true
				Citizen.SetTimeout(
					120000,
					function()
						local annonTable = {}
						print("hash: " .. GetHashKey("datastore_" .. self.owner))
						for k, v in pairs(DataStores[self.owner]) do
							annonTable[v.getName()] = {
								name = v.getName(),
								data = v.getData()
							}
						end

						ESX.exposedDB.updateDocument(
							GetHashKey("datastore_" .. self.owner),
							{
								datastore = annonTable
							},
							function(result)
								print("hash: " .. GetHashKey("datastore_" .. self.owner))
								self.savingState = false
								if not result then
									print(
										"^8Fatal Error in addon accounts self saving, unable to save the account: " ..
											" from player: " .. self.owner
									)
								end
							end
						)
					end
				)
			end
		end
	end

	return functions
end

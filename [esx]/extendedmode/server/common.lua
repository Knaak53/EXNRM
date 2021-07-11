ESX = {}
ESX.Players = {}
ESX.Vehicles = {}
ESX.UsableItemsCallbacks = {}
ESX.Items = {}
ESX.sData = {}
ESX.ServerCallbacks = {}
ESX.TimeoutCount = -1
ESX.CancelledTimeouts = {}
ESX.Pickups = {}
ESX.PickupId = 0
ESX.Jobs = {}
ESX.ActiveWorkers = {}
ESX.RegisteredCommands = {}
ESX.exposedDB = exposedDB

ESX.VehiclesStates =  
{
	restrictions = {
		IMPOUNDED = "IMPOUNDED",
		DESTROYED = "DESTROYED",
		INGARAGE = "INGARAGE"
	},
	permissive = {
		STANDARD = "STANDARD",
		PARKED = "PARKED",
	}
}

ESX.VehicleLockStatus = {
    None = 0,
    Unlocked = 1,
    Locked = 2,
    LockedForPlayer = 3,
    StickPlayerInside = 4, -- Doesn't allow players to exit the vehicle with the exit vehicle key.
    CanBeBrokenInto = 7, -- Can be broken into the car. If the glass is broken, the value will be set to 1
    CanBeBrokenIntoPersist = 8, -- Can be broken into persist
    CannotBeTriedToEnter = 10, -- Cannot be tried to enter (Nothing happens when you press the vehicle enter key).
}

ESX.VehicleSeats = {
	DRIVER = -1,
	ANY = -2  ,
	LEFT_REAR = 1  ,
	RIGHT_FRONT= 0  ,
	RIGHT_REAR = 2  ,
	EXTRA = {
		EXTRA_1 = 3,
		EXTRA_2 = 4,
		EXTRA_3 = 5,
		EXTRA_4 = 6,
		EXTRA_5 = 7,
		EXTRA_6 = 8,
		EXTRA_7 = 9,
		EXTRA_8 = 10,
		EXTRA_9 = 11,
		EXTRA_10 = 12,
		EXTRA_11 = 13,
	},
}
-- Add a seperate table for ExtendedMode functions, but using metatables to limit feature usage on the ESX table
-- This is to provide backward compatablity with ESX but not add new features to the old ESX tables.
-- Note: Please add all new namespaces to ExM _after_ this block
do
    local function processTable(thisTable)
        local thisObject = setmetatable({}, {
            __index = thisTable
        })
        for key, value in pairs(thisTable) do
            if type(value) == "table" then
                thisObject[key] = processTable(value)
            end
        end
        return thisObject
    end
    ExM = processTable(ESX)
end

AddEventHandler('esx:getSharedObject', function(cb)
	cb(ESX)
end)

exports("getSharedObject", function()
	return ESX
end)

exports("getExtendedModeObject", function()
	return ExM
end)

-- Globals to check if OneSync or Infinity for exclusive features
ExM.IsOneSync = GetConvar('onesync', false) == 'on'
ExM.IsInfinity = GetConvar('onesync_enableInfinity', true) == 'true'

ExM.DatabaseReady = false
ExM.DatabaseType = "exm+couchDB"


print('[ExtendedMode] [^2INFO^7] Starting up...')


print('[ExtendedMode] [^2INFO^7] Checking your database...')
	
	-- Check the information schema for the tables that match the esx ones
	--MySQL.Async.fetchAll("SELECT TABLE_NAME AS 't', COLUMN_NAME AS 'c' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'users' or TABLE_NAME = 'user_inventory' or TABLE_NAME = 'user_accounts'", {}, function(informationSchemaResult)
			--[[local databaseCheckFunction = function()
			-- Ensure we have a result that we can iterate
			if type(informationSchemaResult) ~= "table" then
				print('[ExtendedMode] [^1ERROR^7] Your database is not compatible with ExtendedMode!\nIf this is a fresh installation, you may have forgotten to import the SQL template.')
				error()
			end

			-- Coagulate table columns from results
			local tableMatchings = {}
			for _, data in pairs(informationSchemaResult) do
				tableMatchings[data.t] = tableMatchings[data.t] or {}
				tableMatchings[data.t][data.c] = true
			end

			-- Check for invalid scenarios
			if not tableMatchings["users"] then
				print("[ExtendedMode] [^1ERROR^7] Your database is not compatible with ExtendedMode!\nYou do not have a users table. Please import the SQL template found in the resource directory.")
				error()
			else
				if tableMatchings["users"]["inventory"] and tableMatchings["users"]["accounts"] then
					ExM.DatabaseType = "newesx"
				elseif tableMatchings["user_inventory"] and tableMatchings["user_accounts"] then
					ExM.DatabaseType = "es+esx"
				else
					print("[ExtendedMode] [^1ERROR^7] Your database is not compatible with ExtendedMode!\nYou do not have anywhere for either the inventory or account info to be stored.\nRe-importing the SQL template may fix this!")
					error()
				end
			end--]]

			-- Do some other database type validation... (this is temporary!)
			if ExM.DatabaseType then
				if ExM.DatabaseType == "es+esx" then
					print("[ExtendedMode] [^1ERROR^7] Your database is using the 'es+esx' storage format.\nThis version of ExtendedMode is not yet fully compatible with that storage format.\nYou can try to automatically migrate your database to the correct format using the ^4`migratedb`^0 command directly in your server console.")
					error()
				elseif ExM.DatabaseType == "newesx" then -- redundant check as there are no other database types but oh well, future proofing I guess
					print(("[ExtendedMode] [^2INFO^7] Your database is using the '%s' storage format, starting..."):format(ExM.DatabaseType))
				elseif ExM.DatabaseType == "exm+couchDB" then
					print(("[ExtendedMode] [^2INFO^7] Your database is using the '%s' storage format, starting..."):format(ExM.DatabaseType))
				else
					print(("[ExtendedMode] [^2INFO^7] Your database is using the '%s' storage format, this is ^1not^7 compatible with ExtendedMode!"):format(ExM.DatabaseType))
					error()
				end
			else
				print("[ExtendedMode] [^1ERROR^7] An unknown error occured while determining your database storage format!")
				error()
			end
		--end
		
		--if pcall(databaseCheckFunction) then
			--MySQL.Async.fetchAll('SELECT * FROM items', {}, function(result)
			AddEventHandler("onResourceStart", function(resource)
				if GetCurrentResourceName() == resource then
					Citizen.CreateThread(function() 
						Wait(50)
						--print("Md5 items: "..GetHashKey("items"))

						ESX.exposedDB.getDocumentData(GetHashKey("serverData"), function(result) 
							if result then
								ESX.sData = CreateExtendedData(result.sData)
								TriggerEvent("esx:dataReady")
								local sVehicles = ESX.sData.get("vehicles")
								if sVehicles then
									Citizen.CreateThread(function() 
										for k,v in pairs(sVehicles) do
											ESX.AddVehicle(CreateExtendedCar(v.model, v.class, v.plate, false, v.owner, v.coords, v.props, v.inventory, v.job,  v.state, v.variables))
										end
									end)
								end
							else
								ESX.sData = CreateExtendedData({})
							end
						end)
						for k,v in pairs(items) do
							ESX.Items[v.name] = {
								label = v.label,
								weight = v.weight,
								rare = v.rare,
								limit = v.limit,
								canRemove = v.canRemove,
								prop = v.prop
							}
						end
						TriggerEvent("esx:dataItemsReady")
						ESX.exposedDB.getDocumentData(GetHashKey("jobs"), function(result)
							-- print("NUM JOBS: "..tablelength(result.jobs))
							-- print("NUM JOBS CONFIG: "..tablelength(jobs))
							if result and (tablelength(result.jobs) == tablelength(jobs)) then
								for k,v in pairs(result.jobs) do
									ESX.Jobs[v.name] = v
									ESX.Jobs[v.name].grades = {}

									for k,v in pairs(result.jobs[k].job_grades) do
										if ESX.Jobs[v.job_name] then
											ESX.Jobs[v.job_name].grades[tostring(v.grade)] = v
										else
											print(('[ExtendedMode] [^3WARNING^7] Ignoring job grades for "%s" due to missing job'):format(v.job_name))
										end
									end

								end

								for k2,v2 in pairs(ESX.Jobs) do
									if ESX.Table.SizeOf(v2.grades) == 0 then
										ESX.Jobs[v2.name] = nil
										print(('[ExtendedMode] [^3WARNING^7] Ignoring job "%s" due to no job grades found'):format(v2.name))
									end
								end
						
								--MySQL.Async.fetchAll('SELECT * FROM job_grades', {}, function(jobGrades)
									
								--end)
							elseif not result then
								-- body
								ExM.exposedDB.updateOrCreateDocument(GetHashKey("jobs") ,
								{
									jobs = jobs
									--{
									--	desempleado = {
									--		name = "desempleado",
									--		label = "Desempleado",
									--		job_grades = {
									--			desempleado = {
									--				job_name = "desempleado",
									--				grade = 0,
									--				name = "desempleado",
									--				label = "En Paro",
									--				salary = 50,
									--				skin_male = {},
									--				skin_female = {} 
									--			}
									--		}
									--	},
									--	cardealer = {
									--		name = "cardealer",
									--		label = "Vendedor de Coches",
									--		job_grades = {
									--			boss = {
									--				job_name = "cardealer",
									--				grade = 0,
									--				name = "boss",
									--				label = "Jefe",
									--				salary = 200,
									--				skin_male = {},
									--				skin_female = {} 
									--			}
									--		}
									--	},
									--	ambulance = {
									--		name = "ambulance",
									--		label = "Médico",
									--		job_grades = {
									--			boss = {
									--				job_name = "ambulance",
									--				grade = 0,
									--				name = "boss",
									--				label = "Jefe",
									--				salary = 200,
									--				skin_male = {},
									--				skin_female = {} 
									--			}
									--		}
									--	},
									--} 
								},
								function(status, err) 
									if status then
										print("Jobs initial done")
										TriggerEvent("esx:dataJobsReady")
									else
										print("Error creating items document: "..err)
									end
								end)
								print("There arent items configured yet")
							else
								local jobsUpdated = {}
								for k,v in pairs(jobs) do
									if result.jobs[k] == nil then
										result.jobs[k] = v
										table.insert(jobsUpdated, k)
									end
								end
								for k,v in pairs(result.jobs) do
									if jobs[k] == nil then
										result.jobs[k] = nil
									end
								end
								ESX.exposedDB.updateOrCreateDocument(GetHashKey("jobs"), { jobs = result.jobs}, function() 
									if result then
										for _,v in pairs(jobsUpdated) do
											print("^2Job: "..v.. " Añadido a la lista de Jobs^7")
										end
									end
								end)
							end
						end)
				
						-- Wait for the db sync function to be ready incase it isn't ready yet somehow.
						if not ESX.StartDBSync or not ESX.StartPayCheck then
							print('[ExtendedMode] [^2INFO^7] ExtendedMode has been initialized')
							while not ESX.StartDBSync and not ESX.StartPayCheck do
								Wait(1000)
							end
							
						end
				
						ExM.DatabaseReady = true
				
						-- Start DBSync and the paycheck
						ESX.StartDBSync()
						ESX.StartPayCheck()
						print('[ExtendedMode] [^2INFO^7] ExtendedMode has been initialized')
					end)
				end
			end)

		--else
			--print('[ExtendedMode] [^1ERROR^7] ExtendedMode was unable to intialise the database and cannot continue, please see above for more information.')
		--end
	--end)
--end)

RegisterServerEvent('esx:clientLog')
AddEventHandler('esx:clientLog', function(msg)
	if Config.EnableDebug then
		print(('[ExtendedMode] [^2TRACE^7] %s^7'):format(msg))
	end
end)

RegisterServerEvent('esx:triggerServerCallback')
AddEventHandler('esx:triggerServerCallback', function(name, requestId, ...)
	local playerId = source

	ESX.TriggerServerCallback(name, requestId, playerId, function(...)
		TriggerClientEvent('esx:serverCallback', playerId, requestId, ...)
	end, ...)
end)

function tablelength(T)
	local count = 0
	for _ in pairs(T) do count = count + 1 end
	return count
  end

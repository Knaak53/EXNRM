ESX = nil
ESX = exports.extendedmode:getSharedObject()

ESX.RegisterServerCallback('esx_joblisting:getLastJob', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local lastJob = xPlayer.get('lastJob')
	if not lastJob then
		xPlayer.set('lastJob', 1549643682)
		cb(true)
	else
		if os.time() - lastJob >= 86400 then --86400 = 1 dia
			cb(true)
		end
	end
	cb(false)
end)

ESX.RegisterServerCallback('esx_joblisting:getJobInProcess', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local jobInProcess = xPlayer.get('jobInProcess')
	if not jobInProcess then
		jobInProcess = 'no'
		xPlayer.set('jobInProcess', jobInProcess)
		cb(jobInProcess)
	end
	cb(jobInProcess)
end)

RegisterServerEvent('esx_joblisting:setJobInProcess')
AddEventHandler('esx_joblisting:setJobInProcess', function(job)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.set('jobInProcess', job)
end)

RegisterServerEvent("esx_joblisting:checkRequerimentsJobListing")
AddEventHandler('esx_joblisting:checkRequerimentsJobListing', function(job)
	local _source = source
	local canTakeJob = checkRequeriments(job, _source)
	if canTakeJob then
		TriggerClientEvent("esx_joblisting:continueProcess", _source, job)
	else
		TriggerClientEvent("esx_joblisting:startDenyProcess", _source)
	end
end)

local vehicleRequeriment = {
	"delivery",
	"miner"
}

function checkRequeriments(job, source)
	if job ~= "garbage" and job ~= "woodcutter" then
		if job == "delivery" then
			return checkVehicle("delivery", "faggio3", source)
		elseif job == "miner" then
			return checkVehicle("miner", "rumpo3", source) and checkItem("pickaxe", source)
		elseif job == "bus" then
			return checkTruckLicense(source)
		elseif job == "works" then
			return checkItem("workstool", source)
		end
	end
	return true
end
exports("checkRequeriments", checkRequeriments)

RegisterCommand("clearJoblistCooldwon", function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.set('jobInProcess', "no")
    xPlayer.set('lastJob', 1549643682)
end)

function checkItem(item, source)
	local xPlayer = ESX.GetPlayerFromId(source)
	return xPlayer.getInventoryItem(item).count > 0
end

function checkTruckLicense(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	local playerLicenses = xPlayer.get("licenses") or {}
	print(json.encode(playerLicenses))
	if playerLicenses then
		for k, v in pairs(playerLicenses) do
			if k == 'drive_truck' then
				return true
			end
		end
	end
	return false
end

function checkVehicle(job, vehicle, source)
	local xPlayer = ESX.GetPlayerFromId(source)
	local playerVehicles = xPlayer.get("vehicles")
	local hasVehicle = false
	if playerVehicles then
		for k,v in pairs(playerVehicles) do
			if v.model == vehicle then
				return true
			end
		end
	end
	return false
end

RegisterServerEvent('esx_joblisting:setLastJob')
AddEventHandler('esx_joblisting:setLastJob', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.set('lastJob', os.time())
end)

RegisterServerEvent('esx_joblisting:setJob')
AddEventHandler('esx_joblisting:setJob', function(job)
	local xPlayer = ESX.GetPlayerFromId(source)
	local availableJobs = ESX.getJobs()
	if xPlayer then
		for k,v in pairs(availableJobs) do
			if k == job then
				xPlayer.setJob(job, 0)
				break
			end
		end
	end
end)

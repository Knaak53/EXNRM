ESX = nil
local currentSellingEntity
local myJob = "unemployed"

Citizen.CreateThread(function()
	while ESX == nil do
		ESX = exports.extendedmode:getSharedObject()
		Citizen.Wait(0)
	end
	ClearPedTasks(PlayerPedId())
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerData)
    myJob = playerData.job.name
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
     myJob = job.name
end)

RegisterNetEvent('esx_sell_drugs:tryToSellDrugs')
AddEventHandler('esx_sell_drugs:tryToSellDrugs', function(pedHash, pedEntity)
	Citizen.Wait(150)
	if checkJob(myJob) then
		if #(GetEntityCoords(PlayerPedId()) - Config.CityPoint) < Config.DistanceFromCity then
			currentSellingEntity = pedEntity
			tryToSellDrugs(pedEntity)
		else
			ESX.ShowNotification("No puedes traficar tan lejos de la ciudad")
		end
	else
		ESX.ShowNotification("No puedes vender drogas con tu rol actual")
	end
end)

function tryToSellDrugs(pedEntity)
	ESX.TriggerServerCallback('esx_sell_drugs:playerHasDrugs', function(drugsCount)
		if drugsCount.weed > 0 or drugsCount.coke > 0 or drugsCount.meth > 0 then
			local playerPed = PlayerPedId()
			makeEntityFaceEntity(pedEntity, playerPed)
			makeEntityFaceEntity(playerPed, pedEntity)
			ClearPedTasks(pedEntity)
			FreezeEntityPosition(pedEntity,true)										
			TaskStandStill(pedEntity, 40000)
			showDrugsMenu(drugsCount)
		else
			ESX.ShowNotification("~r~No tienes droga que vender!")
		end
	end)
end

function showDrugsMenu(drugsCount)
	SendNUIMessage(
        {
			action = "openMenu",
			weedCount = drugsCount.weed,
			cokeCount = drugsCount.coke,
			methCount = drugsCount.meth,
        }
	)
	SetNuiFocus(true, true)
end

function makeEntityFaceEntity( entity1, entity2 )
    local p1 = GetEntityCoords(entity1, true)
    local p2 = GetEntityCoords(entity2, true)

    local dx = p2.x - p1.x
    local dy = p2.y - p1.y

    local heading = GetHeadingFromVector_2d(dx, dy)
    SetEntityHeading( entity1, heading )
end

function checkJob(myJob)
	return myJob ~= 'police' and
			myJob ~= 'offpolice' and
			myJob ~= 'ambulance' and
			myJob ~= 'taxi' and
			myJob ~= 'mechanic' and
			myJob ~= 'cardealer'
end

function checkPed(pedHash)
	for i = 1, #Config.pedBlacklist do
		if Config.pedBlacklist[i] == pedHash then
			return false
		end 
	end
	return true
end

RegisterNUICallback("exit", function(data)
    SetNuiFocus(false, false)
end)

RegisterNUICallback("sellDrug", function(data)
	processDrugsSelling(data.drug)
    SetNuiFocus(false, false)
end)

function processDrugsSelling(drug)
	local itemName
	if drug == "weed" then
		calculatePercentagesAndDoAllTheCoolStuffBaby("weed_pooch", 35, 55)
	elseif drug == "coke" then
		calculatePercentagesAndDoAllTheCoolStuffBaby("coke_pooch", 42, 45)
	else
		calculatePercentagesAndDoAllTheCoolStuffBaby("meth_pooch", 50, 38)
	end
end

function calculatePercentagesAndDoAllTheCoolStuffBaby(drugName, callCopsPercentage, sellProbability)
	math.randomseed(GetGameTimer())
	local playerPed = PlayerPedId()
	local randomPedBuy = math.random(1, 100)
	if randomPedBuy <= sellProbability then
		RequestAnimDict("mp_safehouselost@")
	 	while (not HasAnimDictLoaded("mp_safehouselost@")) do Citizen.Wait(0) end
		TaskPlayAnim(playerPed, "mp_safehouselost@", "package_dropoff", 8.0, 1.0, -1, 1, 0, 0, 0, 0 )
		ClearPedTasksImmediately(currentSellingEntity)
		makeEntityFaceEntity(currentSellingEntity, playerPed)
		TaskStartScenarioInPlace(currentSellingEntity, 'WORLD_HUMAN_DRUG_DEALER_HARD', 0, true)
		Citizen.Wait(3100)
		TriggerServerEvent("esx_sell_drugs:sellDrug", drugName)
		FreezeEntityPosition(currentSellingEntity, false)
		ClearPedTasks(playerPed)	
		ClearPedTasks(currentSellingEntity)
	else
		ESX.ShowNotification("~r~Han rechazado tu ofreta...")
		ClearPedTasks(currentSellingEntity)
		FreezeEntityPosition(currentSellingEntity, false)
		TaskReactAndFleePed(currentSellingEntity, playerPed)
		PlayPain(currentSellingEntity, 6, 0,0)
		local randomCallCops = math.random(1, 100)
		if randomCallCops <= callCopsPercentage then
			callCops()
		end
	end
end

function callCops()
	ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
		local sex
		local plyPos = GetEntityCoords(GetPlayerPed(-1),  true)
		local s1, s2 = Citizen.InvokeNative( 0x2EB41072B4C1E4C0, plyPos.x, plyPos.y, plyPos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt() )
        local street1 = GetStreetNameFromHashKey(s1)
        local street2 = GetStreetNameFromHashKey(s2)
		if skin.sex == 0 then
			sex = "m"
		else
			sex = "f"
		end
		TriggerServerEvent("esx_sell_drugs:callCops", plyPos, street1, street2, sex)
	end)
end

RegisterNetEvent('esx_sell_drugs:notifyCops')
AddEventHandler('esx_sell_drugs:notifyCops', function(coords, message)
	if myJob == 'police' then
		ESX.ShowNotification(message)
		Citizen.CreateThread(function()
			local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
			SetBlipSprite(blip, 514)
			SetBlipDisplay(blip, 4)
			SetBlipScale(blip, 1.3)
			SetBlipColour(blip, 1)
			SetBlipAsShortRange(blip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString("Venta de drogas")
			EndTextCommandSetBlipName(blip)
			Citizen.Wait(30000)
			if DoesBlipExist(blip) then
				RemoveBlip(blip)
			end
		end)
	end
end)
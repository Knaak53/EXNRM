ESX = nil
local title = "Armero de CityName"
local img = "weapons.png"


Citizen.CreateThread(function()
	while ESX == nil do
		ESX = exports.extendedmode:getSharedObject()
		Citizen.Wait(0)
	end
end)

function OpenBuyLicenseMenu()
	ESX.TriggerServerCallback('weapons:getLicense', function(hasLicense)
		if hasLicense then
			OpenShopMenu()
		else
			TriggerEvent("esx_custom_messages:showMessage", "weaponShop", false, "noLicense")
		end
	end)
end

RegisterNUICallback(
    "close",
    function(data, cb)
    	SetNuiFocus(false, false)
		SendNUIMessage({
			action = "hide"
		})
end)

RegisterNUICallback(
    "buy",
    function(data, cb)
    	SetNuiFocus(false, false)
		SendNUIMessage({
			action = "hide"
		})

		ESX.TriggerServerCallback('esx_weaponshop:buyWeapon', function(bought)
			if bought then
				DisplayBoughtScaleform(data.weapon, data.price)
				TriggerEvent("esx_custom_messages:showMessage", "weaponShop", true, "buy")
				Citizen.Wait(6000)	
			else
				PlaySoundFrontend(-1, 'ERROR', 'HUD_AMMO_SHOP_SOUNDSET', false)
			end
		end, data.weapon, 'GunShop', data.price)
end)


function OpenShopMenu()
	TriggerEvent("esx_custom_messages:showMessage", "weaponShop", true, "hello")
	Citizen.Wait(6000)	
	SetNuiFocus(true, true)
	SendNUIMessage({
		action = "show"
	})
end

function DisplayBoughtScaleform(weaponName, price)
	local scaleform = ESX.Scaleform.Utils.RequestScaleformMovie('MP_BIG_MESSAGE_FREEMODE')
	local sec = 4

	BeginScaleformMovieMethod(scaleform, 'SHOW_WEAPON_PURCHASED')
	PushScaleformMovieMethodParameterString(_U('weapon_bought', ESX.Math.GroupDigits(price)))
	PushScaleformMovieMethodParameterString(ESX.GetWeaponLabel(weaponName))
	PushScaleformMovieMethodParameterInt(GetHashKey(weaponName))
	PushScaleformMovieMethodParameterString('')
	PushScaleformMovieMethodParameterInt(100)
	EndScaleformMovieMethod()
	PlaySoundFrontend(-1, 'WEAPON_PURCHASE', 'HUD_AMMO_SHOP_SOUNDSET', false)

	Citizen.CreateThread(function()
		while sec > 0 do
			Citizen.Wait(0)
			sec = sec - 0.01
	
			DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
		end
	end)
end

local pedEntities = {}

--[[ Deletes the cashiers ]]--
DeleteGunMans = function()
    for i=1, #pedEntities do
        local gunman = pedEntities[i]
        if DoesEntityExist(gunman) then
            DeletePed(gunman)
            SetPedAsNoLongerNeeded(gunman)
        end
    end
end

RegisterNetEvent('esx_weaponshop:openMenu_ui')
AddEventHandler('esx_weaponshop:openMenu_ui', function()
	if Config.LicenseEnable then
		ESX.TriggerServerCallback('esx_license:checkLicense', function(hasWeaponLicense)
			if hasWeaponLicense then
				OpenShopMenu()
			else
				OpenBuyLicenseMenu()
			end
		end, GetPlayerServerId(PlayerId()), 'weapon')
	else
		OpenShopMenu()
	end
end)

Citizen.CreateThread(function()
   for k,v in pairs(Config.Zones) do
		for i = 1, #v.Locations do
	        local gunMan = v.Locations[i].coords
	        if gunMan then
	            hash = GetHashKey('ig_josef')
	            RequestModel(hash)
	            while not HasModelLoaded(hash) do
        			Wait(0)
    			end
	            if not DoesEntityExist(pedEntities[i]) then
	                pedEntities[i] = CreatePed(4, hash, v.Locations[i].coords.x, v.Locations[i].coords.y, v.Locations[i].coords.z, v.Locations[i].heading)
	                SetEntityAsMissionEntity(pedEntities[i])
	                SetBlockingOfNonTemporaryEvents(pedEntities[i], true)
	                FreezeEntityPosition(pedEntities[i], true)
	                SetEntityInvincible(pedEntities[i], true)
	            end
	            SetModelAsNoLongerNeeded(hash)
	        end
	    end
    end
end)

-- Create Blips
Citizen.CreateThread(function()
	for k,v in pairs(Config.Zones) do
		if v.Legal then
			for i = 1, #v.Locations, 1 do
				local blip = AddBlipForCoord(v.Locations[i].coords)

				SetBlipSprite (blip, 110)
				SetBlipDisplay(blip, 4)
				SetBlipScale  (blip, 0.8)
				SetBlipColour (blip, 49)
				SetBlipAsShortRange(blip, true)

				BeginTextCommandSetBlipName("STRING")
				AddTextComponentSubstringPlayerName(_U('map_blip'))
				EndTextCommandSetBlipName(blip)
			end
		end
	end
end)
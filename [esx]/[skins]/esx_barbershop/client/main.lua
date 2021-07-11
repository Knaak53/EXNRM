--[[ESX = nil
local hasPaid

Citizen.CreateThread(function()
	while ESX == nil do
		ESX = exports.extendedmode:getSharedObject()
		Citizen.Wait(0)
	end
end)

function OpenShopMenu()
	hasPaid = false

	TriggerEvent('esx_skin:openRestrictedMenu', function(data, menu)
		menu.close()

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_confirm', {
			title = _U('valid_purchase'),
			align = 'left',
			elements = {
				{label = _U('no'),  value = 'no'},
				{label = _U('yes') .. '<span style="color: green;">60€</span>', value = 'yes'}
		}}, function(data, menu)
			menu.close()

			if data.current.value == 'yes' then
				ESX.TriggerServerCallback('esx_barbershop:checkMoney', function(hasEnoughMoney)
					if hasEnoughMoney then
						TriggerEvent('skinchanger:getSkin', function(skin)
							TriggerServerEvent('esx_skin:save', skin)
						end)

						TriggerServerEvent('esx_barbershop:pay')
						hasPaid = true
					else
						ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
							TriggerEvent('skinchanger:loadSkin', skin) 
						end)
						hasPaid = true
						ESX.ShowNotification(_U('not_enough_money'))
					end
				end)
			elseif data.current.value == 'no' then
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
					TriggerEvent('skinchanger:loadSkin', skin) 
				end)
			end

		end, function(data, menu)
			menu.close()
		end)
	end, function(data, menu)
		menu.close()
	end, {
		'beard_1',
		'beard_2',
		'beard_3',
		'beard_4',
		'hair_1',
		'hair_2',
		'hair_color_1',
		'hair_color_2',
		'eyebrows_1',
		'eyebrows_2',
		'eyebrows_3',
		'eyebrows_4',
		'makeup_1',
		'makeup_2',
		'makeup_3',
		'makeup_4',
		'lipstick_1',
		'lipstick_2',
		'lipstick_3',
		'lipstick_4',
		'ears_1',
		'ears_2',
	})
end

RegisterNetEvent('esx_barbershop:openMenu_ui')
AddEventHandler('esx_barbershop:openMenu_ui', function()
	Citizen.Wait(250)
	OpenShopMenu()
end)]]--

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		DeleteWomans()
	end
end)

local pedEntities = {}

DeleteWomans = function()
    for i=1, #pedEntities do
        local woman = pedEntities[i]
        if DoesEntityExist(woman) then
            DeletePed(woman)
            SetPedAsNoLongerNeeded(woman)
        end
    end
end

Citizen.CreateThread(function()
	for i = 1, #Config.Shops do
        local woman = Config.Shops[i].coords
        if woman then
            hash = GetHashKey('s_f_m_fembarber')
            RequestModel(hash)
            while not HasModelLoaded(hash) do
    			Wait(0)
			end
            if not DoesEntityExist(pedEntities[i]) then
                pedEntities[i] = CreatePed(4, hash, Config.Shops[i].coords.x, Config.Shops[i].coords.y, Config.Shops[i].coords.z, Config.Shops[i].heading)
                SetEntityAsMissionEntity(pedEntities[i])
                SetBlockingOfNonTemporaryEvents(pedEntities[i], true)
                FreezeEntityPosition(pedEntities[i], true)
                SetEntityInvincible(pedEntities[i], true)
            end
            SetModelAsNoLongerNeeded(hash)
        end
    end
end)

-- Create Blips
Citizen.CreateThread(function()
	for k,v in ipairs(Config.Shops) do
		local blip = AddBlipForCoord(v.coords)

		SetBlipSprite (blip, 71)
		SetBlipColour (blip, 84)
		SetBlipScale(blip, 0.7)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName(_U('barber_blip'))
		EndTextCommandSetBlipName(blip)
	end
end)
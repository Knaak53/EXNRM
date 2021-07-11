local hasPaid = false
ESX = nil

local img = "clothes.png"
local title = "Tienda de ropa"

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

function openDialog()
	--inMenu = true
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_confirm', {
		title = _U('valid_this_purchase'),
		align = 'left',
		elements = {
			{label = _U('no'), value = 'no'},
			{label = _U('yes', ESX.Math.GroupDigits(Config.Price)), value = 'yes'}
	}}, function(data, menu)
		menu.close()

		if data.current.value == 'yes' then
			ESX.TriggerServerCallback('esx_np_skinshop:buyClothes', function(bought)
				if bought then

					TriggerEvent('skinchanger:getSkin', function(skin)
						--print(json.encode(skin))
						TriggerServerEvent('esx_skin:save', skin)
					end)

					hasPaid = true

					local random = math.random(1,100)

				    if random < 50 then
				    	TriggerEvent("esx_custom_messages:showMessage", title, "Wow! Te queda fabuloso! Espero que vuelvas pronto.", img, "ropa_buy1.mp3", true, 7000)
				    else
				    	TriggerEvent("esx_custom_messages:showMessage", title, "Eso te queda de muerte! Recuerda que pronto tendremos rebajas.", img, "ropa_buy2.mp3", true, 4200)
				    end	

					ESX.TriggerServerCallback('esx_np_skinshop:checkPropertyDataStore', function(foundStore)
						if foundStore then
							ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'save_dressing', {
								title = _U('save_in_dressing'),
								align = 'left',
								elements = {
									{label = _U('no'),  value = 'no'},
									{label = _U('yes2'), value = 'yes'}
							}}, function(data2, menu2)
								menu2.close()

								if data2.current.value == 'yes' then
									ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'outfit_name', {
										title = _U('name_outfit')
									}, function(data3, menu3)
										menu3.close()

										TriggerEvent('skinchanger:getSkin', function(skin)
											TriggerServerEvent('esx_np_skinshop:saveOutfit', data3.value, skin)
											ESX.ShowNotification(_U('saved_outfit'))
										end)
									end, function(data3, menu3)
										menu3.close()
										inMenu = false
									end)
								end
							end)
						end
					end)

			else
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
					TriggerEvent('skinchanger:loadSkin', skin)
				end)
				inMenu = false
				ESX.ShowNotification(_U('not_enough_money'))
			end
			end)
		elseif data.current.value == 'no' then
			inMenu = false
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
				TriggerEvent('skinchanger:loadSkin', skin)
			end)
		end
	end, function(data, menu)
		menu.close()
	end)
end

RegisterNUICallback("endDialog", function(data)
	--print(data)
	TriggerEvent("esx_np_skinshop:toggleMenu")
	if data == "clothes" then
		openDialog()
	else
		TriggerEvent("esx_newaccessories:endDialog")
	end
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		DeleteWomans()
	end
end)

RegisterNetEvent('esx_np_skinshop:openMenu_uia')
AddEventHandler('esx_np_skinshop:openMenu_uia', function()
	local random = math.random(1,100)

    if random < 50 then
    	TriggerEvent("esx_custom_messages:showMessage", title, "Hola, te puedo ayudar en algo? Seguro que tenemos tu talla.", img, "ropa_hola1.mp3", true, 4200)
    	Citizen.Wait(4200)
    else
    	TriggerEvent("esx_custom_messages:showMessage", title, "Buenas, necesitas ayuda? Estare encantada de atenderte.", img, "ropa_hola2.mp3", true, 4200)
    	Citizen.Wait(4200)
    end	
	TriggerEvent("esx_np_skinshop:toggleMenu", "clotheshop")
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

--Citizen.CreateThread(function()
--	for i = 1, #Config.Shops do
--        local woman = Config.Shops[i].coords
--        if woman then
--            hash = GetHashKey('ig_jewelass')
--            RequestModel(hash)
--            while not HasModelLoaded(hash) do
--    			Wait(0)
--			end
--            if not DoesEntityExist(pedEntities[i]) then
--                pedEntities[i] = CreatePed(4, hash, Config.Shops[i].coords.x, Config.Shops[i].coords.y, Config.Shops[i].coords.z, Config.Shops[i].heading)
--                SetEntityAsMissionEntity(pedEntities[i])
--                SetBlockingOfNonTemporaryEvents(pedEntities[i], true)
--                FreezeEntityPosition(pedEntities[i], true)
--                SetEntityInvincible(pedEntities[i], true)
--            end
--            SetModelAsNoLongerNeeded(hash)
--        end
--    end
--end)

-- Create Blips
Citizen.CreateThread(function()
	for k,v in ipairs(Config.Shops) do
		local blip = AddBlipForCoord(v.coords)

		SetBlipSprite (blip, 73)
		SetBlipColour (blip, 84)
		SetBlipScale(blip, 0.6)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName('Caronte Outlet')
		EndTextCommandSetBlipName(blip)
	end
end)
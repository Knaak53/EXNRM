--[[ESX								= nil
local HasAlreadyEnteredMarker	= false
local LastZone					= nil
local CurrentAction				= nil
local CurrentActionMsg			= ''
local CurrentActionData			= {}
local isDead					= false
local accesorio = nil
local hasPaid = false

Citizen.CreateThread(function()
	while ESX == nil do
		ESX = exports.extendedmode:getSharedObject()
		Citizen.Wait(0)
	end
end)

local img = "accessories.png"
local imgMask = "masks.png"
local title = "Tienda de Accesorios"

function OpenShopMenu(accessory)
	hasPaid = false
	local _accessory = string.lower(accessory)
	--print(_accessory)
	accesorio = accessory

	TriggerEvent("esx_np_skinshop:toggleMenu", _accessory)
end



RegisterNetEvent('esx_newaccessories:openMenu_ui')
AddEventHandler('esx_newaccessories:openMenu_ui', function()

	local random = math.random(1,100)

    if random < 50 then
    	TriggerEvent("esx_custom_messages:showMessage", title, "Holi, me llamo Charline, me encargo de los complementos, en que puedo ayudarte?.", img, "ropa_c_hola1.mp3", true, 6000)
    	Citizen.Wait(6000)
    else
    	TriggerEvent("esx_custom_messages:showMessage", title, "Bonjour, gafas, sombreros, pendientes... tenemos todo tipo de complementos.", img, "ropa_c_hola2.mp3", true, 6000)
    	Citizen.Wait(6000)
    end	
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_confirm',
	{
		title = _U('valid_purchase'),
		align = 'left',
		elements = {
			{label = 'Sombreros', value = 'Helmet'},
			{label = 'Gafas', value = 'Glasses'},
			{label = 'Pendientes', value = 'Ears'}
		}
	}, function(data, menu)
		menu.close()
		OpenShopMenu(data.current.value)
	end, function(data, menu)
		menu.close()
	end)	
end)

RegisterNetEvent('esx_newaccessories:openMask_ui')
AddEventHandler('esx_newaccessories:openMask_ui', function()
	local random = math.random(1,100)

    if random < 50 then
    	TriggerEvent("esx_custom_messages:showMessage", title, "Por favor, comprame una mascara, tengo que dar de comer a 7 hijos de 5 mujeres!", imgMask, "ropa_m_hola1.mp3", true, 6000)
    	Citizen.Wait(6000)
    else
    	TriggerEvent("esx_custom_messages:showMessage", title, "Por favor, ayudame, dentro de este traje hace mucho calor.", imgMask, "ropa_m_hola2.mp3", true, 6000)
    	Citizen.Wait(6000)
    end	
	OpenShopMenu("Mask")
end)



function openEndDialog()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_confirm',
	{
		title = _U('valid_purchase'),
		align = 'center',
		elements = {
			{label = _U('no'), value = 'no'},
			{label = _U('yes', ESX.Math.GroupDigits(Config.Price)), value = 'yes'}
		}
	}, function(data, menu)
		menu.close()
		if data.current.value == 'yes' then
			ESX.TriggerServerCallback('esx_newaccessories:checkMoney', function(hasEnoughMoney)
				if hasEnoughMoney then
					TriggerServerEvent('esx_newaccessories:pay')
					TriggerEvent('skinchanger:getSkin', function(skin)
						TriggerServerEvent('esx_newaccessories:save', skin, accesorio) --accessory
					end)
					local random = math.random(1,100)
					if accesorio == "Mask" then				
					    if random < 50 then
					    	TriggerEvent("esx_custom_messages:showMessage", title, "Oye, gracias a ti, hoy mis hijos podran cenar comida de verdad.", imgMask, "ropa_m_buy1.mp3", true, 6000)
					    else
					    	TriggerEvent("esx_custom_messages:showMessage", title, "No se por que sigo trabajando aqui, odio mi vida...", imgMask, "ropa_m_buy2.mp3", true, 6000)
					    end
					else
						if random < 50 then
					    	--TriggerEvent("esx_custom_messages:showMessage", title, "Vaya, que estilo...", img, "ropa_c_buy1.mp3", true, 4000)
					    	TriggerEvent("esx_custom_messages:showMessage", title, "Chao! Que lo pases bien.", img, "ropa_c_buy2.mp3", true, 3000)
					    else
					    	TriggerEvent("esx_custom_messages:showMessage", title, "Chao! Que lo pases bien.", img, "ropa_c_buy2.mp3", true, 3000)
					    end
					end
					hasPaid = true
				else
					TriggerEvent('esx_skin:getLastSkin', function(skin)
						TriggerEvent('skinchanger:loadSkin', skin)
					end)
					ESX.ShowNotification(_U('not_enough_money'))
				end
			end)
		end

		if data.current.value == 'no' then
			hasPaid = false
			local player = PlayerPedId()
			TriggerEvent('esx_skin:getLastSkin', function(skin)
				TriggerEvent('skinchanger:loadSkin', skin)
			end)
			if accesorio == "Ears" then --accessory
				ClearPedProp(player, 2)
			elseif accesorio == "Mask" then
				SetPedComponentVariation(player, 1, 0 ,0, 2)
			elseif accesorio == "Helmet" then --accessory
				ClearPedProp(player, 0)
			elseif accesorio == "Glasses" then --accessory
				SetPedPropIndex(player, 1, -1, 0, 0)
			end
		end
		CurrentAction     = 'shop_menu'
		CurrentActionMsg  = _U('press_access')
		CurrentActionData = {}
	end, function(data, menu)
		TriggerEvent('esx_skin:getLastSkin', function(skin)
			TriggerEvent('skinchanger:loadSkin', skin)
		end)
		menu.close()
		CurrentAction     = 'shop_menu'
		CurrentActionMsg  = _U('press_access')
		CurrentActionData = {}

	end)
end

RegisterNUICallback("endDialogAccessories", function()
	print('funciona')
	TriggerEvent("esx_np_skinshop:toggleMenu")
	openEndDialog()
end)
RegisterNetEvent('esx_newaccessories:endDialog')
AddEventHandler('esx_newaccessories:endDialog', function()
	openEndDialog()
end)


AddEventHandler('playerSpawned', function()
	isDead = false
end)

AddEventHandler('esx:onPlayerDeath', function()
	isDead = true
end)

AddEventHandler('esx_newaccessories:hasEnteredMarker', function(zone)
	CurrentAction     = 'shop_menu'
	CurrentActionMsg  = _U('press_access')
	CurrentActionData = { accessory = zone }
end)

AddEventHandler('esx_newaccessories:hasExitedMarker', function(zone)
	--print('apretaste esc')
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil
	if not hasPaid then
		TriggerEvent('esx_skin:getLastSkin', function(skin)
			TriggerEvent('skinchanger:loadSkin', skin)
		end)
	end
end)

-- Create Blips --
Citizen.CreateThread(function()
	for k,v in pairs(Config.ShopsBlips) do
		if v.Pos ~= nil then
			for i=1, #v.Pos, 1 do
				local blip = AddBlipForCoord(v.Pos[i].x, v.Pos[i].y, v.Pos[i].z)

				SetBlipSprite (blip, v.Blip.sprite)
				SetBlipDisplay(blip, 4)
				SetBlipScale  (blip, 0.8)
				SetBlipColour (blip, v.Blip.color)
				SetBlipAsShortRange(blip, true)

				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString(_U('shop', _U(string.lower(k))))
				EndTextCommandSetBlipName(blip)
			end
		end
	end
end)

-- Display markers
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local coords = GetEntityCoords(PlayerPedId())
		for k,v in pairs(Config.Zones) do
			for i = 1, #v.Pos, 1 do
				if(Config.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, true) < Config.DrawDistance) then
					DrawMarker(Config.Type, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.Size.x, Config.Size.y, Config.Size.z, Config.Color.r, Config.Color.g, Config.Color.b, 100, false, true, 2, false, false, false, false)
				end
			end
		end
	end
end)


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(200)

		local coords      = GetEntityCoords(PlayerPedId())
		local isInMarker  = false
		local currentZone = nil
		for k,v in pairs(Config.Zones) do
			for i = 1, #v.Pos, 1 do
				if GetDistanceBetweenCoords(coords, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, true) < Config.Size.x then
					isInMarker  = true
					currentZone = k
				end
			end
		end

		if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
			HasAlreadyEnteredMarker = true
			LastZone = currentZone
			TriggerEvent('esx_newaccessories:hasEnteredMarker', currentZone)
		end

		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('esx_newaccessories:hasExitedMarker', LastZone)
		end

	end
end)

-- Key controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		
		if CurrentAction ~= nil then
			ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(0, 38) and CurrentActionData.accessory then
				OpenShopMenu(CurrentActionData.accessory)
				CurrentAction = nil
			end
		elseif CurrentAction == nil and not Config.EnableControls then
			Citizen.Wait(500)
		end
	end
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
        hash = GetHashKey('ig_lacey_jones_02')
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
    hash = GetHashKey('u_m_y_pogo_01')
        RequestModel(hash)
        while not HasModelLoaded(hash) do
			Wait(0)
		end
		listPos = 15 --tienda de mascaras
        if not DoesEntityExist(pedEntities[listPos]) then
            pedEntities[listPos] = CreatePed(4, hash, -1337.16, -1276.87, 3.89, 107.72)
            SetEntityAsMissionEntity(pedEntities[listPos])
            SetBlockingOfNonTemporaryEvents(pedEntities[listPos], true)
            FreezeEntityPosition(pedEntities[listPos], true)
            SetEntityInvincible(pedEntities[listPos], true)
        end
        SetModelAsNoLongerNeeded(hash)
end)

RegisterCommand("open", function()
	TriggerEvent("esx_np_skinshop:toggleMenu", '')
end)

local cam = -1							-- Camera control
local zoom = "ropa"					-- Define which tab is shown first (Default: Head)
local isCameraActive
local camHeading = 0.0
local angulo = 0
local camOffset, zoomOffset = 1.8, 0.0
local lastSkin = nil

-----------------------------------------------------------------------------------------------------------------------------------------
-- Menu toggle
-----------------------------------------------------------------------------------------------------------------------------------------
local m, f = GetHashKey("mp_m_freemode_01"), GetHashKey("mp_f_freemode_01")
local cor = 0
local menuactive = false

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	playerLoaded = true
end)

--RegisterNetEvent("esx_np_skinshop:toggleMenu")
AddEventHandler("esx_np_skinshop:toggleMenu", function(restriction)
	menuactive = not menuactive
	if menuactive then
		TriggerEvent('skinchanger:getSkin', function(skin)
			lastSkin = skin
			TriggerEvent('esx_skin:setLastSkin', skin)
		end)
		CreateSkinCam()
		SetNuiFocus(true,true)
		local ped = PlayerPedId()
		if IsPedModel(ped, m) then
			SendNUIMessage({ showMenu = true, masc = true, type = restriction})
		elseif IsPedModel(ped, f) then
			SendNUIMessage({ showMenu = true, masc = false, type = restriction})		
		end
	else
		cor = 0
		dados, tipo = nil
		SetNuiFocus(false)
		SendNUIMessage({ showMenu = false, masc = true })

		DeleteSkinCam()
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if menuactive then InvalidateIdleCam() end
	end
end)


---------------------------------------------------------------------------------------- 
--================================CAMERA==============================================--

RegisterNUICallback('zoom', function(data, cb)
	zoom = data
end)


function CreateSkinCam()
	if not DoesCamExist(cam) then
		cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
	end

	SetCamActive(cam, true)
	RenderScriptCams(true, true, 500, true, true)

	local playerPed = PlayerPedId()
	local playerHeading = GetEntityHeading(playerPed)
	if playerHeading + 94 < 360.0 then
		camHeading = playerHeading + 94.0
	elseif playerHeading + 94 >= 360.0 then
		camHeading = playerHeading - 266.0 --194
	end
	angulo = camHeading
	isCameraActive = true
	SetCamCoord(cam, GetEntityCoords(GetPlayerPed(-1)))
end

function DeleteSkinCam()
	isCameraActive = false
	SetCamActive(cam, false)
	RenderScriptCams(false, true, 500, true, true)
	cam = nil
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if isCameraActive == true then
			local playerPed = PlayerPedId()
			local coords    = GetEntityCoords(playerPed)

			if zoom == "cara" or zoom == "pelo" then
				zoomOffset = 0.5
				camOffset = 0.7
			elseif zoom == "tops" then
				zoomOffset = 1.2
				camOffset = 0.5
			elseif zoom == "pants" then
				zoomOffset = 1.2
				camOffset = -0.3
			elseif zoom == "ropa" then
				zoomOffset = 1.8
				camOffset = 0.0
			elseif zoom == "zapatos" then
				zoomOffset = 1.0
				camOffset = -0.8
			end
			local angle = camHeading * math.pi / 180.0
			local theta = {
				x = math.cos(angle),
				y = math.sin(angle)
			}

			local pos = {
				x = coords.x + (zoomOffset * theta.x),
				y = coords.y + (zoomOffset * theta.y)
			}

			local angleToLook = camHeading - 200.0 --140.0
			if angleToLook > 360 then
				angleToLook = angleToLook - 360
			elseif angleToLook < 0 then
				angleToLook = angleToLook + 360
			end

			angleToLook = angleToLook * math.pi / 180.0
			local thetaToLook = {
				x = math.cos(angleToLook),
				y = math.sin(angleToLook)
			}

			local posToLook = {
				x = coords.x + (zoomOffset * thetaToLook.x),
				y = coords.y + (zoomOffset * thetaToLook.y)
			}

			SetCamCoord(cam, pos.x, pos.y, coords.z + camOffset)
			PointCamAtCoord(cam, posToLook.x, posToLook.y, coords.z + camOffset)
		else
			Citizen.Wait(1000)
		end
	end

end)

-- Retornos
-----------------------------------------------------------------------------------------------------------------------------------------

RegisterNUICallback("exit", function(data)
	TriggerEvent('skinchanger:loadSkin', lastSkin)
	--print(data)
	TriggerEvent("esx_np_skinshop:toggleMenu")
end)

RegisterNUICallback("rotate", function(data, cb)
	if data == "left" then
		angulo = angulo - 1
	elseif data == "right" then
		angulo = angulo + 1
	end

	if angulo > 360 then
		angulo = angulo - 360
	elseif angulo < 0 then
		angulo = angulo + 360
	end

	camHeading = angulo + 0.0

end)

RegisterNUICallback("update", function(data, cb)
	dados = tonumber(json.encode(data[1]))
	tipo = tonumber(json.encode(data[2]))
	cor = 0
	setRoupa(dados, tipo, cor)
end)

RegisterNUICallback("color", function(data, cb)
	if data == "left" then
		if cor ~= 0 then cor = cor - 1 else cor = 20 end
	elseif data == "right" then
		if cor ~= 21 then cor = cor + 1 else cor = 0 end
	end
	if dados and tipo then setRoupa(dados, tipo, cor) end
end)

function setRoupa(dados, tipo, cor)
	local ped = PlayerPedId()
	local key = ''
	local color = ''
	--if dados < 100 then		
		--SetPedComponentVariation(ped, dados, tipo, cor, 1)
	--else
		--SetPedPropIndex(ped, dados-100, tipo, cor, 1)
	--end
	if(dados < 100) then
		if dados == 1 then
			key = 'mask_1'
			color = 'mask_2'
		elseif dados == 3 then
			key = 'arms'
			color = 'arms_2'
		elseif dados == 4 then
			key = 'pants_1'
			color = 'pants_2'
		elseif dados == 5 then
			key = 'bags_1'
			color = 'bags_2'
		elseif dados == 6 then
			key = 'shoes_1'
			color = 'shoes_2'
		elseif dados == 7 then
			key = 'chain_1'
			color = 'chain_2'
		elseif dados == 8 then 
			key = 'tshirt_1'
			color = 'tshirt_2'
		elseif dados == 9 then
			key = 'bproof_1'
			color = 'bproof_2'
		elseif dados == 11 then
			key = 'torso_1'
			color = 'torso_2'
		end
	else
		dadas = dados-100
		if dadas == 0 then
			key = 'helmet_1'
			color = 'helmet_2'
		elseif dadas == 1 then
			key = 'glasses_1'
			color = 'glasses_2'
		elseif dadas == 2 then
			key = 'ears_1'
			color = 'ears_2'
		elseif dadas == 6 then -- MEJOR DEJARLO COMO ACCESORIOS (to do?)
			key = 'watches_1'
			color = 'watches_2'
		elseif dadas == 7 then -- MEJOR DEJARLO COMO ACCESORIOS (to do?)
			key = 'bracelets_1'
			color = 'bracelets_2'
		end
	end
	TriggerEvent('skinchanger:change', key, tipo)
	TriggerEvent('skinchanger:change', color, cor)
end
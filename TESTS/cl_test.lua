ESX = nil
ExM = nil

ExM = exports.extendedmode:getExtendedModeObject()

Citizen.CreateThread(function()
	while ESX == nil do
		ESX = exports.extendedmode:getSharedObject()
		Citizen.Wait(5)
    end
end)

RegisterCommand("cordenadas",function()
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped,true)
	local h = GetEntityHeading(ped)
	print(coords.x.." "..coords.y.. " " .. coords.z.." "..h)
end,false)


--Como funciona el tema de crear un vehiculo que vaya a x sitio
RegisterCommand("startdrivertest", function()
	local generatedPlate = "pepe"
	ESX.Game.SpawnVehiclePedDriven("zentorno",vector3(-222.74,-1161.22, 22.59), 248.93,vector3(-47.43,  -1110.23, 26.01),"s_m_y_devinsec_01",70,"pepe",function(car,ped)
		if car and ped then 
			print(car)
			print(ped)
			print("Funcionando")
		end
	end,true)
end,false)

--RegisterCommand("taskseq", function()
--	local val,taskId = OpenSequenceTask()
--	--print(json.encode(val) .. " "..taskId)
--	local ped =
--	CreatePed(
--		"PED_TYPE_CIVMALE" --[[ integer ]], 
--		GetHashKey("a_m_y_stbla_02") --[[ Hash ]], 
--		-46.908, -1110.0924, 26.435 , 
--		340 --[[ number ]], 
--		true --[[ boolean ]], 
--		true --[[ boolean ]]
--	)
--	--TaskPause(0,5000)
--	TaskGoStraightToCoord(
--		 ped--[[ Ped ]], 
--		-36.62 - 2 --[[ number ]], 
--		-1110.97 --[[ number ]], 
--		26.43 --[[ number ]], 
--		5 --[[ number ]], 
--		-1 --[[ integer ]], 
--		100.80 --[[ number ]], 
--		1 --[[ number ]]
--	)
--	TaskPause
--	--ClearPedTasksImmediately(ped)
--	--TaskPause(0,1000)
--	--TaskPause(0,1000)
--	TaskPerformSequence(
--		ped --[[ Ped ]], 
--		taskId --[[ integer ]]
--	)
--	local pro = GetSequenceProgress(
--		ped --[[ Ped ]]
--	)
--	print(pro)
--	--CloseSequenceTask(taskId)
--
--end,false)
--

RegisterCommand("npcspawn", function(s, args) 
	local cc = GetEntityCoords(PlayerPedId())
	local id = ExM.Game.CreatePed(`cs_martinmadrazo`, cc)
	local id = CreatePed(GetHashKey("PED_TYPE_CIVMALE"), GetHashKey("cs_martinmadrazo"), cc.x, cc.y, cc.z, 0.0, true, true)
	print(id)
end)

RegisterCommand("testanima", function()
	--ExM.Game.PlayAnim("anim@heists@ornate_bank@grab_cash_heels", "grab", true, 1000)
	ESX.Streaming.RequestModel("cs1_15b_convo_01" , function()
	local cor = GetEntityCoords(PlayerPedId())
	print("me fumo un porro")
	local entity = CreateObject(
		GetHashKey("cs1_15b_convo_01") --[[ Object ]], 
		cor.x + 1 --[[ number ]],
		cor.y,
		cor.z,
		false --[[ boolean ]], 
		false --[[ boolean ]], 
		false --[[ boolean ]]
	)
	--ActivatePhysics(
		--entity --[[ Object ]]
	--)
	print("entity: "..entity)
	--Citizen.Wait(500)
	--local boneindex
   --
	--if hand then
	--   boneindex = GetPedBoneIndex(self.ped ,hand)
	--else
	--   boneindex = GetPedBoneIndex(PlayerPedId() ,28422)
	--end
	--
	--ExM.Game.PlayAnim("mp_common", "givetake1_a", true, 3000)
	--Citizen.Wait(1000)
	--local cords = GetPedBoneCoords(PlayerPedId(), 28422, 0, 0, 0)
	--AttachEntityToEntity(entity, PlayerPedId(), boneindex, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
	--Citizen.Wait(1000)
	--DeleteObject(entity)
	end)
end,false)

RegisterCommand("probarSonido",function()
	ESX.PlaySound('error',0.5)
end)

RegisterCommand("transformarJson",function()
	local x={
		title = 'Hola',
		align = 'top-left',
		elements = {
			{label = "No",  value = 'no'},
			{label = "Yes", value = 'yes'}
		}
	}
	--print(json.encode(x))
end,false)


RegisterCommand("gethashfromword", function(a,args)
	if args[1] ~= nil then
		print(GetHashKey(args[1]))
	end
end)

RegisterCommand("syncedgiveitemtest", function()
	local target =ESX.Game.GetClosestPlayer()
	print(target)
	print(PlayerId())
	local coords = GetEntityCoords(GetPlayerPed(-1))
	local targetId = GetPlayerServerId(target)
--local entity = CreateObject(GetHashKey("prop_beer_box_01") --[[ Object ]], coords, true --[[ boolean ]], true --[[ boolean ]], true --[[ boolean ]])
    ESX.Actions.giveObjectSynced(false, targetId, nil)
end, false)

RegisterCommand("Foto",function()
	exports['screenshot-basic']:requestScreenshot(function(data)
		TriggerServerEvent('server:Guardar',data)
		TriggerEvent('chat:addMessage', { template = '<img src="{0}" style="max-width: 300px;" />', args = { data } })
	end)
end,false)

RegisterCommand("Ped",function()
	local vehicleNetId = NetworkGetNetworkIdFromEntity(vehicle)
	SetNetworkIdCanMigrate(vehicleNetId, true)
	SetNetworkIdExistsOnAllMachines(vehicleNetId, true)
	NetworkRegisterEntityAsNetworked(VehToNet(vehicle))
	
end)

RegisterCommand("input",function()
	ESX.Input("hola","hola",function(text)
		print(text)
	end)
end)

local handsUp = false
CreateThread(function()
    while true do
        Wait(0)
        if handsUp then
            TaskHandsUp(PlayerPedId(), 250, PlayerPedId(), -1, true)
        end
    end
end)
RegisterCommand('+handsup', function()
	handsUp = true
	print("Aprieto")
end, false)
RegisterCommand('-handsup', function()
	handsUp = false
	print("Levanto")
end, false)
RegisterKeyMapping('+handsup', 'Hands Up', 'keyboard', 'i')


RegisterCommand('testboatroom', function()
	local veh = GetVehiclePedIsIn(PlayerPedId())
	local offset = vector3(0,0,0)
	local vehcoords = GetEntityCoords(veh, 1)
	local realCoords = GetOffsetFromEntityInWorldCoords(veh, offset.x, offset.y, offset.z)
	ESX.Markers.Add(36, realCoords, 1,1,250, 250, 1, vec(1, 1, 1), vec(0, 0, 0), vec(0, 0, 0), true, nil, nil)
	print(realCoords)
	print(vehcoords)
end, false)




RegisterCommand('stopcutscene',function()
	StopCutsceneImmediately()
end)
--mp_intro_concat
RegisterCommand('cutscene',function()
	PreloadCloudHat("CONTRAILS")
	RequestCutsceneEx('mp_intro_concat', 103, 8)
	RegisterEntityForCutscene(0, "MP_Male_Character", 3,GetHashKey("mp_m_freemode_01"), 0)
	RegisterEntityForCutscene(PlayerPedId(), "MP_Female_Character", 0,0,0)
	if Citizen.InvokeNative(0xB56BBBCC2955D9CB) then
		Citizen.InvokeNative(0x4C61C75BEE8184C2,"MP_Male_Character", 0, 1)
	end
	LoadCloudHat("CONTRAILS",0)
	StartCutscene(4)
end)

RegisterCommand("rewardtest",function()
	Citizen.CreateThread(function()
		while true do Wait(0)
			if IsPedInAnyPoliceVehicle(PlayerPedId()) or IsPedInAnyHeli(PlayerPedId()) then
				DisablePlayerVehicleRewards(PlayerId())
			end
		end
	end)
end)


RegisterCommand("testmuleattach",function(source)
	local coords = GetEntityCoords(PlayerPedId())
	--local veh = GetClosestVehicle(coords.x, coords.y,coords.z, 15.0, GetHashKey("mule2"), 70)
	--local vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5, GetHashKey("mule2"), 70)

	--IsPedInAnyVehicle(PlayerPedId(), false)
	--print(veh)
	--print("distance: ".. distance)
	if IsPedInAnyVehicle(PlayerPedId()) then
		local myveh = GetVehiclePedIsIn(PlayerPedId(), false)
		local boneindex = GetEntityBoneIndexByName(veh, "chassis_dummy")
		--local coords = GetPedBoneCoords(ped, boneId, offsetX, offsetY, offsetZ)
		--print(boneindex)
		--print(GetWorldPositionOfEntityBone(veh, boneindex))
		local bonecoords = GetWorldPositionOfEntityBone(veh, boneindex)
		local newVeh = vec(bonecoords.x, bonecoords.y, bonecoords.z + 1)
		
		local veh = GetClosestVehicle(coords.x,coords.y,coords.z, 5.0, GetHashKey("mule2"), 70)

		if veh == 0 or veh == nil then
			local players = ESX.Game.GetPlayersInArea(coords, 8)
			for k,v in pairs(players) do
				local ped = GetPlayerPed(v)
				if GetEntityModel(GetVehiclePedIsIn(ped)) == GetHashKey("mule2") then
					if #(GetEntityCoords(veh)) < 5 then
						veh = GetVehiclePedIsIn(ped)
					end
				end
			end
		end
		local boneindex = GetEntityBoneIndexByName(veh, "chassis_dummy")
		local bonecoords = GetWorldPositionOfEntityBone(veh, boneindex)
		print(veh)
		--local ramp = CreateObject(GetHashKey("prop_mp_ramp_02"), bonecoords.x, bonecoords.y, bonecoords.z, true)
		--SetEntityCollision(ramp, false, false)
		--AttachEntityToEntity(ramp,veh , boneindex, -0.0, -10.0, -0.25, 0.00, 0.0, 0.0, true, true, false, true, 1, true)
		AttachEntityToEntity(myveh,veh , boneindex, 0.0, -0.5, 0.0, 0.0, 0.5, 180.0, true, true, false, true, 1, true)
		--AttachEntityToEntity(veh, myveh, boneIndex, xPos, yPos, zPos, xRot, yRot, zRot, p9, useSoftPinning, collision, isPed, vertexIndex, fixedRot)
		SetEntityCollision(ramp, true, true)
	end
end)

RegisterCommand("testmuledeattach",function(source)

	if IsPedInAnyVehicle(PlayerPedId()) then
		local veh = GetVehiclePedIsIn(PlayerPedId())

		if IsEntityAttached(veh) then
			DetachEntity(veh)
		end
	end

end)


RegisterCommand("gpsoff",function(source) 

	Citizen.CreateThread(function() 
		while true do
			Wait(1)
			SetGpsActive(false)
		end
	end)
end)


RegisterCommand("tellmecommands", function() 
	local comm = GetRegisteredCommands()
	print(json.encode(comm))

end, false)

RegisterCommand("testminimapset", function() 
	SetBigmapActive(
	false --[[ boolean ]], 
	false --[[ boolean ]]
)

end)

RegisterCommand("testbigmap", function() 
	local expanded = IsBigmapActive()

local fullMap = IsBigmapFull()

print("The minimap is currently " .. (expanded and "expanded" or "normal size") .. " and the full map is currently " .. (fullMap and "revealed" or "not revealed") .. ".")
end)


RegisterCommand("Testanimationcut", function() 
	--ExM.Game.PlayAnim("combat@death@from_writhe", "death_c", false, 10000) 
	ESX.Streaming.RequestAnimDict('mini@repair', function()
		--TaskPlayAnim(PlayerPedId(), 'combat@death@from_writhe', 'death_c', 1.0, -1.0, -1, 1, 2, true, true, true)
		TaskPlayAnim(PlayerPedId(), 'mini@repair', 'fixing_a_player', 1.0, -1.0, -1, 1, 2, true, true, true)
	--ExM.Game.PlayAnim("random@crash_rescue@wounded@base", "base", false, 30000) -- no letal
	end)
	--ExM.Game.PlayAnim("gestures@f@standing@casual", "gesture_hand_down", false, 5000) 

	--ExM.Game.PlayAnim("gestures@f@standing@casual", "gesture_you_hard", false, 5000)
end, false)

RegisterCommand("playguitar", function() 
	TriggerServerEvent("playguitartest")
	ExecuteCommand("e guitar")
end)

RegisterCommand("playcoolguitar", function() 
	TriggerServerEvent("playcoolguitartest")
	ExecuteCommand("e guitarelectric")
end)

RegisterCommand("nothingelse", function() 
	TriggerServerEvent("playnothingelse")
	ExecuteCommand("e guitar")
end)


RegisterNetEvent("playsmokewater")
AddEventHandler("playsmokewater", function() 
	ExecuteCommand("e guitarelectric")
end)

RegisterCommand("spawnfans", function() 
	local coords = GetEntityCoords(PlayerPedId())
	local hea = GetEntityHeading(PlayerPedId())
	ESX.Streaming.RequestModel(GetHashKey("a_f_y_beach_01"))
	ESX.Streaming.RequestAnimDict("amb@world_human_cheering@male_a", function()
		local ped = CreatePed(4, GetHashKey("a_f_y_beach_01"), coords.x, coords.y, coords.z, hea, true)
		Wait(5000)
		TaskPlayAnim(ped, "amb@world_human_cheering@male_a", "base", 2.0, 2.0, -1, 1, 0, false, false, false)
		print(ped)
	end)
end)

RegisterCommand("testmousea", function() 
	EnterCursorMode()
end)

RegisterCommand("testmouseb", function() 
	LeaveCursorMode()
	print("ehpa")
end)

local raycastLength = 50.0
local abs = math.abs
local cos = math.cos
local sin = math.sin
local pi = math.pi

function RotationToDirection(rotation)
    local x = rotation.x * pi / 180.0
    --local y = rotation.y * pi / 180.0
    local z = rotation.z * pi / 180.0
    local num = abs(cos(x))
    return vector3((-sin(z) * num), (cos(z) * num), sin(x))
end
 
function World3DToScreen2D(pos)
    local _, sX, sY = GetScreenCoordFromWorldCoord(pos.x, pos.y, pos.z)
    return vector2(sX, sY)
end

function ScreenRelToWorld(camPos, camRot, cursor)
    local camForward = RotationToDirection(camRot)
    local rotUp = vector3(camRot.x + 1.0, camRot.y, camRot.z)
    local rotDown = vector3(camRot.x - 1.0, camRot.y, camRot.z)
    local rotLeft = vector3(camRot.x, camRot.y, camRot.z - 1.0)
    local rotRight = vector3(camRot.x, camRot.y, camRot.z + 1.0)
    local camRight = RotationToDirection(rotRight) - RotationToDirection(rotLeft)
    local camUp = RotationToDirection(rotUp) - RotationToDirection(rotDown)
    local rollRad = -(camRot.y * pi / 180.0)
    local camRightRoll = camRight * cos(rollRad) - camUp * sin(rollRad)
    local camUpRoll = camRight * sin(rollRad) + camUp * cos(rollRad)
    local point3DZero = camPos + camForward * 1.0
    local point3D = point3DZero + camRightRoll + camUpRoll
    local point2D = World3DToScreen2D(point3D)
    local point2DZero = World3DToScreen2D(point3DZero)
    local scaleX = (cursor.x - point2DZero.x) / (point2D.x - point2DZero.x)
    local scaleY = (cursor.y - point2DZero.y) / (point2D.y - point2DZero.y)
    local point3Dret = point3DZero + camRightRoll * scaleX + camUpRoll * scaleY
    local forwardDir = camForward + camRightRoll * scaleX + camUpRoll * scaleY
    return point3Dret, forwardDir
end

function ScreenToWorld(flags, toIgnore)
    local camRot = GetGameplayCamRot(0)
    local camPos = GetGameplayCamCoord()
    local posX = GetControlNormal(0, 239)
    local posY = GetControlNormal(0, 240)
    local cursor = vector2(posX, posY)
	local cam3DPos, forwardDir = ScreenRelToWorld(camPos, camRot, cursor)
	--print(cam3DPos)
    local direction = camPos + forwardDir * raycastLength
    local rayHandle = StartShapeTestRay(cam3DPos, direction, flags, toIgnore, 0)
    local _, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(rayHandle)
    if entityHit >= 1 then
        entityType = GetEntityType(entityHit)
    end
    return hit, endCoords, surfaceNormal, entityHit, entityType, direction
end
entity = {}
--Citizen.CreateThread(function()
--	display = false
--	item = nil
--    while true do
--        Citizen.Wait(0)
--        player = GetPlayerPed(-1, false)
--        playerCoords = GetEntityCoords(player, 1)
--        
--        if IsControlJustPressed(1, 20) and not display then
--				EnterCursorMode()
--				display = true
--				startRaycast = true
--        end
--		if IsControlJustReleased(1, 23) and display then
--				display = false
--				LeaveCursorMode()
--				startRaycast = false
--				DeleteObject(item)
--				item = nil
--        end
--        if display then
--            --disableControls()
--		end
--		
--        if startRaycast then
--            local hit, endCoords, surfaceNormal, entityHit, entityType, direction = ScreenToWorld(1, 0)
--            if entityHit == 0 then
--                entityType = 0
--			end
--			--print("quee pasaa")
--            entity.target = entityHit
--            entity.type = entityType
--            entity.hash = GetEntityModel(entityHit)
--            entity.coords = GetEntityCoords(entityHit, 1)
--            entity.heading = GetEntityHeading(entityHit)
--            entity.rotation = GetEntityRotation(entityHit)
--            entity.modelName = exports["hashtoname"]:objectNameFromHash(entity.hash)
--            entity.extraRayData = {}
--            entity.extraRayData.endCoords = endCoords
--            entity.extraRayData.surfaceNormal = surfaceNormal
--			entity.extraRayData.direction = direction
--			if item == nil then
--				item = CreateObject(
--					GetHashKey("prop_paints_can07") --[[ Object ]], 
--					endCoords.x + 1 --[[ number ]],
--					endCoords.y,
--					endCoords.z,
--					true --[[ boolean ]], 
--					false --[[ boolean ]], 
--					false --[[ boolean ]]
--				)
--				FreezeEntityPosition(item, true)
--			end
--			print(endCoords)
--			if item then
--				SetEntityCoords(item, endCoords.x, endCoords.y, endCoords.z, 0,0,0 , false)
--			end
--            if IsPedAPlayer(entityHit) then --IsPedAPlayer returns false or 1 NOT true or false .. weirdly
--                if entityHit == PlayerPedId() then
--                    entity.isSelf = true
--                end
--                entity.isPlayer = true
--            else
--                entity.isPlayer = false
--            end
--            --SendObjectData()
--        end
--    end
--end)


function getMyThing()--this could return the thing or "nil"
	local val = math.random(1,2)
	if val == 1 then
		return 1
	else
		return nil
	end 
 end
 
 function myFunction(param1, param2 , param3)
	TriggerEvent("testignoredparam", param1, param2 , param3)
   --if param1 then
	-- print("param1: "..param1) -- if (nil,nil, "Ey") was sended, "Ey" will be printed here (¿canary bug?)
   --end
   --if param2 then
	-- print("param2: "..param2)
   --end
   --if param3 then
	-- print("param3: "..param3) -- if (false,false, "Ey") was sended, "Ey" will be printed here -- in previous version this will be the result always
   --end
 end
 
 myFunction(false, getMyThing(), "Ey") -- at this way param1 and parm2 will be passed and param3 will be passed as param3
 
 myFunction(nil, getMyThing(), "Ey")

AddEventHandler("testignoredparam", function(param1, param2 , param3) 
	if param1 then
		print("param1: "..param1) -- if (nil,nil, "Ey") was sended, "Ey" will be printed here (¿canary bug?)
	end
	if param2 then
	print("param2: "..param2)
	end
	if param3 then
	print("param3: "..param3) -- if (false,false, "Ey") was sended, "Ey" will be printed here -- in previous version this will be the result always
	  end
end)
 
RegisterCommand("ParamsIgnoredTestBehaviour", function(param1, param2 , param3) 
	print("'Ey' should be param 3:")
	myFunction(nil,nil, "Ey")
	print("'Ey' should be param 3:")
	myFunction(nil,false, "Ey")
	print("'Ey' should be param 3:")
	myFunction(false,false, "Ey")
	print("'Ey' should be param 3 and param2 may be 1:")
	myFunction(nil, getMyThing(), "Ey")
	print("'Ey' should be param 3, param2 and param1 may be 1:")
	myFunction(getMyThing(), getMyThing(), "Ey")
	print("'Ey' should be param 2:")
	myFunction(nil, "Ey", nil)
end)



RegisterCommand("tetstruckwithlift", function() 
exports['enc0ded-forklift-trailer']:SpawnTruckTrailerAndForklift("trflat", GetEntityCoords(PlayerPedId()), function() 
	print("Hola")
end)
end)

RegisterCommand("testpallets", function() 
	local vec =  GetEntityCoords(PlayerPedId())
	vec = vector3(vec.x, vec.y + 2, vec.z)
	exports['enc0ded-forklift-trailer']:SpawnPalletsWithProducts(1, 'industry', {x = vec.x, y = vec.y,z = vec.z}, {x = 0.0, y = 2.5})

end)


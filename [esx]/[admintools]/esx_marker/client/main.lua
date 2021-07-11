local ESX = nil

noclip = false
noclip_pos = {}
local heading = 0

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) 
            ESX = obj 
        end)

        Citizen.Wait(0)
    end
end)
RegisterCommand("heal", function(source)
	TriggerEvent('esx_ambulancejob:heal', 'big', true)
	print "1"
end)


RegisterCommand("tpm", function(source)
    TeleportToWaypoint()
end)

RegisterCommand("noclip", function(source)
	--noclip_pos = GetEntityCoords(PlayerPedId(), false)
	admin_no_clip()
end)

function admin_no_clip()
	noclip = not noclip
	if noclip then
		plyPed = PlayerPedId()
		FreezeEntityPosition(plyPed, true)
		SetEntityInvincible(plyPed, true)
		SetEntityCollision(plyPed, false, false)

		SetEntityVisible(plyPed, false, false)

		SetEntityInvincible(GetPlayerPed(-1),true)

		SetEveryoneIgnorePlayer(PlayerId(), true)
		SetPoliceIgnorePlayer(PlayerId(), true)
		SetNotificationTextEntry("STRING")
		AddTextComponentString("Noclip aktivado" )
		DrawNotification(false, true)
	else
		plyPed = PlayerPedId()
		FreezeEntityPosition(plyPed, false)
		SetEntityInvincible(plyPed, false)
		SetEntityCollision(plyPed, true, true)

		SetEntityInvincible(GetPlayerPed(-1),false)

		SetEntityVisible(plyPed, true, false)

		SetNotificationTextEntry("STRING")
		AddTextComponentString("Noclip desaktivado" )
		DrawNotification(false, true)
	end
end

function getCamDirection()
	local heading = GetGameplayCamRelativeHeading() + GetEntityHeading(plyPed)
	local pitch = GetGameplayCamRelativePitch()
	local coords = vector3(-math.sin(heading * math.pi / 180.0), math.cos(heading * math.pi / 180.0), math.sin(pitch * math.pi / 180.0))
	local len = math.sqrt((coords.x * coords.x) + (coords.y * coords.y) + (coords.z * coords.z))

	if len ~= 0 then
		coords = coords / len
	end

	return coords
end


TeleportToWaypoint = function()
    ESX.TriggerServerCallback("esx_marker:fetchUserRank", function(playerRank)
        if playerRank == "admin" or playerRank == "superadmin" or playerRank == "mod" then
            local WaypointHandle = GetFirstBlipInfoId(8)

            if DoesBlipExist(WaypointHandle) then
                local waypointCoords = GetBlipInfoIdCoord(WaypointHandle)

                for height = 1, 1000 do
                    SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

                    local foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords["x"], waypointCoords["y"], height + 0.0)

                    if foundGround then
                        SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

                        break
                    end

                    Citizen.Wait(5)
                end

                ESX.ShowNotification("¡Teletransportado!")
            else
                ESX.ShowNotification("Selecciona un punto primero!")
            end
        else
            ESX.ShowNotification("No tienes permiso para hacer eso, tienes un strike.")
        end
    end)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(20)

		if noclip then
			local plyPed = PlayerPedId() 
			local Coords = GetEntityCoords(plyPed)
			local camCoords = getCamDirection()
			local Speed  = 1.0
			
			SetEntityVelocity(plyPed, 0.01, 0.01, 0.01)

			if IsControlPressed(0,32) then
				Coords = Coords + (Speed * camCoords)
			end
			
			if IsControlPressed(0,269) then
				Coords = Coords - (Speed * camCoords)
			end

			SetEntityCoordsNoOffset(plyPed, Coords, true, true, true)
		
--[[
			if IsControlPressed(0, 32) then
				heading = heading + 1.5
				if(heading > 360)then
					heading = 0
				end

				SetEntityHeading(PlayerPedId(), heading)
			end

			if(IsControlPressed(1, 9))then
				heading = heading - 1.5
				if(heading < 0)then
					heading = 360
				end

				SetEntityHeading(PlayerPedId(), heading)
			end

			if(IsControlPressed(1, 8))then
				noclip_pos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 1.0, 0.0)
			end

			if(IsControlPressed(1, 32))then
				noclip_pos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, -1.0, 0.0)
			end

			if(IsControlPressed(1, 27))then
				noclip_pos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.0, 1.0)
			end

			if(IsControlPressed(1, 173))then
				noclip_pos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.0, -1.0)
			end]]
		else
			Citizen.Wait(200)
		end
	end
end)
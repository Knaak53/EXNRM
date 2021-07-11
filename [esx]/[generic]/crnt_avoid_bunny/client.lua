local jumpsCount = 0

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerData)
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(380)
			local playerPed = PlayerPedId()
			if IsPedJumping(playerPed) then		
				jumpsCount = jumpsCount + 1
				if jumpsCount == 4 then
					SetPedToRagdoll(playerPed, 3300, 3300, 0, 0, 0, 0)
					jumpsCount = 0
				end
			end
		end
	end)
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(2500)
			if jumpsCount > 0 then
				jumpsCount = jumpsCount - 1
			end
		end
	end)
end)

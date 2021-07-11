local coordsVisible = false

function DrawGenericText(text)
	--SetTextColour(255, 0, 0, 255)
	SetTextFont(7)
	SetTextScale(0.778, 0.778)
	--SetTextWrap(0.0, 5.0)
	--SetTextCentre(false)
	--SetTextDropshadow(1.0, 0, 0, 0, 255)
	--SetTextEdge(2.0, 0, 0, 0, 205)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(0.40, 0.00)
end

Citizen.CreateThread(function()
    while true do
		local sleepThread = 1000
		
		if coordsVisible then
			sleepThread = 5

			local playerPed = PlayerPedId()
			local playerX, playerY, playerZ = table.unpack(GetEntityCoords(playerPed))
			local playerH = GetEntityHeading(playerPed)

			DrawGenericText(("~g~X~r~: %s ~g~Y~r~: %s ~g~Z~r~: %s ~g~H~r~: %s"):format(FormatCoord(playerX), FormatCoord(playerY), FormatCoord(playerZ), FormatCoord(playerH)))
		end

		Citizen.Wait(sleepThread)
	end
end)

FormatCoord = function(coord)
	if coord == nil then
		return "unknown"
	end

	return tonumber(string.format("%.3f", coord))
end

ToggleCoords = function()
	coordsVisible = not coordsVisible
end

RegisterCommand("coords", function()
    ToggleCoords()
end)
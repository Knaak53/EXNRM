local spawn1 = false

RegisterNetEvent("caronte_loadscreen:close")
AddEventHandler("caronte_loadscreen:close", function ()
	if not spawn1 then
		ShutdownLoadingScreen()
    	ShutdownLoadingScreenNui()
		spawn1 = true
	end
end)
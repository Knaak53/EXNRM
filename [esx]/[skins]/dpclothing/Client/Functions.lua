Locale = {}

function log(l) -- Just a simple logging thing, to easily log all kinds of stuff.
	if l == nil then print("nil") return end
	if not Config.Debug then return end
	if type(l) == "table" then print(json.encode(l)) elseif type(l) == "boolean" then print(l) else print(l.." | "..type(l)) end
end

function GetKey(str)
	local Key = Keys[string.upper(str)]
	if Key then return Key else return false end
end

function IncurCooldown(ms)
	Citizen.CreateThread(function()
		Cooldown = true Wait(ms) Cooldown = false
	end)
end

-- This is my old implementation, unsure if its any better than above though, not sure if creating a thread as often as we do above is good? Time will tell i suppose.

--function IncurCooldown(ms)
--	Cooldown = ms
--end
--Citizen.CreateThread(function()
--	while true do Wait(500)
--		if Cooldown then
--			Wait(Cooldown)
--			Cooldown = false
--		end
--	end
--end)

function PairsKeys(t, f)
	local a = {}
	for n in pairs(t) do table.insert(a, n) end
	table.sort(a, f)
	local i = 0
	local iter = function ()
		i = i + 1
		if a[i] == nil then return nil
		else return a[i], t[a[i]] end
	end
	return iter
end

function Text(x, y, scale, text, colour, align, force, w)
	local align = align or 0
	local colour = colour or Config.GUI.TextColor
	SetTextFont(Config.GUI.TextFont)
	SetTextJustification(align)
	SetTextScale(scale, scale)
	SetTextColour(colour[1], colour[2], colour[3], 255)
	if Config.GUI.TextOutline then SetTextOutline() end	
	if w then SetTextWrap(w.x, w.y) end
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y)
end

function FirstUpper(str)
	return (str:gsub("^%l", string.upper))
end

function Lang(what)
	local Dict = Locale[Config.Language]
	if not Dict[what] then return Locale["en"][what] end -- If we cant find a translation, use the english one.
	return Dict[what]
end

function Notify(message) -- However you want your notifications to be shown, you can switch it up here.
	SetNotificationTextEntry("STRING")
    AddTextComponentString(message)
    DrawNotification(0,1)
end

function IsMpPed(ped)
	local Male = GetHashKey("mp_m_freemode_01") local Female = GetHashKey("mp_f_freemode_01")
	local CurrentModel = GetEntityModel(ped)
	if CurrentModel == Male then return "Male" elseif CurrentModel == Female then return "Female" else return false end
end

--[[
		Some events that might be useful for external use.
		You can trigger em with TriggerEvent("EventName").
		I was thinking about making them exports, but this is easier, if thats wrong and exports are better for some reason let me know.
]]--

--[[
		[dpc:EquipLast]
		This event will remove all saved clothes from the client.
		And put them back on the players model.
		You should use this in your own / other external scripts whenever the player :
		Eenter a clothing store, enter a barber shop, and many other uses i maybe havent though of.
		Of course you dont have to do that, but it makes the player experience better.
		Otherwise they might for example "save" a hat, then go to a clothing store and change the hat, then when using /hat it puts on the hat they had before they paid for their new hat.
]]--

RegisterNetEvent('dpc:EquipLast')
AddEventHandler('dpc:EquipLast', function()
	local Ped = PlayerPedId()
	for k,v in pairs(LastEquipped) do
		if v then
			if v.Drawable then SetPedComponentVariation(Ped, v.ID, v.Drawable, v.Texture, 0)
			elseif v.Prop then ClearPedProp(Ped, v.ID) SetPedPropIndex(Ped, v.ID, v.Prop, v.Texture, true) end
		end
	end
	LastEquipped = {}
end)

--[[
		[dpc:ResetClothing]
		Same deal as above but instead of equipping the stuff, it just clears the lastequipped.
		Useful for when you change a players model.
]]--

RegisterNetEvent('dpc:ResetClothing')
AddEventHandler('dpc:ResetClothing', function()
	LastEquipped = {}
end)

--[[
		[dpc:ToggleMenu]
		Toggle the clothing menu off/on
]]--

RegisterNetEvent('dpc:ToggleMenu')
AddEventHandler('dpc:ToggleMenu', function()
	MenuOpened = not MenuOpened
	if MenuOpened then SoundPlay("Open") SetCursorLocation(Config.GUI.Position.x, Config.GUI.Position.y) else SoundPlay("Close") end
end)

--[[
		[dpc:Menu]
		Changes status of the clothing menu.
]]--

RegisterNetEvent('dpc:Menu')
AddEventHandler('dpc:Menu', function(status)
	MenuOpened = status
	if MenuOpened then SoundPlay("Open") else SoundPlay("Close") end
end)


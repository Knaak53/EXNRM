----------------------------------------
--- Discord Whitelist,  ---
----------------------------------------

-- Documentation: https://docs.faxes.zone/docs/discord-whitelist-setup
--- Config ---
notWhitelistedMessage = "Para disfrutar del Servidor debes unirte al Discord https://discord.gg/UnckEAEWeP" -- Message displayed when they are not whitelist with the role

whitelistRoles = { -- Role IDs needed to pass the whitelist
  
    "837790639034728489", ----TESTEO
    "701496608184860753", ---- Desarrollador  
}

--- Code ---

AddEventHandler("playerConnecting", function(name, setCallback, deferrals)
    local src = source
    local passAuth = false
    deferrals.defer()

    for k, v in ipairs(GetPlayerIdentifiers(src)) do
        if string.sub(v, 1, string.len("discord:")) == "discord:" then
            identifierDiscord = v
            print (identifierDiscord)
        end
    end

    if identifierDiscord then
        usersRoles = exports.discord_perms:GetRoles(src)
        local function has_value(table, val)
            if table then
                for index, value in ipairs(table) do
                    if value == val then
                        return true
                    end
                end
            end
            return false
        end
        for index, valueReq in ipairs(whitelistRoles) do 
            if has_value(usersRoles, valueReq) then
                passAuth = true
            end
            if next(whitelistRoles,index) == nil then
                if passAuth == true then
                    deferrals.done()
                else
                    deferrals.done(notWhitelistedMessage)
                end
            end
        end
    else
        deferrals.done("No hemos encontrado tu Discord abierto, si no lo tienes ábrelo o reinicialo.")
    end
end)
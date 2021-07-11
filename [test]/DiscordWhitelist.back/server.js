//////////////////////////////////////////
// Discord Whitelist, NOT made by Astra //
//////////////////////////////////////////

/// Config Area ///

var whitelistRoles = [ // Roles by ID that are whitelisted.
    "766319019308744716"
]

var blacklistRoles = [ // Roles by Id that are blacklisted.
    "333908428995035137"
]

var notWhitelistedMessage = "No estás en la Whitelist. Este servidor es privado y necesitas estár autorizado."
var noGuildMessage = "Debes estar whitelisted en el discord de Caronte. Parece que no estás en el servidor."
var blacklistMessage = "Estás baneado de Caronte."
var debugMode = false

/// Code ///
on('playerConnecting', (name, setKickReason, deferrals) => {
    let src = global.source;
    deferrals.defer()

    setTimeout(() => {
        deferrals.update(`Bienvenido ${name}. Estamos comprobando si estás autorizando a entrar.`)

        let identifierDiscord = null;

        for (let i = 0; i < GetNumPlayerIdentifiers(src); i++) {
            const identifier = GetPlayerIdentifier(src, i);

            if (identifier.includes('discord:')) {
                identifierDiscord = identifier;
            }
        }
        setTimeout(() => {
            if(identifierDiscord) {
                exports['discordroles']['isRolePresent'](src, blacklistRoles, function(hasRole, roles) {
                    if(hasRole) {
                        deferrals.done(blacklistMessage);
                        if(debugMode) console.log(`^5[Caronte]^7 '${name}' with ID '${identifierDiscord.replace('discord:', '')}' is blacklisted to join this server.`)
                    }
                })
                exports['discordroles']['isRolePresent'](src, whitelistRoles, function(hasRole, roles) {
                    if(!roles) {
                        deferrals.done(noGuildMessage)
                        if(debugMode) console.log(`^5[Caronte]^7 '${name}' with ID '${identifierDiscord.replace('discord:', '')}' cannot be found in the assigned guild and was not granted access.`)
                    }
                    if(hasRole) {
                        deferrals.done()
                        if(debugMode) console.log(`^5[Caronte]^7 '${name}' with ID '${identifierDiscord.replace('discord:', '')}' was granted access and passed the whitelist.`)
                    } else {
                        deferrals.done(notWhitelistedMessage)
                        if(debugMode) console.log(`^5[Caronte]^7 '${name}' with ID '${identifierDiscord.replace('discord:', '')}' is not whitelisted to join this server.`)
                    }
                })
            } else {
                deferrals.done(`Discord no detectado. Asegurate de que Discord está instalado y abierto. Si necesitas ayuda puedes ir a este link - docs.faxes.zone/docs/debugging-discord`)
                if(debugMode) console.log(`^5[Caronte]^7 '${name}' no tienes rango de Whitelist en el Discord de Caronte.`)
            }
        }, 0)
    }, 0)
})
fx_version 'bodacious'
game 'gta5'

server_scripts {
    'server/main.lua',
    'config.lua'
}

client_scripts {
    'client/main.lua',
    'config.lua',
    'client/functions.lua'
}

exports {
    "SkillMenu",
    "UpdateSkill",
    "GetCurrentSkill"
}


server_exports {
    "getSkill",
    "updateSkill"
}
fx_version 'bodacious'

game "gta5"

server_script "server.lua"

client_script {
    "config.lua",
    "client.lua"
}

exports {
    "AddStress",
    "RemoveStress"
}

-- FXVersion Version
fx_version 'adamant'
games { 'gta5' }

-- Client Scripts
client_script 'client/main.lua'

-- Server Scripts
server_script 'server/main.lua'

-- NUI Default Page
ui_page "client/html/index.html"

-- Files needed for NUI
-- DON'T FORGET TO ADD THE SOUND FILES TO THIS!
files {
    'client/html/index.html',
    -- Begin Sound Files Here...
    -- client/html/sounds/ ... .ogg
    'client/html/sounds/demo.ogg',
    'client/html/sounds/melodia_triste.ogg',
    'client/html/sounds/cool_guitar.ogg',
    'client/html/sounds/nothing_else.ogg',
    'client/html/sounds/smoke_water.ogg'
}

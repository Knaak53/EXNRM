fx_version 'bodacious'
game 'gta5'

description 'ESX Garbage v1.0'

version '1.0.0'

server_scripts {
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'@es_extended/locale.lua',
  'locales/br.lua',
  'locales/en.lua',
	'config.lua',
	'client/main.lua'
}

fx_version 'bodacious' 

game 'gta5'

description 'ESX Police Job'

version '1.3.0'
ui_page 'html/index.html'
server_scripts {
	--'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'fine_types.lua',
	'locales/br.lua',
	'locales/de.lua',
	'locales/en.lua',
	'locales/es.lua',
	'locales/pl.lua',
	'locales/fr.lua',
	'locales/fi.lua',
	'locales/es.lua',
	'locales/sv.lua',
	'locales/ko.lua',
	'locales/cs.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'locales/br.lua',
	'locales/de.lua',
	'locales/en.lua',
	'locales/es.lua',
	'locales/pl.lua',
	'locales/fr.lua',
	'locales/fi.lua',
	'locales/es.lua',
	'locales/sv.lua',
	'locales/ko.lua',
	'locales/cs.lua',
	'config.lua',
	'client/main.lua',
	'client/vehicle.lua'
}

files {
	'html/index.html',
	'html/*.js'
}


dependencies {
	'extendedmode',
	'esx_society',
	'esx_billing',
	'esx_vehicleshop'
}


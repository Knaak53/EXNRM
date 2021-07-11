fx_version 'adamant'

game 'gta5'

description 'ESX Taxi Job'

version '1.0.2'

client_scripts {
	'@es_extended/locale.lua',
	'locales/en.lua',
	'config.lua',
	'client/main.lua'
}

server_scripts {
	'@es_extended/locale.lua',
	'locales/en.lua',
	'config.lua',
	'server/main.lua'
}

ui_page {
	'html/index.html'
}

files {
  "html/index.html",
  "html/styles.css",
  "html/app.js",
  "html/img/*.png",
  "html/fonts/*.ttf"
}

dependency 'extendedmode'

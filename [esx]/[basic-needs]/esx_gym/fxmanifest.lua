fx_version 'bodacious'
game 'gta5'


description 'ESX Gym'

version '0.0.2'

server_scripts {
  'server/main.lua',
}

client_scripts {
  'client/main.lua',
  
}

shared_scripts
{
	'config.lua'
}

ui_page {
	'html/index.html'
}

files {
  "html/index.html",
  "html/styles.css",
  "html/app.js",
  -- IMAGES
  "html/img/items/*.png",
  "html/img/*.png",
  "html/audio/*.mp3"
}

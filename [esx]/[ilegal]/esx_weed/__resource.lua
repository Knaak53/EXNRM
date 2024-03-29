server_scripts {
  '@async/async.lua',
  '@mysql-async/lib/MySQL.lua',
  'server.lua'
}

client_scripts {
	'client.lua',
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
  "html/img/*.png",
  "html/audio/*.mp3"
}
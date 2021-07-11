server_scripts {
  '@async/async.lua',
  '@mysql-async/lib/MySQL.lua',
  'server.lua'
}

client_scripts {
	'client.lua'
}

ui_page {
	'html/index.html'
}

files {
  "html/index.html",
  "html/styles.css",
  "html/app.js",
  -- IMAGES
  "html/fonts/*.ttf",
  "html/img/*.png",
  "html/audio/*.mp3"
}
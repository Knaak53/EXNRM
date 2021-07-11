server_scripts {
  '@async/async.lua',
  '@mysql-async/lib/MySQL.lua',
  'server/server.lua',
  'server/c_trunk.lua',
  'server/trunk.lua'
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
  "html/img/items/*.png",
  "html/img/*.png"
}
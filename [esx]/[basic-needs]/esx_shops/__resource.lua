resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

client_scripts {
    'client/main.lua',
    'client/shop.lua',
    'client/robbery.lua'
}

server_scripts {
    'server/main.lua',
    '@async/async.lua',
    '@mysql-async/lib/MySQL.lua'
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
}


shared_script 'config.lua'
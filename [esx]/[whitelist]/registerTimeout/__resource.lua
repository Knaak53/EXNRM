server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server.lua'
}
client_script {
	'client.lua'
}

ui_page {
	'html/index.html'
}

files {
  "html/index.html",
  "html/css/styles.css",
  "html/app.js"
}

dependencies {
	'es_extended'
}
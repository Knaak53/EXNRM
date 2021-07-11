fx_version 'bodacious' 
game 'gta5'
description 'TESTS'
version '1.0.1'

--resource_type 'gametype' { name = 'tests' }

server_scripts {
	'test.lua',
	'ESXTestSv.net.dll'
}

client_scripts {
	'cl_test.lua',
}	

ui_page {
	"index.html"
}

files {
	
}

exports {
	
}

server_exports {

}

--provide 

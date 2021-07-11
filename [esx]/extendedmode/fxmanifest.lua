fx_version 'bodacious'
game 'gta5'
description 'extendedmode'
version '1.0.1'

resource_type 'gametype' { name = 'extendedmode' }

server_scripts {
	--'server/metrics.lua',

	'server/config.lua',
	'server/jobs.lua',
	'server/util.lua',
	'server/db.lua',

	'locale.lua',
	'locales/*.lua',

	
	'server/items.lua',
	

	'config.lua',
	'config.weapons.lua',

	'server/classes/sData.lua',
	'server/common.lua',
	'server/classes/player.lua',
	'server/classes/vehicle.lua',
	
	'server/functions.lua',
	'server/paycheck.lua',
	'server/main.lua',
	'server/commands.lua',
	--'server/dbmigrate.lua',

	'server/actions.lua',

	'common/modules/math.lua',
	'common/modules/table.lua',
	'common/functions.lua',
	
	'server/coreItemsRegistry.lua',
	'server/utilscallbacks.lua'
}

client_scripts {
	'locale.lua',
	'locales/*.lua',
	

	'config.lua',
	'config.weapons.lua',

	
	'client/common.lua',
	'client/entityiter.lua',
	'client/functions.lua',
	'client/wrapper.lua',
	'client/main.lua',
	'client/actions.lua',
	

	

	'client/modules/death.lua',
	'client/modules/scaleform.lua',
	'client/modules/streaming.lua',

	'common/modules/math.lua',
	'common/modules/table.lua',
	'common/functions.lua',
	'client/keymapings.lua'
}

ui_page {
	'html/ui.html'
}

files {
	'locale.js',
	'html/ui.html',

	'html/css/app.css',

	'html/js/mustache.min.js',
	'html/js/wrapper.js',
	'html/js/app.js',

	'html/fonts/pdown.ttf',
	'html/fonts/bankgothic.ttf',

	'html/img/accounts/bank.png',
	'html/img/items/*.png',
	'html/img/accounts/black_money.png',
	'html/img/accounts/money.png',
	'html/sounds/*.ogg',
	'imports.lua'
}

exports {
	'getSharedObject'
}

server_exports {
	'getSharedObject',
	'CreateExtendedCar'
}

provide 'es_extended'
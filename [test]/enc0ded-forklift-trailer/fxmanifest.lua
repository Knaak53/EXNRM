fx_version 'cerulean'

game 'gta5'

shared_script {
   'config.lua',
}

client_scripts {
    'data/language.lua',
    'lib/entityiter.lua',
    'lib/_utils.lua',
    'client/job.lua',
    'client/truck.lua',
    'client/trailer.lua',
    'client/forklift.lua',
    'client/pallet.lua',
    'client/main.lua',
}

server_scripts {
  'server/main.lua'
}

files {
	'data/handling.meta'
}

data_file 'HANDLING_FILE' 'data/handling.meta'

exports {
  'SpawnPalletsWithProducts',
  'RemoveAllPallets',
  'GetAllPalletEntities',
  'GetPalletCategoryByIndex',
  'SpawnTruck',
  'SpawnTrailer',
  'SpawnForklift',
  'SpawnTruckTrailerAndForklift',
  'AttachForklift',
}

server_export 'GetProductConfigOfIndex'
server_export 'GetRandomProductOfCategory'

ESX = nil
ServerItems = {}
itemShopList = {}
TriggerEvent(
	"esx:getSharedObject",
	function(obj)
		ESX = obj
	end
)

ESX.RegisterServerCallback(
	"esx_inventoryhud:getPlayerInventory",
	function(source, cb, target)
		print("ID:"..target)
		local targetXPlayer = ESX.GetPlayerFromId(target)

		if targetXPlayer ~= nil then
			cb({inventory = targetXPlayer.getInventory(), money = targetXPlayer.getMoney(), accounts = targetXPlayer.getAccounts(), weapons = targetXPlayer.getLoadout(), weight = targetXPlayer.getWeight(), maxWeight = targetXPlayer.getMaxWeight()})
		else
			cb(nil)
		end
	end
)

ESX.RegisterServerCallback('esx_inventoryhud:get_npc_player_info',function(source, cb)
	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local john = xPlayer.get("john") 
    local daisy = xPlayer.get("daisy")
    local charles = xPlayer.get("charles")
    local callback = {}
    callback.john = {}
    callback.daisy = {}
    callback.charles = {}
   	if john then
   		callback.john.isOnQuest = john.isOnQuest
   		callback.john.currentQuestIsCompleted = john.currentQuestIsCompleted
   		callback.john.currentQuest = john.currentQuest
   	end

   	if daisy then
   		callback.daisy.isOnQuest = daisy.isOnQuest
   		callback.daisy.currentQuestIsCompleted = daisy.currentQuestIsCompleted
   		callback.daisy.currentQuest = daisy.currentQuest
   	end

   	if charles then
   		callback.charles.isOnQuest = charles.isOnQuest
   		callback.charles.currentQuestIsCompleted = charles.currentQuestIsCompleted
   		callback.charles.currentQuest = charles.currentQuest
   	end
   	cb(callback)
end)

ESX.RegisterServerCallback('esx_inventoryhud:getBasicInfo', function(source, cb)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local user = xPlayer.get("identity")
    licenseTypes = {}
    callback = {}
    TriggerEvent('esx_license:getLicenses', source, function(licenses)
		for i = 1, #licenses do
	    	licenseTypes[i] = licenses[i].type 
	    end
	end)
    
    local bossAccount
    if xPlayer.getJob().grade_name == "boss" then
    	TriggerEvent('esx_addonaccount:getSharedAccount', xPlayer.getJob().name, function(account) 		
			bossAccount = account.getMoney()
		end)
    end
    table.insert(callback, 
        {
            money = xPlayer.getMoney(),
            bank = xPlayer.getAccount("bank").money,
            blackMoney = xPlayer.getAccount("black_money").money,
            name = xPlayer.getName(),
            id = _source,
            trabajo = xPlayer.getJob().label,
            grado = xPlayer.getJob().grade_label,
            jobLvl = xPlayer.getJob().grade,
            license = licenseTypes,
            sex = user.real.sex,
            phone_number = user.phone_number,
            height = user.real.height,
            dateofbirth = user.real.dateofbirth,
            bossAccount = bossAccount,
            grade_name = xPlayer.getJob().grade_name
        }
    )
    cb(callback)
end)

--Event that disables target inventory opening while being searched
RegisterServerEvent('esx_inventoryhud:disableTargetInv')
AddEventHandler('esx_inventoryhud:disableTargetInv', function(target)
	local _source = source
	local _target = target
	TriggerClientEvent("esx_inventoryhud:disableOpen", _target)
	--TriggerClientEvent("esx_inventoryhud:disableOpenShop", _target)
	TriggerClientEvent("esx_invnetoryhud:setOpenedPlayerId", _source, _target)
end)

--Event that enables target inventory after being searched
RegisterServerEvent('esx_inventoryhud:enableTargetInv')
AddEventHandler('esx_inventoryhud:enableTargetInv', function(target)
	print('enabling open inv')
	print(target)
	TriggerClientEvent('esx_inventoryhud:enableOpen', target)
	--TriggerClientEvent('esx_inventoryhud:enableOpenShop', target)
end)
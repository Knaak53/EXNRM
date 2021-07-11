ESX = nil
ESX = exports.extendedmode:getSharedObject()

local btcAccounts
local btcAccountList = {}

ESX.RegisterServerCallback('esx_bitcoin:getBTCInfo', function(source, cb)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local haveLedger = xPlayer.getInventoryItem("ledgers").count > 0
    local playerMoney = xPlayer.getAccount('bank').money  
    local btcInfo = xPlayer.get("btcInfo")
    btcAccounts = ESX.getsData().get("btcAccounts")
    print(json.encode(btcAccounts))
    if not btcAccounts then
        btcAccounts = {}
        ESX.getsData().set("btcAccounts", btcAccounts)        
    end
    for k, v in pairs(btcAccounts) do 
    	local found = false
    	for y, z in pairs(btcAccountList) do
			if k == z then
				found = true
			end
    	end	
    	if not found then
    		table.insert(btcAccountList, k)
    	end
	end
    if not btcInfo then   
        local newBtcAccount = {}   
        local account = generateNewBtcAccount(btcAccountList)
        newBtcAccount.inversion = 0
        newBtcAccount.account = account
        xPlayer.set("btcInfo", newBtcAccount)
        newBtcAccount.haveLedger = haveLedger
        newBtcAccount.playerMoney = playerMoney   
        btcAccounts[account] = 0
        newBtcAccount.btc = 0
        table.insert(btcAccountList, account)
        ESX.getsData().set("btcAccounts", btcAccounts)
        newBtcAccount.accounts = btcAccountList
        cb(newBtcAccount)
    else
        local callback = {}
        callback.btc = btcAccounts[btcInfo.account]
        callback.inversion = btcInfo.inversion
        callback.haveLedger = haveLedger
        callback.playerMoney = playerMoney
        callback.account = btcInfo.account
        callback.accounts = btcAccountList
        cb(callback)
    end
end)

function generateNewBtcAccount(accountsList)
    local newAccount = ""
    math.randomseed(os.time())
    if math.random(1, 100) <= 50 then
        newAccount = newAccount .. "1" 
    else
        newAccount = newAccount .. "3" 
    end
    newAccount = newAccount .. RandomVariable(math.random(25, 34))
    for i = 1, #accountsList do
        if accountsList[i] == newAccount then
            newAccount = generateNewBtcAccount(accountsList)
        end
    end
    return newAccount
end

local upperCase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
local lowerCase = "abcdefghijklmnopqrstuvwxyz"
local numbers = "0123456789"

function RandomVariable(length)
    local characterSet = upperCase .. lowerCase .. numbers

    local output = ""

    for i = 1, length do
        local rand = math.random(#characterSet)
        output = output .. string.sub(characterSet, rand, rand)
    end

    return output
end

RegisterNetEvent('esx_bitcoin:buyBitcoin')
AddEventHandler('esx_bitcoin:buyBitcoin', function(btc, price, btcPrice)
	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local btcInfo = xPlayer.get("btcInfo")
    btcAccounts[btcInfo.account] = btc
    ESX.getsData().set("btcAccounts", btcAccounts)
    btcInfo.inversion = price
    xPlayer.set("btcInfo", btcInfo)
    xPlayer.removeAccountMoney('bank', btcPrice)
end)

function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end

RegisterNetEvent('esx_bitcoin:sendBitcoin')
AddEventHandler('esx_bitcoin:sendBitcoin', function(btc, price, sentBTC, targetAccount)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local btcInfo = xPlayer.get("btcInfo")
    btcInfo.inversion = price
    if btcAccounts[btcInfo.account] then
        btcAccounts[btcInfo.account] = btc
    end
    if btcAccounts[targetAccount] then
        btcAccounts[targetAccount] = round(btcAccounts[targetAccount] + sentBTC, 8)
    end
    xPlayer.set("btcInfo", btcInfo)
    ESX.getsData().set("btcAccounts", btcAccounts)
end)

RegisterNetEvent('esx_bitcoin:sellBitcoin')
AddEventHandler('esx_bitcoin:sellBitcoin', function(btc, price, btcPrice)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local btcInfo = xPlayer.get("btcInfo")
    btcInfo.inversion = price
    btcAccounts = ESX.getsData().get("btcAccounts")
    if btcAccounts[btcInfo.account] then
        btcAccounts[btcInfo.account] = btc
        xPlayer.set("btcInfo", btcInfo)
        ESX.getsData().set("btcAccounts", btcAccounts)
        xPlayer.addAccountMoney('bank', btcPrice)
    end
end)
function CreateAddonAccount(name, owner, money)
    local self = {}
    local functions = {}
    self.name = name
    self.owner = owner
    self.money = money
    self.savingState = false

    functions.getAddonAccount = function()
        return self
    end

    functions.setAddonAccount = function(se)
        self = se
    end

    functions.addMoney = function(m)
        self.money = self.money + m
        functions.save()

        --TriggerClientEvent("esx_addonaccount:setMoney", -1, self.name, self.money)
    end

    functions.removeMoney = function(m)
        self.money = self.money - m
        functions.save()

        --TriggerClientEvent("esx_addonaccount:setMoney", -1, self.name, self.money)
    end

    functions.setMoney = function(m)
        self.money = m
        functions.save()

        --TriggerClientEvent("esx_addonaccount:setMoney", -1, self.name, self.money)
    end

    functions.getMoney = function(m)
        return self.money
    end

    functions.getName = function()
        return self.name
    end

    functions.save = function()
        if self.owner == nil then
            --local auxTable = {}
            --auxTable[self.name] = {
            --	name = self.name,
            --	money = self.money
            --}
            --ESX.exposedDB.updateDocument('essentialmode', GetHashKey("addon_accounts"),
            --	{
            --		data =
            --		{
            --			name = self.name,
            --			money = self.money
            --		}
            --	}
            --, function(result)
            --	if not result then
            --		print("^8Fatal Error in addon accounts self saving, unable to save the account: "..self.name)
            --	end
            --end)
            --MySQL.Async.execute('UPDATE addon_account_data SET money = @money WHERE account_name = @account_name', {
            --	['@account_name'] = self.name,
            --	['@money']        = self.money
            --})
            --cached_doc[self.name]["data"]["money"] = self.money
            

        else
            --MySQL.Async.execute('UPDATE addon_account_data SET money = @money WHERE account_name = @account_name AND owner = @owner', {
            --	['@account_name'] = self.name,
            --	['@money']        = self.money,
            --	['@owner']        = self.owner
            --})
            if not self.savingState then
                self.savingState = true

                Citizen.SetTimeout(
                    120000,
                    function()
                        local annonTable = {}
                        print("hash: " .. GetHashKey("addon_account_"..self.owner))
                        for k, v in pairs(Accounts[self.owner]) do
                            annonTable[k] = {
                                name = v.name,
                                money = v.money
                            }
                        end

                        ESX.exposedDB.updateDocument(
                            GetHashKey("addon_account_"..self.owner),
                            {
                                addon_accounts = annonTable
                            },
                            function(result)
                                print("hash: " .. GetHashKey("addon_account_"..self.owner))
                                self.savingState = false
                                if not result then
                                    print(
                                        "^8Fatal Error in addon accounts self saving, unable to save the account: " ..
                                            " from player: " .. self.owner
                                    )
                                end
                            end
                        )
                    end
                )
            end
        end
    end

    return functions
end

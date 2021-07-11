
function CreateAddonInventory(name, owner, items)
    local self = {}
    local functions = {}
    self.name = name
    self.owner = owner
    self.items = items
    self.savingState = false

    functions.getName = function()
        return self.name
    end

    functions.getItems = function()
        return self.items
    end

    functions.getAddonInventory = function()
        return self
    end

    functions.setAddonInventory = function(inv)
        self = inv
    end

    functions.addItem = function(name, count)
        if self.items[name] == nil then
            print(json.encode(ESX.Items))
            self.items[name] = 
            {
                name = name,
                count = 0,
                label = ESX.getItems()[name].label
            }
        end

        local item = functions.getItem(name)
        item.count = item.count + count
        
        functions.saveItem(name, item.count)
    end

    functions.removeItem = function(name, count)
        local item = functions.getItem(name)
        item.count = item.count - count

        functions.saveItem(item)
    end

    functions.setItem = function(name, count)
        local item = functions.getItem(name)
        item.count = count

        functions.saveItem(item)
    end

    functions.getItem = function(name)
        if self.items[name] ~= nil then
            return self.items[name]
        end

        local item = {
            name = name,
            count = 0,
            label = ESX.getItems()[name].label
        }

        return item


        --table.insert(self.items, item)

        --if self.owner == nil then
        --	--MySQL.Async.execute('INSERT INTO addon_inventory_items (inventory_name, name, count) VALUES (@inventory_name, @item_name, @count)',
        --	--{
        --	--	['@inventory_name'] = self.name,
        --	--	['@item_name']      = name,
        --	--	['@count']          = 0
        --	--})
        --else
        --	MySQL.Async.execute('INSERT INTO addon_inventory_items (inventory_name, name, count, owner) VALUES (@inventory_name, @item_name, @count, @owner)',
        --	{
        --		['@inventory_name'] = self.name,
        --		['@item_name']      = name,
        --		['@count']          = 0,
        --		['@owner']          = self.owner
        --	})
        --end

        --return item
    end

    functions.saveItem = function(item)
        if self.owner == nil then
            --table.insert(self.items, item)
            -- --cached_doc[self.name]["items"]
            --MySQL.Async.execute(
            --    "UPDATE addon_inventory_items SET count = @count WHERE inventory_name = @inventory_name AND name = @item_name",
            --    {
            --        ["@inventory_name"] = self.name,
            --        ["@item_name"] = name,
            --        ["@count"] = count
            --    }
            --)
        else
            if not self.savingState then
                self.savingState = true
                Citizen.SetTimeout(
                    120000,
                    function()
                        local annonTable = {}
                        print("hash: " .. GetHashKey("addon_inventories_" .. self.owner))
                        for k, v in pairs(Inventories[self.owner]) do
                            annonTable[v.getName()] = {
                                name = v.getName(),
                                items = v.getItems()
                            }
                        end

                        ESX.exposedDB.updateDocument(
                            GetHashKey("addon_inventories_" .. self.owner),
                            {
                                addon_inventories = annonTable
                            },
                            function(result)
                                print("hash: " .. GetHashKey("addon_account_" .. self.owner))
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
            --MySQL.Async.execute(
            --    "UPDATE addon_inventory_items SET count = @count WHERE inventory_name = @inventory_name AND name = @item_name AND owner = @owner",
            --    {
            --        ["@inventory_name"] = self.name,
            --        ["@item_name"] = name,
            --        ["@count"] = count,
            --        ["@owner"] = self.owner
            --    }
            --)
        end
    end

    return functions
end

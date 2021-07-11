


function deepcompare(t1, t2, ignore_mt)
    local ty1 = type(t1)
    local ty2 = type(t2)
    if ty1 ~= ty2 then
        return false
    end
    -- non-table types can be directly compared
    if ty1 ~= "table" and ty2 ~= "table" then
        return t1 == t2
    end
    -- as well as tables which have the metamethod __eq
    local mt = getmetatable(t1)
    if not ignore_mt and mt and mt.__eq then
        return t1 == t2
    end
    for k1, v1 in pairs(t1) do
        local v2 = t2[k1]
        if v2 == nil or not deepcompare(v1, v2) then
            return false
        end
    end
    for k2, v2 in pairs(t2) do
        local v1 = t1[k2]
        if v1 == nil or not deepcompare(v1, v2) then
            return false
        end
    end
    return true
end

local quantified = 0
function deepQuantifiedcompare(t1, t2, ignore_mt)
    ProfilerEnterScope("compare")
    local ty1 = type(t1)
    local ty2 = type(t2)
    if ty1 ~= ty2 then
        return false
    end
    -- non-table types can be directly compared
    if ty1 ~= "table" and ty2 ~= "table" then
        return t1 == t2
    end
    -- as well as tables which have the metamethod __eq
    local mt = getmetatable(t1)
    if not ignore_mt and mt and mt.__eq then
        return t1 == t2
    end
    for k1, v1 in pairs(t1) do
        local v2 = t2[k1]
        if v2 == nil or not deepcompare(v1, v2) then
            quantified = quantified + 1
        end
    end
    for k2, v2 in pairs(t2) do
        local v1 = t1[k2]
        if v1 == nil or not deepcompare(v1, v2) then
            quantified = quantified + 1
        end
    end
    local valueToReturn = quantified
    quantified = 0
    return valueToReturn
end


local table1 = 
{
    itsover = 
    {
        name = "super",
        value = 9001
    },
    krillin = 
    {
        name = "lowfighter",
        value = 10,
        action = "BUM"
    }
}

local table2 = 
{
    itsover = 
    {
        name = "grandfather",
        value = -9000
    },
    krillin = 
    {
        name = "lowfighter",
        value = 10,
        action = "BUM"
    }
}

RegisterCommand("pruebacompare", function()
    local quantity = deepQuantifiedcompare(table1,table2,true)
    print("The tables are "..quantity.." points diferents")
end, false)

RegisterCommand("pruebacomparepollo", function()
    local annonTable = {}
    print("hash: "..GetHashKey("addon_account_steam:110000104df7a7b"))
    for k,v in pairs(Accounts["steam:110000104df7a7b"]) do
        annonTable[k] = 
        {
            name = v.name,
            money = v.money
        }
    end
    annonTable["playerExample"] = 
    {
        name = "playerExample",
        money = 999999
    }
    
    ESX.exposedDB.updateDocument(GetHashKey("addon_account_steam:110000104df7a7b"),
        {
            addon_accounts = annonTable
        }
    , function(result) 
        print("hash: "..GetHashKey("addon_account_steam:110000104df7a7b"))
        if not result then
            print("^8Fatal Error in addon accounts self saving, unable to save the account: ".. " from player: ".."steam:110000104df7a7b")
        end
    end)
end, false)

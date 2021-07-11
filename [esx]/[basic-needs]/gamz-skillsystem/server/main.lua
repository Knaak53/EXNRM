local ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
	ESX = obj 
end)


function getSkill(source, skillName)
     print("source: "..source)
     print("name: "..skillName)
     local xPlayer = ESX.GetPlayerFromId(source)
     local skills = xPlayer.get("skills")
     if skills[skillName] then
          return skills[skillName]
     end
end


ESX.RegisterServerCallback("gamz-skillsystem:fetchStatus", function(source, cb)
     local src = source
     local xPlayer = ESX.GetPlayerFromId(src)

     --[[
     local fetch = [[
               SELECT
                    skills
               FROM
                    users
               WHERE
                    identifier = @identifier
          ]]
     

     --[[MySQL.Async.fetchScalar(fetch, {
          ["@identifier"] = user.identifier

     }, function(status)
          local decodeResult = json.decode(status)
          if status ~= nil then
               user.setMaxWeight(15 + (15 * (decodeResult["Fuerza"].Current / 100)))
               cb(decodeResult)
          else
               cb(nil)
          end
     
     end)]]
     local status = xPlayer.get("skills")
     --print(json.encode(status))
     if status then
          xPlayer.setMaxWeight(15 + (15 * (status.Fuerza.Current / 100)))
          cb(status)
     else
          cb(nil)
     end
end)

function updateSkill(source, skillName,skill)
     local xPlayer = ESX.GetPlayerFromId(source)
     local skills = xPlayer.get("skills")
     if skills[skillName] then
          skills[skillName] = skill
          xPlayer.set("skills", skills)
          return true
     end
     return false
end

RegisterServerEvent("gamz-skillsystem:update")
AddEventHandler("gamz-skillsystem:update", function(data)
     local src = source
     local xPlayer = ESX.GetPlayerFromId(src)
     xPlayer.setMaxWeight(15 + (15 * (data.Fuerza.Current / 100)))
     --[[local insert = [[
          UPDATE
               users
          SET
               skills = @skills
          WHERE
               identifier = @identifier
     ]]

    --[[MySQL.Async.execute(insert, {
          ["@skills"] = data,
          ["@identifier"] = user.identifier
     })]]--
     xPlayer.set("skills", data)
end)

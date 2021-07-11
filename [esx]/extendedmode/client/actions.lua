ESX.Actions = {}

ESX.Actions.takeObject = function(entity, hand, createModelFromModel)
   local ped = PlayerPedId()
   local bonecords 
   local boneindex
	if hand then
      boneindex = GetPedBoneIndex(ped ,hand)
      bonecords = GetPedBoneCoords(ped, hand, 0, 0, 0)
	else
      boneindex = GetPedBoneIndex(ped ,28422)
      bonecords = GetPedBoneCoords(ped, 28422, 0, 0, 0)
   end
  
   ExM.Game.PlayAnim("mp_common", "givetake1_a", 51, 3000)
   Citizen.Wait(1000)

   if not createModelFromModel then
      createModelFromModel = "prop_money_bag_01"
   end
   if createModelFromModel ~= nil and entity == nil then
      if IsWeaponValid(GetHashKey(createModelFromModel)) then
         entity = CreateWeaponObject(createModelFromModel, 50, bonecords, true, 1.0, 0)
      else
         entity = CreateObject(GetHashKey(createModelFromModel) --[[ Object ]], bonecords, true --[[ boolean ]], true --[[ boolean ]], true --[[ boolean ]])
      end
   end
   Citizen.Wait(10)
	AttachEntityToEntity(entity, ped, boneindex, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
	Citizen.Wait(1000)
	DeleteObject(entity)
end

ESX.Actions.giveObject = function(entity, hand, createModelFromModel)
   local ped = GetPlayerPed(-1)
   local ped2 = PlayerPedId()
   print("ped Get: "..ped)
   print("ped Id: "..ped2)
   local bonecords 
   local boneindex
   print(hand)
	if hand ~= nil and hand then
      boneindex = GetPedBoneIndex(ped ,hand)
      bonecords = GetPedBoneCoords(ped, hand, 0.0,0.0,0.0)
	else
      boneindex = GetPedBoneIndex(ped ,28422)
      bonecords = GetPedBoneCoords(ped, 28422, 0.0,0.0,0.0)
   end
  
   ExM.Game.PlayAnim("mp_common", "givetake1_a", 51, 3000)

   if not createModelFromModel then
      createModelFromModel = "prop_money_bag_01"
   end
   if createModelFromModel ~= nil and (entity == nil or not entity) then
      print("por aqui")
      if IsWeaponValid(GetHashKey(createModelFromModel)) then
         entity = CreateWeaponObject(createModelFromModel, 50, bonecords, true, 1.0, 0)
      else
         print("por aquua")
         ESX.Streaming.RequestModel(createModelFromModel ,function()
            print("caargao")
            entity = CreateObject(GetHashKey(createModelFromModel) --[[ Object ]], bonecords.x,bonecords.y,bonecords.z, true --[[ boolean ]], true --[[ boolean ]], true --[[ boolean ]])
         end)
         
      end
   end
   Citizen.Wait(10)
   print(boneindex)
   local cords = GetPedBoneCoords(ped, 28422, 0, 0, 0)
	AttachEntityToEntity(entity, ped, boneindex, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 0, 2, 1)
	Citizen.Wait(1000)
	DeleteObject(entity)
end

ESX.Actions.giveObjectSynced  = function(entityModel, targetId, hand)
   local target = targetId
   if entityModel ~= nil then
      entityModel = entityModel
   else
      entityModel = 'prop_money_bag_01'
   end
	TriggerServerEvent("Actions:SyncedAction","GiveObject","TakeObject",entityModel, target, hand)
end

ESX.Actions.FastCall  = function()
   local ped = GetPlayerPed(-1)
   local ped2 = PlayerPedId()
   RequestModel('prop_amb_phone')
	while not HasModelLoaded('prop_amb_phone') do
		Citizen.Wait(1)
	end
   
   local bonecoords = GetPedBoneCoords(ped, 28422, 0.0,0.0,0.0)
   local phoneProp = CreateObject(GetHashKey('prop_amb_phone'), bonecoords.x,bonecoords.y,bonecoords.z, 1, 1, 0)
	local bone = GetPedBoneIndex(ped, 28422)
	AttachEntityToEntity(phoneProp, ped, bone, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 0, 2, 1)
   ExM.Game.PlayAnim("cellphone@", "cellphone_text_in", true, 1500)
   Wait(1500)
   ExM.Game.PlayAnim("cellphone@", "cellphone_call_listen_base", true, 3000)
   Wait(3000)
   ExM.Game.PlayAnim("cellphone@", "cellphone_call_out", true, 1500)
   DeleteObject(phoneProp)
end

RegisterNetEvent("Actions:GiveObject")
AddEventHandler("Actions:GiveObject", function(entityModel, hand)
   ESX.Actions.giveObject(nil, nil, entityModel)
end)

RegisterNetEvent("Actions:TakeObject")
AddEventHandler("Actions:TakeObject", function(entityModel, hand)
   print("synced recieved")
   ESX.Actions.takeObject(nil, nil, entityModel)
end)

RegisterCommand("testActionGive", function()
   ESX.Actions.giveObject(nil, nil, "prop_money_bag_01")
end, false)

RegisterCommand("testActionFastCall", function()
   ESX.Actions.FastCall()
end, false)



-- create and use an Actions
--acc = Actions:create(1000)
--acc:withdraw(100)
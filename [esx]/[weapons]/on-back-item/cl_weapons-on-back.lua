-- this script puts certain large weapons on a player's back when it is not currently selected but still in there weapon wheel
-- by: minipunch
-- originally made for USA Realism RP (https://usarrp.net)

local SETTINGS = {
    back_bone = 24816,
    x = 0.275,
    y = -0.155,
    z = 0.01,
    x_rotation = 0.0,
    y_rotation = 165.0,
    z_rotation = 0.0,
    compatable_weapon_hashes = {
      -- melee:
      --["prop_golf_iron_01"] = 1141786504, -- positioning still needs work
      ["w_me_bat"] = -1786099057,
      ["prop_ld_jerrycan_01"] = 883325847,
      -- assault rifles:
      ["w_ar_carbinerifle"] = -2084633992,
      ["w_ar_carbineriflemk2"] = GetHashKey("WEAPON_CARBINERIFLE_Mk2"),
      ["w_ar_assaultrifle"] = -1074790547,
      ["w_ar_specialcarbine"] = -1063057011,
      ["w_ar_bullpuprifle"] = 2132975508,
      ["w_ar_advancedrifle"] = -1357824103,
      -- sub machine guns:
      ["w_sb_microsmg"] = 324215364,
      ["w_sb_assaultsmg"] = -270015777,
      ["w_sb_smg"] = 736523883,
      ["w_sb_smgmk2"] = GetHashKey("WEAPON_SMGMk2"),
      ["w_sb_gusenberg"] = 1627465347,
      -- sniper rifles:
      ["w_sr_sniperrifle"] = 100416529,
      -- shotguns:
      ["w_sg_assaultshotgun"] = -494615257,
    


      ["w_sg_bullpupshotgun"] = -1654528753,
      ["w_sg_pumpshotgun"] = 487013001,
      ["w_ar_musket"] = -1466123874,
      ["w_sg_heavyshotgun"] = GetHashKey("WEAPON_HEAVYSHOTGUN"),
      -- launchers:
      ["w_lr_firework"] = 2138347493,
      --pistol
      ["w_pi_pistol"] = 453432689,
      ["w_pi_heavypistol"] = -771403250,
      ["w_pi_pistol50"] = -1716589765,
      ["w_pi_vintage_pistol"] = 137902532
      
      



    }
}



------------------


local attached_weapons = {}

Citizen.CreateThread(function()
  while true do
      local me = GetPlayerPed(-1)
      ---------------------------------------
      -- attach if player has large weapon --
      ---------------------------------------

      for wep_name, wep_hash in pairs(SETTINGS.compatable_weapon_hashes) do
        local v = SETTINGS
          if HasPedGotWeapon(me, wep_hash, false) then
              if not attached_weapons[wep_name] then
   
                  AttachWeapon(wep_name, wep_hash, v.back_bone, v.x, v.y, v.z, v.x_rotation, v.y_rotation, v.z_rotation, isMeleeWeapon(wep_name))
                  
              end
          end
      end
   
  
  Citizen.Wait(800)
  end
end)


Citizen.CreateThread(function()
  while true do
      local me = GetPlayerPed(-1)

      --------------------------------------------
      -- remove from back if equipped / dropped --
      --------------------------------------------
      
      for name, attached_object in pairs(attached_weapons) do
          -- equipped? delete it from back:
          if GetSelectedPedWeapon(me) ==  attached_object.hash or not HasPedGotWeapon(me, attached_object.hash, false) then -- equipped or not in weapon wheel
            DeleteObject(attached_object.handle)
            attached_weapons[name] = nil
          end
      end
  Citizen.Wait(800)
  end
end)



function AttachWeapon(attachModel,modelHash,boneNumber,x,y,z,xR,yR,zR, isMelee)
	local bone = GetPedBoneIndex(GetPlayerPed(-1), boneNumber)
	RequestModel(attachModel)
	while not HasModelLoaded(attachModel) do
		Wait(100)
	end

  attached_weapons[attachModel] = {
    hash = modelHash,
    handle = CreateObject(GetHashKey(attachModel), 1.0, 1.0, 1.0, true, true, false)
  }

  if isMelee then x = 0.11 y = -0.14 z = 0.0 xR = -75.0 yR = 185.0 zR = 92.0 end -- reposition for melee items
  if attachModel == "prop_ld_jerrycan_01" then x = x + 0.3 y = y - 0.02 end
  if attachModel == "w_pi_pistol" then  x = -0.15 y = -0.02 z = -0.2 xR = 90.0 yR = 165.0 zR = 30.0 end
  if attachModel == "w_pi_heavypistol" then   x = -0.15 y = -0.02 z = -0.2 xR = 90.0 yR = 165.0 zR = 30.0 end
  if attachModel == "w_pi_pistol50" then   x = -0.15 y = -0.02 z = -0.2 xR = 90.0 yR = 165.0 zR = 30.0 end
  if attachModel == "w_pi_vintage_pistol" then   x = -0.15 y = -0.02 z = -0.2 xR = 90.0 yR = 165.0 zR = 30.0 end
 




	AttachEntityToEntity(attached_weapons[attachModel].handle, GetPlayerPed(-1), bone, x, y, z, xR, yR, zR, 1, 1, 0, 0, 2, 1)
 


end

function isMeleeWeapon(wep_name)
    if wep_name == "prop_golf_iron_01" then
        return true
    elseif wep_name == "w_me_bat" then
        return true
    elseif wep_name == "prop_ld_jerrycan_01" then
      return true
    else
        return false
    end
end

AddEventHandler("entityCreating", function(entity) 
    if GetEntityType(entity) == 2 then
        local type = GetEntityPopulationType(entity --[[ Entity ]])
        if type == 5 or type == 2 then
            local coords = GetEntityCoords(entity)
            local model = GetEntityModel(entity)
            if model == GetHashKey("Blimp") or model == GetHashKey("Blimp2") then
                CancelEvent()
            end

            for _,v in pairs(spawnsVehDeny) do
                if math.abs(#(vector3(v.x,v.y, v.z) - coords )) <= v.distance then
                    CancelEvent()
                end
            end
        end
    end
end)
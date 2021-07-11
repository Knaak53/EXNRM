Pallet = {
    entity,
    productEntity,
    productType,
    entities = {},
    broken = false,
}
function Pallet:initiate(entity)
    if not entity or self.entity == entity then return end
    self.entity = entity
    self.productEntity = NetworkGetEntityFromNetworkId(DecorGetInt(entity, 'product_attached'))
    self.productType = DecorGetInt(entity, 'product_type')
    self.netId = ObjToNet(self.entity)
    local product = Config.productTypes[self.productType]
    local coords = nil
    local broken = false

    Utils.takeControlOfEntity(entity)
    DetachEntity(entity)
    SetActivateObjectPhysicsAsSoonAsItIsUnfrozen(entity, true)
    FreezeEntityPosition(entity, false)
    SetEntityCollision(entity, true, true)
    
    -- if status is 0, it hasn't yet been picked up
    if DecorGetInt(entity, 'pallet_status') == 0 then
        TriggerEvent('enc0ded-forklift-trailer/picked-up-pallet', self)
    end

    --fix for invisible collision object on truck
    if Truck.lastVehicleEntity > 0 then
        SetEntityNoCollisionEntity(Truck.lastVehicleEntity, self.entity, false)
    end
    
    local previousZ, _, ground
    Citizen.CreateThread(function()
        while self.entity == entity do
            Wait(1000)
            coords = GetEntityCoords(entity)
            if previousZ ~= coords.z then
                previousZ = coords.z
                _, ground = GetGroundZFor_3dCoord(coords.x, coords.y, coords.z, 0)
                if coords.z <= (ground + 0.05) then
                    Wait(250)
                    previousZ = coords.z
                    TriggerEvent('enc0ded-forklift-trailer/put-down-pallet', self)
                    TriggerServerEvent('enc0ded-forklift-trailer/put-down-pallet', self)
                end
            end

            if DecorGetInt(entity, 'pallet_status', 3) == 2 then
                self:clear()
            end
        end
    end)

    Citizen.CreateThread(function ()
        while self.entity == entity do
            broken = false

            coords = GetEntityCoords(entity) -- updating coords for both threads
            DrawMarker(0, coords.x, coords.y, coords.z + 2.9, 0, 0, 0, 0, 0, 0, 0.5, 0.5, 0.5, 55, 55, 255, 185, 0, 0, 0, 0)

            -- stop product detaching from pallet
            if GetEntityAttachedTo(self.productEntity) == 0 then
                Utils.takeControlOfEntity(self.entity)
                Utils.takeControlOfEntity(self.productEntity)
                AttachEntityToEntity(self.productEntity, self.entity, 0, 0.0 + (product.offset.x or 0), 0.0 + (product.offset.y or 0), 0.00 + (product.offset.z or 0), 0.0, 0.0, 0.0, false, false, false, true, 1, true)
                SetEntityCollision(self.productEntity, true, false)
                SetEntityNoCollisionEntity(self.entity, self.productEntity, false)
            end

            -- detach and mark as broken if pitch or roll is over x
            if math.abs(GetEntityPitch(self.entity)) > Config.maxPitchOrRoll or  math.abs(GetEntityRoll(self.entity)) > Config.maxPitchOrRoll then
                --GetEntityHealth(self.productEntity) -- maybe incorporate this at some time, now we have collison on products
                DetachEntity(self.productEntity)
                FreezeEntityPosition(self.productEntity, false)
                FreezeEntityPosition(self.entity, false)
                SetEntityCollision(self.entity, true, true)
                SetEntityCollision(self.productEntity, true, true)
                DecorSetInt(self.entity, 'pallet_status', 3)
                DecorSetInt(self.entity, 'product_attached', 0)
                
                local productEntity = self.productEntity
                Citizen.SetTimeout(5000, function ()
                    DeleteEntity(productEntity)
                    DeleteEntity(entity)
                end)
                TriggerEvent('enc0ded-forklift-trailer/broken-pallet', entity)
                broken = true
                self:clear()
            end
            Wait(5)
        end -- end while
      
        if not broken then
         --[[    SetEntityCoords(entity, coords.x, coords.y, ground, 0, 0, 0, 0)
            FreezeEntityPosition(entity, true) ]]
        end

    end)
end

function Pallet:clear()
    self.entity = nil
    self.productEntity = nil
    self.productType = nil
end

function Pallet:spawnRow(num, kind, coords, offsets, owner)
    local productType = Pallet.decideProductIndex(kind)
    local pallets = {}
    for i = 1, num do
        pallets[#pallets+1] = self:spawnOne(i, productType, coords, offsets, owner)
    end

    return pallets
end

function Pallet:spawnOne(index, productTypeIndex, coords, offsets, owner)
    local product = Config.productTypes[productTypeIndex]

    Utils.SpawnObject(Config.palletModel, coords, function(palletObject)
        SetEntityHeading(palletObject,  coords.h)
        Utils.SpawnObject(product.model, coords, function(productObject)
            local offsetCoords = GetOffsetFromEntityInWorldCoords(palletObject, index*(offsets.x or 0),  index*(offsets.y or 0), 0.0)
            local _, ground = GetGroundZFor_3dCoord(offsetCoords.x, offsetCoords.y, offsetCoords.z, 0)
            SetEntityCoords(palletObject, offsetCoords.x, offsetCoords.y, ground, 0.0, 0.0, 0.0, false )
            AttachEntityToEntity(productObject, palletObject, 0, 0.0 + (product.offset.x or 0), 0.0 + (product.offset.y or 0), 0.00 + (product.offset.z or 0), 0.0, 0.0, 0.0, 1, 0, 0, 1, 0, 1)
            SetEntityCollision(productObject, true, false)
            SetEntityNoCollisionEntity(palletObject, productObject, false)
            FreezeEntityPosition(palletObject, true)
            DecorSetInt(palletObject, 'pallet_netid', ObjToNet(palletObject))
            DecorSetInt(palletObject, 'product_attached', ObjToNet(productObject))
            DecorSetInt(palletObject, 'product_type', productTypeIndex)
            DecorSetInt(palletObject, 'pallet_owner', owner)
            self.entities[#self.entities+1] = palletObject
        end)
    end)
end

function Pallet:removeAll() 
    for i = 1, #self.entities do
        local productNetId = DecorGetInt(self.entities[i], 'product_attached')
        local product = NetworkGetEntityFromNetworkId(productNetId)
        if product > 0 then
            Utils.takeControlOfEntity(product)
            DeleteEntity(product)
        end
        Utils.takeControlOfEntity(self.entities[i])
        DeleteEntity(self.entities[i])
    end
    self.entities = {}
end

-- accept any entity and return a "palletModel" object that's within its range
Pallet.isInFrontOfEntity = function(entity)
    local plyCoords = GetEntityCoords(entity, false)
    local plyOffset = GetOffsetFromEntityInWorldCoords(entity, 0.0, 2.5, -0.8)
    local rayHandle = StartShapeTestCapsule(plyCoords.x, plyCoords.y, plyCoords.z, plyOffset.x, plyOffset.y, plyOffset.z, 1.0, 16, entity, 7)
    local _, _, _, _, result = GetShapeTestResult(rayHandle)
    -- DrawLine(plyCoords.x, plyCoords.y, plyCoords.z, plyOffset.x, plyOffset.y, plyOffset.z, 255, 0, 0, 255)
    if GetEntityModel(result) == GetHashKey(Config.palletModel) then
        return result
    end
    return nil
end

-- accept a kind of product and return specific product index id
Pallet.decideProductIndex = function (kind)
    if not tonumber(kind) then
        local thisKind = {}
        for i = 1, #Config.productTypes do
            if kind == Config.productTypes[i].category  then
                thisKind[#thisKind+1] = i
            end
        end
        if #thisKind > 0 then
            return thisKind[math.random(1, #thisKind)]
        end
    end
    return tonumber(kind) or 1
end

AddEventHandler("onResourceStop", function(resource)
    if resource ~= GetCurrentResourceName() then return end
    Pallet:removeAll()
end)

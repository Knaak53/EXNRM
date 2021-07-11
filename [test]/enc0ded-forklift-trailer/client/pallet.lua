Pallet = {
    entity,
    productType,
    productKey,
    localProducts = {},
    entities = {}
}

function Pallet:initiate(entity)
    if not entity or self.entity == entity then return end
    self.entity = entity
    self.productType = DecorGetInt(entity, 'product_type')
    self.netId = ObjToNet(self.entity)
    self.productKey = tostring(self.netId)
    local product = Config.productTypes[self.productType]
    local coords

    Utils.takeControlOfEntity(entity)
    DetachEntity(entity)
    SetActivateObjectPhysicsAsSoonAsItIsUnfrozen(entity, true)
    FreezeEntityPosition(entity, false)
    SetEntityCollision(entity, true, true)

    -- if status is 0, it hasn't yet been picked up
    if DecorGetInt(entity, 'pallet_status') == 0 then
        TriggerEvent('enc0ded-forklift-trailer/picked-up-pallet', self)
    end

    -- bug fix for invisible collision object on back of truck
    local attachedTruck, hasDriver = Trailer:getAttachedTruck(false)
    local truck = attachedTruck or Truck.lastVehicleEntity
    if truck then
        SetEntityNoCollisionEntity(truck, Pallet.localProducts[self.productKey], false)
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
                end
            end

            if DecorGetInt(entity, 'pallet_status', 3) == 2 then
                self:clear()
            end

            -- detach and mark as broken if pitch or roll is over x
            if math.abs(GetEntityPitch(self.entity)) > Config.maxPitchOrRoll or math.abs(GetEntityRoll(self.entity)) > Config.maxPitchOrRoll then
                --GetEntityHealth(self.productEntity) -- maybe incorporate this at some time, now we have collison on products
                FreezeEntityPosition(self.entity, false)
                SetEntityCollision(self.entity, true, true)
                local productEntity = self.localProducts[self.productKey]
                DecorSetInt(self.entity, 'pallet_status', 3)
                DetachEntity(productEntity)
                Citizen.SetTimeout(5000, function ()
                    DeleteEntity(entity)
                end)
                TriggerEvent('enc0ded-forklift-trailer/broken-pallet', entity)
                self:clear()
            end
        end
    end)

    Citizen.CreateThread(function ()
        while self.entity == entity do
            Wait(5)
            coords = GetEntityCoords(entity) -- updating coords for both threads
            DrawMarker(0, coords.x, coords.y, coords.z + 2.9, 0, 0, 0, 0, 0, 0, 0.5, 0.5, 0.5, 55, 55, 255, 185, 0, 0, 0, 0)
        end
    end)
end

function Pallet:clear()
    self.entity = nil
    self.productType = nil
end

function Pallet:spawnRow(num, kind, coords, spacing, owner)
    local productIndex = Pallet.decideProductIndex(kind)
    local product = Config.productTypes[productIndex]

    local pallets = {}

    if product.spacing then
        spacing.x = product.spacing.x or spacing.x
        spacing.y = product.spacing.y or spacing.y
    end

    if product.max then
        num = product.max
    end

    for i = 0, num-1 do
        self:spawnOne(i, product, productIndex, coords, spacing, owner, function ( palletObject )
          pallets[#pallets+1] = pallet
        end)
        Wait(200)
    end
    return pallets
end

function Pallet:spawnOne(index, product, productIndex, coords, spacing, owner, callback)

    Utils.SpawnObject(Config.palletModel, coords, function(palletObject)
        -- if pallet doesn't have a valid net id we will keep attempting to spawn it until one does
        if palletObject == false then
          Wait(1000)
          Pallet:spawnOne(index, productIndex, coords, spacing, owner)
       else
        local palletNetId = ObjToNet(palletObject)
        local offsetCoords = GetOffsetFromEntityInWorldCoords(palletObject, index*(spacing.x or 0),  index*(spacing.y or 0), 0.0)
        local _, ground = GetGroundZFor_3dCoord(offsetCoords.x, offsetCoords.y, offsetCoords.z, 0)
        SetEntityVisible(palletObject, true)
        SetEntityCollision(palletObject, true, true)
        SetEntityCoords(palletObject, offsetCoords.x, offsetCoords.y, ground, 0.0, 0.0, 0.0, false )
        FreezeEntityPosition(palletObject, true)
        DecorSetInt(palletObject, 'product_type', productIndex)
        DecorSetInt(palletObject, 'pallet_owner', owner)

--[[         -- we'll check if local product exists just incase local product spawner beat us to it
        if self.localProducts[tostring(palletNetId)] == nil then
            Utils.SpawnObject(product.model, coords, function(productObject)
                AttachProductToPallet(palletObject, productObject, product)
                SetEntityVisible(productObject, true)
                SetEntityCollision(productObject, true, true)
                self.localProducts[tostring(palletNetId)] = productObject
            end, false, true)
        end ]]
        self.entities[#self.entities+1] = palletObject

        callback(palletObject)
       end

    end, true, true)
end

function Pallet:removeAll() 
    for i = 1, #self.entities do
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
            math.randomseed(GetGameTimer())
            return thisKind[math.random(1, #thisKind)]
        end
    end
    return tonumber(kind) or 1
end


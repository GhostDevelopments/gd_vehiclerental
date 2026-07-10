local rentalPed = nil

-- Initialize NPC, Target and Blip
CreateThread(function()
    -- Create Blip
    local blip = AddBlipForCoord(Config.RentalLocation.coords.x, Config.RentalLocation.coords.y, Config.RentalLocation.coords.z)
    SetBlipSprite(blip, 225)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.8)
    SetBlipColour(blip, 3)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Vehicle Rental")
    EndTextCommandSetBlipName(blip)

    local model = joaat(Config.RentalLocation.model)
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(0) end

    rentalPed = CreatePed(4, model, Config.RentalLocation.coords.x, Config.RentalLocation.coords.y, Config.RentalLocation.coords.z - 1.0, Config.RentalLocation.heading, false, false)
    SetEntityAsMissionEntity(rentalPed, true, true)
    SetBlockingOfNonTemporaryEvents(rentalPed, true)
    FreezeEntityPosition(rentalPed, true)
    SetEntityInvincible(rentalPed, true)

    exports.ox_target:addLocalEntity(rentalPed, {
        {
            name = "rental_open",
            label = "Rent a Vehicle",
            icon = "fas fa-car",
            onSelect = function()
                OpenRentalMenu()
            end
        }
    })
end)

function OpenRentalMenu()
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "open",
        vehicles = Config.Vehicles
    })
end

RegisterNUICallback("close", function(_, cb)
    SetNuiFocus(false, false)
    cb("ok")
end)

RegisterNUICallback("rentVehicle", function(data, cb)
    local success = lib.callback.await("qbx_rental:server:rentVehicle", false, data.model, data.price)
    
    if success then
        SetNuiFocus(false, false)
        SpawnRentedVehicle(data.model)
    end
    cb("ok")
end)

function SpawnRentedVehicle(modelName)
    local model = joaat(modelName)
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(0) end

    local veh = CreateVehicle(model, Config.RentalLocation.spawnCoords.x, Config.RentalLocation.spawnCoords.y, Config.RentalLocation.spawnCoords.z, Config.RentalLocation.spawnCoords.w, true, false)
    local networkId = NetworkGetNetworkIdFromEntity(veh)
    
    SetEntityAsMissionEntity(veh, true, true)
    TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
    
    -- Qbox/qb-vehiclekeys compatibility
    TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
    
    lib.notify({
        title = "Rental",
        description = "Enjoy your ride!",
        type = "success"
    })
end
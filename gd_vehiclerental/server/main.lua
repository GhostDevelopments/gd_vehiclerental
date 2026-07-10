lib.callback.register("qbx_rental:server:rentVehicle", function(source, model, price)
    local player = exports.qbx_core:GetPlayer(source)
    if not player then return false end

    local currentCash = exports.qbx_core:GetMoney(source, "cash")
    
    if currentCash >= price then
        exports.qbx_core:RemoveMoney(source, "cash", price, "vehicle-rental")
        return true
    else
        TriggerClientEvent("ox_lib:notify", source, {
            title = "Rental",
            description = "You don't have enough cash!",
            type = "error"
        })
        return false
    end
end)
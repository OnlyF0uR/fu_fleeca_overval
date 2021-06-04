ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

Doors = {
    ["F1"] = {{loc = vector3(312.93, -284.45, 54.16), h = 160.91, txtloc = vector3(312.93, -284.45, 54.16), obj = nil, locked = true}, {loc = vector3(310.93, -284.44, 54.16), txtloc = vector3(310.93, -284.44, 54.16), state = nil, locked = true}},
    ["F2"] = {{loc = vector3(148.76, -1045.89, 29.37), h = 158.54, txtloc = vector3(148.76, -1045.89, 29.37), obj = nil, locked = true}, {loc = vector3(146.61, -1046.02, 29.37), txtloc = vector3(146.61, -1046.02, 29.37), state = nil, locked = true}},
    ["F3"] = {{loc = vector3(-1209.66, -335.15, 37.78), h = 213.67, txtloc = vector3(-1209.66, -335.15, 37.78), obj = nil, locked = true}, {loc = vector3(-1211.07, -336.68, 37.78), txtloc = vector3(-1211.07, -336.68, 37.78), state = nil, locked = true}},
    ["F4"] = {{loc = vector3(-2957.26, 483.53, 15.70), h = 267.73, txtloc = vector3(-2957.26, 483.53, 15.70), obj = nil, locked = true}, {loc = vector3(-2956.68, 481.34, 15.70), txtloc = vector3(-2956.68, 481.34, 15.7), state = nil, locked = true}},
    ["F5"] = {{loc = vector3(-351.97, -55.18, 49.04), h = 159.79, txtloc = vector3(-351.97, -55.18, 49.04), obj = nil, locked = true}, {loc = vector3(-354.15, -55.11, 49.04), txtloc = vector3(-354.15, -55.11, 49.04), state = nil, locked = true}},
    ["F6"] = {{loc = vector3(1174.24, 2712.47, 38.09), h = 160.91, txtloc = vector3(1174.24, 2712.47, 38.09), obj = nil, locked = true}, {loc = vector3(1176.40, 2712.75, 38.09), txtloc = vector3(1176.40, 2712.75, 38.09), state = nil, locked = true}},
}

RegisterServerEvent("fu_fleeca_overval:startcheck")
AddEventHandler("fu_fleeca_overval:startcheck", function(bank)
    local _source = source
    local Players = ESX.GetPlayers()

    local copcount = 0
    for i = 1, #Players, 1 do
        local xPlayer = ESX.GetPlayerFromId(Players[i])

        if xPlayer.job.name == "police" then
            copcount = copcount + 1
        end
    end

    if copcount >= Config.mincops then
        local xPlayer = ESX.GetPlayerFromId(_source)
        local item = xPlayer.getInventoryItem("green_card")["count"]

        if item >= 1 then
            if not Config.Banks[bank].onaction == true then
                if (os.time() - Config.cooldown) > Config.Banks[bank].lastrobbed then
                    Config.Banks[bank].onaction = true
                    xPlayer.removeInventoryItem("green_card", 1)
                    
                    TriggerClientEvent("fu_fleeca_overval:outcome", _source, true, bank)
                else
                    TriggerClientEvent("fu_fleeca_overval:outcome", _source, false, "Deze bank is al overvallen. Wacht " ..math.floor((Config.cooldown - (os.time() - Config.Banks[bank].lastrobbed)) / 60).. ":" ..math.fmod((Config.cooldown - (os.time() - Config.Banks[bank].lastrobbed)), 60))
                end
            else
                TriggerClientEvent("fu_fleeca_overval:outcome", _source, false, "Deze bank wordt op het moment overvallen.")
            end
        else
            TriggerClientEvent("fu_fleeca_overval:outcome", _source, false, "Je hebt geen toegangskaart.")
        end
    else
        TriggerClientEvent("fu_fleeca_overval:outcome", _source, false, "Er is niet genoeg politie in de stad.")
    end
end)

RegisterServerEvent("fu_fleeca_overval:lootup")
AddEventHandler("fu_fleeca_overval:lootup", function(var, var2)
    TriggerClientEvent("fu_fleeca_overval:lootup_c", -1, var, var2)
end)

RegisterServerEvent("fu_fleeca_overval:toggleDoor")
AddEventHandler("fu_fleeca_overval:toggleDoor", function(key, state)
    Doors[key][1].locked = state
    TriggerClientEvent("fu_fleeca_overval:toggleDoor", -1, key, state)
end)

RegisterServerEvent("fu_fleeca_overval:toggleVault")
AddEventHandler("fu_fleeca_overval:toggleVault", function(key, state)
    Doors[key][2].locked = state
    TriggerClientEvent("fu_fleeca_overval:toggleVault", -1, key, state)
end)

RegisterServerEvent("fu_fleeca_overval:updateVaultState")
AddEventHandler("fu_fleeca_overval:updateVaultState", function(key, state)
    Doors[key][2].state = state
end)

RegisterServerEvent("fu_fleeca_overval:startLoot")
AddEventHandler("fu_fleeca_overval:startLoot", function(data, name, players)
    local _source = source

    for i = 1, #players, 1 do
        TriggerClientEvent("fu_fleeca_overval:startLoot_c", players[i], data, name)
    end
    TriggerClientEvent("fu_fleeca_overval:startLoot_c", _source, data, name)
end)

RegisterServerEvent("fu_fleeca_overval:stopHeist")
AddEventHandler("fu_fleeca_overval:stopHeist", function(name)
    TriggerClientEvent("fu_fleeca_overval:stopHeist_c", -1, name)
end)

RegisterServerEvent("fu_fleeca_overval:rewardCash")
AddEventHandler("fu_fleeca_overval:rewardCash", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local reward = math.random(Config.mincash, Config.maxcash)

    xPlayer.addAccountMoney("black_money", reward)
end)

RegisterServerEvent("fu_fleeca_overval:setCooldown")
AddEventHandler("fu_fleeca_overval:setCooldown", function(name)
    Config.Banks[name].lastrobbed = os.time()
    Config.Banks[name].onaction = false
    TriggerClientEvent("fu_fleeca_overval:resetDoorState", -1, name)
end)

ESX.RegisterServerCallback("fu_fleeca_overval:getBanks", function(source, cb)
    cb(Config.Banks, Doors)
end)

ESX.RegisterServerCallback("fu_fleeca_overval:checkSecond", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local item = xPlayer.getInventoryItem("hackerlaptop")["count"]

    if item >= 1 then
        cb(true)
    else
        cb(false)
    end
end)
ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

Freeze = {F1 = 0, F2 = 0, F3 = 0, F4 = 0, F5 = 0, F6 = 0}
PlayerData = nil
Check = {F1 = false, F2 = false, F3 = false, F4 = false, F5 = false, F6 = false}
SearchChecks = {F1 = false, F2 = false, F3 = false, F4 = false, F5 = false, F6 = false}
LootCheck = {
    F1 = {Stop = false, Loot1 = false, Loot2 = false, Loot3 = false},
    F2 = {Stop = false, Loot1 = false, Loot2 = false, Loot3 = false},
    F3 = {Stop = false, Loot1 = false, Loot2 = false, Loot3 = false},
    F4 = {Stop = false, Loot1 = false, Loot2 = false, Loot3 = false},
    F5 = {Stop = false, Loot1 = false, Loot2 = false, Loot3 = false},
    F6 = {Stop = false, Loot1 = false, Loot2 = false, Loot3 = false}
}

Doors = {}
local disableinput = false
local initiator = false
local startdstcheck = false
local currentname = nil
local currentcoords = nil
local done = true
local dooruse = false

-- Disable input
Citizen.CreateThread(function()
    while true do
        if disableinput then
            DisableControlAction(0, 73, false)
            DisableControlAction(0, 24, true)
            DisableControlAction(0, 257, true)
            DisableControlAction(0, 25, true)
            DisableControlAction(0, 263, true)
            DisableControlAction(0, 32, true)
            DisableControlAction(0, 34, true)
            DisableControlAction(0, 31, true)
            DisableControlAction(0, 30, true)
            DisableControlAction(0, 45, true)
            DisableControlAction(0, 22, true)
            DisableControlAction(0, 44, true)
            DisableControlAction(0, 37, true)
            DisableControlAction(0, 23, true)
            DisableControlAction(0, 288, true)
            DisableControlAction(0, 289, true)
            DisableControlAction(0, 170, true)
            DisableControlAction(0, 167, true)
            DisableControlAction(0, 73, true)
            DisableControlAction(2, 199, true)
            DisableControlAction(0, 47, true)
            DisableControlAction(0, 264, true)
            DisableControlAction(0, 257, true)
            DisableControlAction(0, 140, true)
            DisableControlAction(0, 141, true)
            DisableControlAction(0, 142, true)
            DisableControlAction(0, 143, true)
        end
        Citizen.Wait(500)
    end
end)

function ShowTimer()
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(0.42, 0.42)
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextEntry("STRING")
    AddTextComponentString("~r~" .. Config.timer .. "~w~")
    DrawText(0.682, 0.96)
end

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(job)
    PlayerData.job = job
end)

RegisterNetEvent("fu_fleeca_overval:resetDoorState")
AddEventHandler("fu_fleeca_overval:resetDoorState", function(name)
    Freeze[name] = 0
end)

RegisterNetEvent("fu_fleeca_overval:lootup_c")
AddEventHandler("fu_fleeca_overval:lootup_c", function(var, var2)
    LootCheck[var][var2] = true
end)

RegisterNetEvent("fu_fleeca_overval:outcome")
AddEventHandler("fu_fleeca_overval:outcome", function(oc, arg)
    for i = 1, #Check, 1 do
        Check[i] = false
    end
    for i = 1, #LootCheck, 1 do
        for j = 1, #LootCheck[i] do
            LootCheck[i][j] = false
        end
    end
    if oc then
        Check[arg] = true
        TriggerEvent("fu_fleeca_overval:startheist", Config.Banks[arg], arg)
    elseif not oc then
        Notify(arg)
    end
end)

RegisterNetEvent("fu_fleeca_overval:startLoot_c")
AddEventHandler("fu_fleeca_overval:startLoot_c", function(data, name)
    currentname = name
    currentcoords = vector3(data.doors.startloc.x, data.doors.startloc.y, data.doors.startloc.z)
    if not LootCheck[name].Stop then
        Citizen.CreateThread(function()
            while true do
                local pedcoords = GetEntityCoords(PlayerPedId())
                local dst = GetDistanceBetweenCoords(pedcoords, data.doors.startloc.x, data.doors.startloc.y,
                                data.doors.startloc.z, true)

                if dst < 40 then
                    if not LootCheck[name].Loot1 then
                        local dst1 = GetDistanceBetweenCoords(pedcoords, data.trolley1.x, data.trolley1.y,
                                         data.trolley1.z + 1, true)

                        if dst1 < 5 then
                            exports.fu_text:drawHologram(data.trolley1.x, data.trolley1.y, data.trolley1.z + 1, '[~r~E~w~] Geld pakken')
                            if dst1 < 0.75 and IsControlJustReleased(0, 38) then
                                TriggerServerEvent("fu_fleeca_overval:lootup", name, "Loot1")
                                StartGrab(name)
                            end
                        end
                    end

                    if not LootCheck[name].Loot2 then
                        local dst1 = GetDistanceBetweenCoords(pedcoords, data.trolley2.x, data.trolley2.y,
                                         data.trolley2.z + 1, true)

                        if dst1 < 5 then
                            exports.fu_text:drawHologram(data.trolley2.x, data.trolley2.y, data.trolley2.z + 1, '[~r~E~w~] Geld pakken')
                            if dst1 < 1 and IsControlJustReleased(0, 38) then
                                TriggerServerEvent("fu_fleeca_overval:lootup", name, "Loot2")
                                StartGrab(name)
                            end
                        end
                    end

                    if not LootCheck[name].Loot3 then
                        local dst1 = GetDistanceBetweenCoords(pedcoords, data.trolley3.x, data.trolley3.y,
                                         data.trolley3.z + 1, true)

                        if dst1 < 5 then
                            exports.fu_text:drawHologram(data.trolley3.x, data.trolley3.y, data.trolley3.z + 1, '[~r~E~w~] Geld pakken')
                            if dst1 < 1 and IsControlJustReleased(0, 38) then
                                TriggerServerEvent("fu_fleeca_overval:lootup", name, "Loot3")
                                StartGrab(name)
                            end
                        end
                    end

                    if LootCheck[name].Stop or
                        (LootCheck[name].Loot1 and LootCheck[name].Loot2 and LootCheck[name].Loot3) then
                        LootCheck[name].Stop = false
                        if initiator then
                            TriggerEvent("fu_fleeca_overval:reset", name, data)
                            return
                        end
                        return
                    end
                    Citizen.Wait(1)
                else
                    Citizen.Wait(1000)
                end
            end
        end)
    end
end)

RegisterNetEvent("fu_fleeca_overval:stopHeist_c")
AddEventHandler("fu_fleeca_overval:stopHeist_c", function(name)
    LootCheck[name].Stop = true
end)

-- MAIN DOOR UPDATE --

AddEventHandler("fu_fleeca_overval:freezeDoors", function()
    Citizen.CreateThread(function()
        while true do
            for k, v in pairs(Doors) do
                if v[1].obj == nil or not DoesEntityExist(v[1].obj) then
                    v[1].obj =
                        GetClosestObjectOfType(v[1].loc, 1.5, GetHashKey("v_ilev_gb_vaubar"), false, false, false)
                    FreezeEntityPosition(v[1].obj, v[1].locked)
                else
                    FreezeEntityPosition(v[1].obj, v[1].locked)
                    Citizen.Wait(100)
                end
                if v[1].locked then
                    SetEntityHeading(v[1].obj, v[1].h)
                end
                Citizen.Wait(100)
            end
            Citizen.Wait(1)
        end
    end)
    Citizen.CreateThread(function()
        while true do
            if PlayerData.job.name == "police" and not dooruse then
                local pcoords = GetEntityCoords(PlayerPedId())

                for k, v in pairs(Doors) do
                    for i = 1, 2, 1 do
                        local dst = GetDistanceBetweenCoords(pcoords, v[i].loc, true)

                        if dst <= 4.0 then
                            if v[i].locked then
                                exports.fu_text:drawHologram(v[i].txtloc[1], v[i].txtloc[2], v[i].txtloc[3], '[~r~E~w~] Deur ontgrendelen')
                            elseif not v[i].locked then
                                exports.fu_text:drawHologram(v[i].txtloc[1], v[i].txtloc[2], v[i].txtloc[3], '[~r~E~w~] Deur vergrendelen')
                            end
                            if dst <= 1.5 and IsControlJustReleased(0, 38) then
                                dooruse = true
                                if i == 2 then
                                    TriggerServerEvent("fu_fleeca_overval:toggleVault", k, not v[i].locked)
                                else
                                    TriggerServerEvent("fu_fleeca_overval:toggleDoor", k, not v[i].locked)
                                end
                            end
                        end
                    end
                end
            else
                Citizen.Wait(1000)
            end
            Citizen.Wait(1)
        end
    end)
    Citizen.CreateThread(function()
        doVaultStuff = function()
            while true do
                local pcoords = GetEntityCoords(PlayerPedId())

                for k, v in pairs(Doors) do
                    if GetDistanceBetweenCoords(v[2].loc, pcoords, true) <= 20.0 then
                        if v[2].state ~= nil then
                            local obj
                            if k ~= "F4" then
                                obj = GetClosestObjectOfType(v[2].loc, 1.5, GetHashKey("v_ilev_gb_vauldr"), false,
                                          false, false)
                            else
                                obj = GetClosestObjectOfType(v[2].loc, 1.5, 4231427725, false, false, false)
                            end
                            SetEntityHeading(obj, v[2].state)
                            Citizen.Wait(1000)
                            return doVaultStuff()
                        end
                    else
                        Citizen.Wait(1000)
                    end
                end
                Citizen.Wait(1)
            end
        end
        doVaultStuff()
    end)
end)

RegisterNetEvent("fu_fleeca_overval:toggleDoor")
AddEventHandler("fu_fleeca_overval:toggleDoor", function(key, state)
    Doors[key][1].locked = state
    dooruse = false
end)

RegisterNetEvent("fu_fleeca_overval:toggleVault")
AddEventHandler("fu_fleeca_overval:toggleVault", function(key, state)
    dooruse = true
    Doors[key][2].state = nil
    if Config.Banks[key].hash == nil then
        if not state then
            local obj = GetClosestObjectOfType(Config.Banks[key].doors.startloc.x, Config.Banks[key].doors.startloc.y,
                            Config.Banks[key].doors.startloc.z, 2.0, GetHashKey(Config.vaultdoor), false, false, false)
            local count = 0

            repeat
                local heading = GetEntityHeading(obj) - 0.10

                SetEntityHeading(obj, heading)
                count = count + 1
                Citizen.Wait(10)
            until count == 900
            Doors[key][2].locked = state
            Doors[key][2].state = GetEntityHeading(obj)
            TriggerServerEvent("fu_fleeca_overval:updateVaultState", key, Doors[key][2].state)
        elseif state then
            local obj = GetClosestObjectOfType(Config.Banks[key].doors.startloc.x, Config.Banks[key].doors.startloc.y,
                            Config.Banks[key].doors.startloc.z, 2.0, GetHashKey(Config.vaultdoor), false, false, false)
            local count = 0

            repeat
                local heading = GetEntityHeading(obj) + 0.10

                SetEntityHeading(obj, heading)
                count = count + 1
                Citizen.Wait(10)
            until count == 900
            Doors[key][2].locked = state
            Doors[key][2].state = GetEntityHeading(obj)
            TriggerServerEvent("fu_fleeca_overval:updateVaultState", key, Doors[key][2].state)
        end
    else
        if not state then
            local obj = GetClosestObjectOfType(Config.Banks.F4.doors.startloc.x, Config.Banks.F4.doors.startloc.y,
                            Config.Banks.F4.doors.startloc.z, 2.0, Config.Banks.F4.hash, false, false, false)
            local count = 0
            repeat
                local heading = GetEntityHeading(obj) - 0.10

                SetEntityHeading(obj, heading)
                count = count + 1
                Citizen.Wait(10)
            until count == 900
            Doors[key][2].locked = state
            Doors[key][2].state = GetEntityHeading(obj)
            TriggerServerEvent("fu_fleeca_overval:updateVaultState", key, Doors[key][2].state)
        elseif state then
            local obj = GetClosestObjectOfType(Config.Banks.F4.doors.startloc.x, Config.Banks.F4.doors.startloc.y,
                            Config.Banks.F4.doors.startloc.z, 2.0, Config.Banks.F4.hash, false, false, false)
            local count = 0

            repeat
                local heading = GetEntityHeading(obj) + 0.10

                SetEntityHeading(obj, heading)
                count = count + 1
                Citizen.Wait(10)
            until count == 900
            Doors[key][2].locked = state
            Doors[key][2].state = GetEntityHeading(obj)
            TriggerServerEvent("fu_fleeca_overval:updateVaultState", key, Doors[key][2].state)
        end
    end
    dooruse = false
end)

AddEventHandler("fu_fleeca_overval:reset", function(name, data)
    for i = 1, #LootCheck[name], 1 do
        LootCheck[name][i] = false
    end
    
    Check[name] = false
    Notify("DE KLUISDEUR SLUIT OVER 15 SECONDEN!")
    Citizen.Wait(15000)
    
    Notify("DE KLUISDEUR IS AAN HET SLUITEN!")

    TriggerServerEvent("fu_fleeca_overval:toggleVault", name, true)
    TriggerEvent("fu_fleeca_overval:cleanUp", data, name)
end)

AddEventHandler("fu_fleeca_overval:startheist", function(data, name)
    TriggerServerEvent("fu_fleeca_overval:toggleDoor", name, true) -- ensure to lock the second door for the second, third, fourth... heist
    disableinput = true
    currentname = name
    currentcoords = vector3(data.doors.startloc.x, data.doors.startloc.y, data.doors.startloc.z)
    initiator = true
    RequestModel("p_ld_id_card_01")
    while not HasModelLoaded("p_ld_id_card_01") do
        Citizen.Wait(1)
    end
    local ped = PlayerPedId()

    SetEntityCoords(ped, data.doors.startloc.animcoords.x, data.doors.startloc.animcoords.y,
        data.doors.startloc.animcoords.z)
    SetEntityHeading(ped, data.doors.startloc.animcoords.h)
    local pedco = GetEntityCoords(PlayerPedId())
    IdProp = CreateObject(GetHashKey("p_ld_id_card_01"), pedco, 1, 1, 0)
    local boneIndex = GetPedBoneIndex(PlayerPedId(), 28422)

    AttachEntityToEntity(IdProp, ped, boneIndex, 0.12, 0.028, 0.001, 10.0, 175.0, 0.0, true, true, false, true, 1, true)
    TaskStartScenarioInPlace(ped, "PROP_HUMAN_ATM", 0, true)

    TriggerEvent("mythic_progbar:client:progress", {
        name = "fleeca_overval",
        duration = 4500,
        label = "Toegangskaart gebruiken",
        useWhileDead = false,
        canCancel = false,
        controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }
    }, function(status)
        if not status then
            Citizen.Wait(1500)
            DetachEntity(IdProp, false, false)
            SetEntityCoords(IdProp, data.prop.first.coords, 0.0, 0.0, 0.0, false)
            SetEntityRotation(IdProp, data.prop.first.rot, 1, true)
            FreezeEntityPosition(IdProp, true)
            Citizen.Wait(500)
            ClearPedTasksImmediately(ped)
            disableinput = false
            Citizen.Wait(1000)

            PlaySoundFrontend(-1, "ATM_WINDOW", "HUD_FRONTEND_DEFAULT_SOUNDSET")
            TriggerServerEvent("fu_fleeca_overval:toggleVault", name, false)
            startdstcheck = true
            currentname = name
            SpawnTrolleys(data, name)

            -- Alarm & Notify
            Notify("Het stille alarm is afgegaan!")
            local playerCoords = GetEntityCoords(PlayerPedId())
            streetName,_ = GetStreetNameAtCoord(playerCoords.x, playerCoords.y, playerCoords.z)
            streetName = GetStreetNameFromHashKey(streetName)
            TriggerServerEvent("fu_alerts:bankRobbery", playerCoords, streetName)
        end
    end)

end)

AddEventHandler("fu_fleeca_overval:cleanUp", function(data, name)
    Citizen.Wait(10000)
    for i = 1, 3, 1 do -- full trolley clean
        local obj = GetClosestObjectOfType(data.objects[i].x, data.objects[i].y, data.objects[i].z, 0.75,
                        GetHashKey("hei_prop_hei_cash_trolly_01"), false, false, false)

        if DoesEntityExist(obj) then
            DeleteEntity(obj)
        end
    end
    for j = 1, 3, 1 do -- empty trolley clean
        local obj = GetClosestObjectOfType(data.objects[j].x, data.objects[j].y, data.objects[j].z, 0.75,
                        GetHashKey("hei_prop_hei_cash_trolly_03"), false, false, false)

        if DoesEntityExist(obj) then
            DeleteEntity(obj)
        end
    end
    if DoesEntityExist(IdProp) then
        DeleteEntity(IdProp)
    end
    if DoesEntityExist(IdProp2) then
        DeleteEntity(IdProp2)
    end
    TriggerServerEvent("fu_fleeca_overval:setCooldown", name)
    initiator = false
end)

function SecondDoor(data, key)
    disableinput = true
    local ped = PlayerPedId()

    SetEntityCoords(ped, data.doors.secondloc.animcoords.x, data.doors.secondloc.animcoords.y, data.doors.secondloc.animcoords.z)
    SetEntityHeading(ped, data.doors.secondloc.animcoords.h)

    -- TODO: Insert hacker game

    TriggerEvent("mythic_progbar:client:progress", {
        name = "fleeca_overval",
        duration = 8000,
        label = "Hacken",
        useWhileDead = false,
        canCancel = false,
        controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        },
        animation = {
            animDict = "mp_prison_break",
            anim = "hack_loop",
        },
    }, function(status)
        if not status then
            Citizen.Wait(1500)
            disableinput = false

            Notify("Tweede deur is open, let op de tijd!")
            PlaySoundFrontend(-1, "ATM_WINDOW", "HUD_FRONTEND_DEFAULT_SOUNDSET")
            TriggerServerEvent("fu_fleeca_overval:toggleDoor", key, false)
            disableinput = false
        end
    end)
end

function SpawnTrolleys(data, name)
    RequestModel("hei_prop_hei_cash_trolly_01")
    while not HasModelLoaded("hei_prop_hei_cash_trolly_01") do
        Citizen.Wait(1)
    end
    Trolley1 = CreateObject(GetHashKey("hei_prop_hei_cash_trolly_01"), data.trolley1.x, data.trolley1.y,
                   data.trolley1.z, 1, 1, 0)
    Trolley2 = CreateObject(GetHashKey("hei_prop_hei_cash_trolly_01"), data.trolley2.x, data.trolley2.y,
                   data.trolley2.z, 1, 1, 0)
    Trolley3 = CreateObject(GetHashKey("hei_prop_hei_cash_trolly_01"), data.trolley3.x, data.trolley3.y,
                   data.trolley3.z, 1, 1, 0)
    local h1 = GetEntityHeading(Trolley1)
    local h2 = GetEntityHeading(Trolley2)
    local h3 = GetEntityHeading(Trolley3)

    SetEntityHeading(Trolley1, h1 + Config.Banks[name].trolley1.h)
    SetEntityHeading(Trolley2, h2 + Config.Banks[name].trolley2.h)
    SetEntityHeading(Trolley3, h3 + Config.Banks[name].trolley3.h)
    local players, nearbyPlayer = ESX.Game.GetPlayersInArea(GetEntityCoords(PlayerPedId()), 20.0)
    local missionplayers = {}

    for i = 1, #players, 1 do
        if players[i] ~= PlayerId() then
            table.insert(missionplayers, GetPlayerServerId(players[i]))
        end
    end
    TriggerServerEvent("fu_fleeca_overval:startLoot", data, name, missionplayers)
    done = false
end

function StartGrab(name)
    disableinput = true
    local ped = PlayerPedId()
    local model = "hei_prop_heist_cash_pile"

    Trolley = GetClosestObjectOfType(GetEntityCoords(ped), 1.0, GetHashKey("hei_prop_hei_cash_trolly_01"), false, false,
                  false)
    local CashAppear = function()
        local pedCoords = GetEntityCoords(ped)
        local grabmodel = GetHashKey(model)

        RequestModel(grabmodel)
        while not HasModelLoaded(grabmodel) do
            Citizen.Wait(100)
        end
        local grabobj = CreateObject(grabmodel, pedCoords, true)

        FreezeEntityPosition(grabobj, true)
        SetEntityInvincible(grabobj, true)
        SetEntityNoCollisionEntity(grabobj, ped)
        SetEntityVisible(grabobj, false, false)
        AttachEntityToEntity(grabobj, ped, GetPedBoneIndex(ped, 60309), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 0, true)
        local startedGrabbing = GetGameTimer()

        Citizen.CreateThread(function()
            while GetGameTimer() - startedGrabbing < 37000 do
                Citizen.Wait(1)
                DisableControlAction(0, 73, true)
                if HasAnimEventFired(ped, GetHashKey("CASH_APPEAR")) then
                    if not IsEntityVisible(grabobj) then
                        SetEntityVisible(grabobj, true, false)
                    end
                end
                if HasAnimEventFired(ped, GetHashKey("RELEASE_CASH_DESTROY")) then
                    if IsEntityVisible(grabobj) then
                        SetEntityVisible(grabobj, false, false)
                        TriggerServerEvent("fu_fleeca_overval:rewardCash")
                    end
                end
            end
            DeleteObject(grabobj)
        end)
    end
    local trollyobj = Trolley
    local emptyobj = GetHashKey("hei_prop_hei_cash_trolly_03")

    if IsEntityPlayingAnim(trollyobj, "anim@heists@ornate_bank@grab_cash", "cart_cash_dissapear", 3) then
        return
    end
    local baghash = GetHashKey("hei_p_m_bag_var22_arm_s")

    RequestAnimDict("anim@heists@ornate_bank@grab_cash")
    RequestModel(baghash)
    RequestModel(emptyobj)
    while not HasAnimDictLoaded("anim@heists@ornate_bank@grab_cash") and not HasModelLoaded(emptyobj) and
        not HasModelLoaded(baghash) do
        Citizen.Wait(100)
    end
    while not NetworkHasControlOfEntity(trollyobj) do
        Citizen.Wait(1)
        NetworkRequestControlOfEntity(trollyobj)
    end
    local bag = CreateObject(GetHashKey("hei_p_m_bag_var22_arm_s"), GetEntityCoords(PlayerPedId()), true, false, false)
    local scene1 = NetworkCreateSynchronisedScene(GetEntityCoords(trollyobj), GetEntityRotation(trollyobj), 2, false,
                       false, 1065353216, 0, 1.3)

    NetworkAddPedToSynchronisedScene(ped, scene1, "anim@heists@ornate_bank@grab_cash", "intro", 1.5, -4.0, 1, 16,
        1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, scene1, "anim@heists@ornate_bank@grab_cash", "bag_intro", 4.0, -8.0, 1)
    SetPedComponentVariation(ped, 5, 0, 0, 0)
    NetworkStartSynchronisedScene(scene1)
    Citizen.Wait(1500)
    CashAppear()
    local scene2 = NetworkCreateSynchronisedScene(GetEntityCoords(trollyobj), GetEntityRotation(trollyobj), 2, false,
                       false, 1065353216, 0, 1.3)

    NetworkAddPedToSynchronisedScene(ped, scene2, "anim@heists@ornate_bank@grab_cash", "grab", 1.5, -4.0, 1, 16,
        1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, scene2, "anim@heists@ornate_bank@grab_cash", "bag_grab", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(trollyobj, scene2, "anim@heists@ornate_bank@grab_cash", "cart_cash_dissapear",
        4.0, -8.0, 1)
    NetworkStartSynchronisedScene(scene2)
    Citizen.Wait(37000)
    local scene3 = NetworkCreateSynchronisedScene(GetEntityCoords(trollyobj), GetEntityRotation(trollyobj), 2, false,
                       false, 1065353216, 0, 1.3)

    NetworkAddPedToSynchronisedScene(ped, scene3, "anim@heists@ornate_bank@grab_cash", "exit", 1.5, -4.0, 1, 16,
        1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, scene3, "anim@heists@ornate_bank@grab_cash", "bag_exit", 4.0, -8.0, 1)
    NetworkStartSynchronisedScene(scene3)
    NewTrolley = CreateObject(emptyobj, GetEntityCoords(trollyobj) + vector3(0.0, 0.0, -0.985), true)
    SetEntityRotation(NewTrolley, GetEntityRotation(trollyobj))
    while not NetworkHasControlOfEntity(trollyobj) do
        Citizen.Wait(1)
        NetworkRequestControlOfEntity(trollyobj)
    end
    DeleteObject(trollyobj)
    PlaceObjectOnGroundProperly(NewTrolley)
    Citizen.Wait(1800)
    DeleteObject(bag)
    SetPedComponentVariation(ped, 5, 45, 0, 0)
    RemoveAnimDict("anim@heists@ornate_bank@grab_cash")
    SetModelAsNoLongerNeeded(emptyobj)
    SetModelAsNoLongerNeeded(GetHashKey("hei_p_m_bag_var22_arm_s"))
    disableinput = false
end

Citizen.CreateThread(function()
    while true do
        if startdstcheck then
            if initiator then
                local playercoord = GetEntityCoords(PlayerPedId())

                if (GetDistanceBetweenCoords(playercoord, currentcoords, true)) > 20 then
                    LootCheck[currentname].Stop = true
                    startdstcheck = false
                    TriggerServerEvent("fu_fleeca_overval:stopHeist", currentname)
                end
            end
            Citizen.Wait(5)
        else
            Citizen.Wait(1000)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        if not done then
            local pedcoords = GetEntityCoords(PlayerPedId())
            local dst = GetDistanceBetweenCoords(pedcoords, Config.Banks[currentname].doors.secondloc.x,
                            Config.Banks[currentname].doors.secondloc.y, Config.Banks[currentname].doors.secondloc.z, true)

            if dst < 4 then
                exports.fu_text:drawHologram(Config.Banks[currentname].doors.secondloc.x, Config.Banks[currentname].doors.secondloc.y,
                Config.Banks[currentname].doors.secondloc.z, '[~r~E~w~] Hack paneel')
                if dst < 0.75 and IsControlJustReleased(0, 38) then
                    ESX.TriggerServerCallback("fu_fleeca_overval:checkSecond", function(result)
                        if result then
                            done = true
                            return SecondDoor(Config.Banks[currentname], currentname)
                        elseif not result then
                            Notify("Je hebt geen hackerlaptop bij je.")
                        end
                    end)
                end
            end
            if LootCheck[currentname].Stop then
                done = true
            end
        else
            Citizen.Wait(1000)
        end
        Citizen.Wait(5)
    end
end)

Citizen.CreateThread(function()
    local resettimer = Config.timer

    while true do
        if startdstcheck then
            if initiator then
                if Config.timer > 0 then
                    Citizen.Wait(1000)
                    Config.timer = Config.timer - 1
                elseif Config.timer == 0 then
                    startdstcheck = false
                    TriggerServerEvent("fu_fleeca_overval:stopHeist", currentname)
                    Config.timer = resettimer
                end
            end
            Citizen.Wait(1)
        else
            Citizen.Wait(1000)
        end
        Citizen.Wait(1)
    end
end)

Citizen.CreateThread(function()
    while true do
        if startdstcheck then
            if initiator then
                ShowTimer()
            end
        end
        Citizen.Wait(1)
    end
end)

Citizen.CreateThread(function()
    while ESX == nil do
        Citizen.Wait(100)
    end
    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(100)
    end
    PlayerData = ESX.GetPlayerData()
    while PlayerData == nil do
        Citizen.Wait(100)
    end
    ESX.TriggerServerCallback("fu_fleeca_overval:getBanks", function(bank, door)
        Config.Banks = bank
        Doors = door
    end)
    -- Citizen.Wait(1000)
    TriggerEvent("fu_fleeca_overval:freezeDoors")
    while true do
        if PlayerData.job.name ~= "police" then
            local coords = GetEntityCoords(PlayerPedId())

            for k, v in pairs(Config.Banks) do
                if not v.onaction then
                    local dst = GetDistanceBetweenCoords(coords, v.doors.startloc.x, v.doors.startloc.y,
                                    v.doors.startloc.z, true)

                    if dst <= 5 and not Check[k] then
                        exports.fu_text:drawHologram(v.doors.startloc.x, v.doors.startloc.y, v.doors.startloc.z, '[~r~E~w~] Overval starten')
                        if dst <= 1 and IsControlJustReleased(0, 38) then
                            TriggerServerEvent("fu_fleeca_overval:startcheck", k)
                        end
                    end

                end
            end
        else
            Citizen.Wait(1000)
        end
        Citizen.Wait(1)
    end
end)

function Notify(msg)
	TriggerEvent("pNotify:SendNotification", {
		text = msg,
		type = 'success',
		queue = "juwelry_overval",
		timeout = 2500,
		layout = "bottomCenter"
	})
end
local QBCore = exports['qb-core']:GetCoreObject()

local function GeneratePlate()
    local plate = 'SGRP' .. QBCore.Shared.RandomInt(2) .. QBCore.Shared.RandomStr(2)
    local result = MySQL.scalar.await('SELECT plate FROM player_vehicles WHERE plate = ?', {plate})
    if result then
        return GeneratePlate()
    else
        return plate:upper()
    end
end

QBCore.Functions.CreateCallback('bf-sellcheckpolice', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    local job = Player.PlayerData.job
    if job.name == 'police' and job.grade.level > 7 then
        cb(true)
    else
        cb(false)
    end
end)

RegisterNetEvent('bf-pdsellitemssrv', function()
    for k,pri in pairs(Config.PDIllegalItems) do
       local Player = QBCore.Functions.GetPlayer(source)
       local item = Player.Functions.GetItemByName(k)
       if item ~= nil then
       local count = item.amount
       local price = count*pri
       exports['qb-management']:AddMoney('police', price)
       Player.Functions.RemoveItem(k, count)
       local lab = QBCore.Shared.Items[k].label
       TriggerClientEvent('QBCore:Notify', source, "Sold "..lab..", Money Added To Mangement Fund", "error")
       end
end
end)

QBCore.Functions.CreateCallback('bf-getcopcount', function(source, cb)
    local amount = 0
    local players = QBCore.Functions.GetQBPlayers()
    for _, v in pairs(players) do
        if v and v.PlayerData.job.name == 'police' and v.PlayerData.job.onduty then
            amount += 1
        end
    end
    cb(amount)
end)


RegisterNetEvent('bf-convertblack', function(convrate)
    local Player = QBCore.Functions.GetPlayer(source)
    local item = Player.Functions.GetItemByName(Config.BlackMoneyItem)
    if item ~= nil then
    local count = item.amount
    local white = (convrate/100)*count
    Player.Functions.RemoveItem(Config.BlackMoneyItem, count)
    Player.Functions.AddMoney('bank', white, 'Coverted Black Money')
    TriggerClientEvent('QBCore:Notify', source, "Converted Black Money", "success")
    else
    TriggerClientEvent('QBCore:Notify', source, "You Dont Have Black Money", "error")
    end
end)

RegisterNetEvent('bf-welcomecarsrv', function()
    local Player = QBCore.Functions.GetPlayer(source)
    local item = Player.Functions.GetItemByName(Config.WelcomeRewardItem)
    if item ~= nil and item.amount > 0 then 
    Player.Functions.RemoveItem(Config.WelcomeRewardItem, 1)
    local src = source
    local plate = GeneratePlate()
    local chance = math.random(1, 3)
    local plrcar = Config.WelcomeRewardCars[chance]
    TriggerClientEvent('bf-welcomecarcl', src, plrcar, plate)
    MySQL.insert('INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, garage, state) VALUES (?, ?, ?, ?, ?, ?, ?, ?)', {
        Player.PlayerData.license,
        Player.PlayerData.citizenid,
        plrcar,
        GetHashKey(plrcar),
        '{}',
        plate,
        'pillboxgarage',
        0
    })

else
    
TriggerClientEvent('QBCore:Notify', source, "You Dont Have Car Coupon", "error")
end
end)

RegisterNetEvent("bf-welcomefood", function(convrate)
        local Player = QBCore.Functions.GetPlayer(source)
        local item = Player.Functions.GetItemByName(Config.WelcomeFoodItem)
        if item ~= nil and item.amount > 0 then
            Player.Functions.RemoveItem(Config.WelcomeFoodItem, 1)
            local src = source
            for _, food in pairs(Config.WelcomeRewardFoods) do
                Player.Functions.AddItem(food.name, food.count)
            end
        else
            TriggerClientEvent("QBCore:Notify", source, "You Dont Have Food Coupon", "error")
        end
    end)

    
    
    AddEventHandler('onResourceStart', function(resourceName)
        if (GetCurrentResourceName() == resourceName) then
            local content1 = "@here"
            local content = {
                {
                    ["color"] = '11793730',
                    ["author"] = {
                        ["icon_url"] = "https://cdn.discordapp.com/attachments/865964724297138207/981945660809039872/LOGO_SERVER_001.png",
                        ["name"] = 'AIVP Core Logs',
                    },
                    ["image"] = {
                        ["url"] = "https://cdn.discordapp.com/attachments/1186998738779132044/1199263943265366126/nrVCaTP.gif?ex=65c1e895&is=65af7395&hm=29a79f118ff98a917cf5fbf5959f1070c3395d066f50e11dc063dc527a190e15&"
                    },
                    ["title"] = "Scheduled Restart",
                    ["description"] = "AIVP Roleplay Server Restarting. Server Will Be Soon Online",
                    ["footer"] = {
                        ["text"] = "© AIVP Roleplay 2022",
                        ["icon_url"] = "https://cdn.discordapp.com/attachments/865964724297138207/981945660809039872/LOGO_SERVER_001.png",
                    },
                },
                
            }
            PerformHttpRequest('https://discord.com/api/webhooks/1243560583916425227/nbmfsI_0Km6dzGgVxzzannv69j4j9cuITdJi2TSTqPnzn3a7X9C3kE3AL-UMs9GTPJvv', function(err, text, headers) end, 'POST', json.encode({username = 'AIVP Core Logs', embeds = content, content = content1}), { ['Content-Type'] = 'application/json' })    
        end
        
    end)
    
if Config.Settings.Framework == "QB" then 
    QBCore.Functions.CreateUseableItem('spinbottle', function(source, item)
        local src = source
        local Player = QBCore.Functions.GetPlayer(src)
        if Player.Functions.GetItemByName(item.name) then
            TriggerClientEvent('bbv-placebottle', src)
        end
    end)
end

if Config.Settings.Framework == "ST" then 
    RegisterCommand('spinthebottle', function(source)
        local src = source
        TriggerClientEvent('bbv-placebottle', src)
    end)
end

if Config.Settings.Framework == "ESX" then 
    ESX.RegisterUsableItem('spinbottle', function(source)
        local src = source
        TriggerClientEvent('bbv-placebottle', src)
    end)
end
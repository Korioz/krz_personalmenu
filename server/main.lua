ESX = exports["es_extended"]:getSharedObject()

do
    local origRegisterServerEvent = RegisterServerEvent
    local origEsxRegisterServerCallback = ESX.RegisterServerCallback

    --[[
        If you are a server developer and you have some players kicked seeing this message :

        Server detected a potentially abusive behaviour.
        If you're not an abuser please contact the server owner so he can fix the underlying issue.


        - DEBUG INFO -
        Resource Name : ?
        Event Name : ?

        This means you probably have resources which are using `krz_personalmenu` old network event names prefix.
        Please update the event names prefix from `KorioZ-PersonalMenu` to `krz_personalmenu`.
    ]]

    RegisterServerEvent = function(eventName, ...)
        local endIdx = ('krz_personalmenu:'):len()

        if eventName:sub(1, endIdx) == 'krz_personalmenu' then
            local oldEventName = ('KorioZ-PersonalMenu:%s'):format(eventName:sub(endIdx + 1))

            origRegisterServerEvent(oldEventName)
            AddEventHandler(oldEventName, function()
                DropPlayer(source,
                    (
                        "Server detected a potentially abusive behaviour.\n"
                        .. "If you're not an abuser please contact the server owner so he can fix the underlying issue.\n\n"
                        .. "- DEBUG INFO -\n"
                        .. "Resource Name : %s\n"
                        .. "Event Name : %s"
                    ):format(
                        GetCurrentResourceName(),
                        oldEventName
                    )
                )
            end)
        end

        return origRegisterServerEvent(eventName, ...)
    end

    ESX.RegisterServerCallback = function(eventName, ...)
        local endIdx = ('krz_personalmenu:'):len()

        if eventName:sub(1, endIdx) == 'krz_personalmenu' then
            local oldEventName = ('KorioZ-PersonalMenu:%s'):format(eventName:sub(endIdx + 1))

            origEsxRegisterServerCallback(oldEventName, function(source)
                DropPlayer(source,
                    (
                        "Server detected a potentially abusive behaviour.\n"
                        .. "If you're not an abuser please contact the server owner so he can fix the underlying issue.\n\n"
                        .. "- DEBUG INFO -\n"
                        .. "Resource Name : %s\n"
                        .. "Event Name : %s"
                    ):format(
                        GetCurrentResourceName(),
                        oldEventName
                    )
                )
            end)
        end

        return origEsxRegisterServerCallback(eventName, ...)
    end
end

function getMaximumGrade(jobName)
    local p = promise.new()

    MySQL.Async.fetchScalar('SELECT grade FROM job_grades WHERE job_name = @job_name ORDER BY `grade` DESC', { ['@job_name'] = jobName }, function(result)
        p:resolve(result)
    end)

    local queryResult = Citizen.Await(p)

    return tonumber(queryResult)
end

function isAuthorizedForAdminCommand(adminCommandId, group)
    for i = 1, #Config.AdminCommands do
        local adminCommandCfg = Config.AdminCommands[i]

        if adminCommandCfg.id == adminCommandId then
            for j = 1, #adminCommandCfg.groups do
                if adminCommandCfg.groups[j] == group then
                    return true
                end
            end

            break
        end
    end

    return false
end

ESX.RegisterServerCallback('krz_personalmenu:Bill_getBills', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.Async.fetchAll('SELECT * FROM billing WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier
    }, function(result)
        local bills = {}

        for i = 1, #result do
            bills[#bills + 1] = {
                id = result[i].id,
                label = result[i].label,
                amount = result[i].amount
            }
        end

        cb(bills)
    end)
end)

ESX.RegisterServerCallback('krz_personalmenu:Admin_getUsergroup', function(source, cb)
    cb(ESX.GetPlayerFromId(source).getGroup() or 'user')
end)

local function makeTargetedEventFunction(fn)
    return function(targetServerId, ...)
        if tonumber(targetServerId) == -1 then return end
        fn(targetServerId, ...)
    end
end

-- Weapon Menu --
RegisterServerEvent('krz_personalmenu:Weapon_addAmmoToPedS', makeTargetedEventFunction(function(targetServerId, value, quantity)
    if #(GetEntityCoords(GetPlayerPed(source), false) - GetEntityCoords(GetPlayerPed(targetServerId), false)) > 3.0 then return end
    TriggerClientEvent('krz_personalmenu:Weapon_addAmmoToPedC', targetServerId, value, quantity)
end))

-- Admin Menu --
RegisterServerEvent('krz_personalmenu:Admin_BringS', makeTargetedEventFunction(function(playerId, targetServerId)
    local xPlayer = ESX.GetPlayerFromId(source)
    local plyGroup = xPlayer.getGroup()

    if not isAuthorizedForAdminCommand('bring', plyGroup) and not isAuthorizedForAdminCommand('goto', plyGroup) then return end

    TriggerClientEvent('krz_personalmenu:Admin_BringC', playerId, GetEntityCoords(GetPlayerPed(targetServerId)))
end))

RegisterServerEvent('krz_personalmenu:Admin_giveCash', function(amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    local plyGroup = xPlayer.getGroup()

    if not isAuthorizedForAdminCommand('givemoney', plyGroup) then return end

    xPlayer.addAccountMoney('cash', amount)
    TriggerClientEvent('esx:showNotification', xPlayer.source, ('GIVE de %i$'):format(amount))
end)

RegisterServerEvent('krz_personalmenu:Admin_giveBank', function(amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    local plyGroup = xPlayer.getGroup()

    if not isAuthorizedForAdminCommand('givebank', plyGroup) then return end

    xPlayer.addAccountMoney('bank', amount)
    TriggerClientEvent('esx:showNotification', xPlayer.source, ('GIVE de %i$ en banque'):format(amount))
end)

RegisterServerEvent('krz_personalmenu:Admin_giveDirtyMoney', function(amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    local plyGroup = xPlayer.getGroup()

    if not isAuthorizedForAdminCommand('givedirtymoney', plyGroup) then return end

    xPlayer.addAccountMoney('black_money', amount)
    TriggerClientEvent('esx:showNotification', xPlayer.source, ('GIVE de %i$ sale'):format(amount))
end)

-- Grade Menu --
RegisterServerEvent('krz_personalmenu:Boss_promouvoirplayer', makeTargetedEventFunction(function(targetServerId)
    local sourceXPlayer = ESX.GetPlayerFromId(source)
    local sourceJob = sourceXPlayer.getJob()

    if sourceJob.grade_name ~= 'boss' then
        TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous n\'avez pas ~r~l\'autorisation~w~.')
        return
    end

    local targetXPlayer = ESX.GetPlayerFromId(targetServerId)
    local targetJob = targetXPlayer.getJob()

    if sourceJob.name ~= targetJob.name then
        TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Le joueur n\'es pas dans votre entreprise.')
        return
    end

    local newGrade = tonumber(targetJob.grade) + 1

    if newGrade == getMaximumGrade(targetJob.name) then
        TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous devez demander une autorisation ~r~Gouvernementale~w~.')
        return
    end

    targetXPlayer.setJob(targetJob.name, newGrade)

    TriggerClientEvent('esx:showNotification', sourceXPlayer.source, ('Vous avez ~g~promu %s~w~.'):format(targetXPlayer.name))
    TriggerClientEvent('esx:showNotification', targetServerId, ('Vous avez été ~g~promu par %s~w~.'):format(sourceXPlayer.name))
end))

RegisterServerEvent('krz_personalmenu:Boss_destituerplayer', makeTargetedEventFunction(function(targetServerId)
    local sourceXPlayer = ESX.GetPlayerFromId(source)
    local sourceJob = sourceXPlayer.getJob()

    if sourceJob.grade_name ~= 'boss' then
        TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous n\'avez pas ~r~l\'autorisation~w~.')
        return
    end

    local targetXPlayer = ESX.GetPlayerFromId(targetServerId)
    local targetJob = targetXPlayer.getJob()

    if sourceJob.name ~= targetJob.name then
        TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Le joueur n\'es pas dans votre organisation.')
        return
    end

    local newGrade = tonumber(targetJob.grade) - 1

    if newGrade < 0 then
        TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous ne pouvez pas ~r~rétrograder~w~ d\'avantage.')
        return
    end

    targetXPlayer.setJob(targetJob.name, newGrade)

    TriggerClientEvent('esx:showNotification', sourceXPlayer.source, ('Vous avez ~r~rétrogradé %s~w~.'):format(targetXPlayer.name))
    TriggerClientEvent('esx:showNotification', targetServerId, ('Vous avez été ~r~rétrogradé par %s~w~.'):format(sourceXPlayer.name))
end))

RegisterServerEvent('krz_personalmenu:Boss_recruterplayer', makeTargetedEventFunction(function(targetServerId)
    local sourceXPlayer = ESX.GetPlayerFromId(source)
    local sourceJob = sourceXPlayer.getJob()

    if sourceJob.grade_name ~= 'boss' then return end

    local targetXPlayer = ESX.GetPlayerFromId(targetServerId)

    targetXPlayer.setJob(sourceJob.name, 0)
    TriggerClientEvent('esx:showNotification', sourceXPlayer.source, ('Vous avez ~g~recruté %s~w~.'):format(targetXPlayer.name))
    TriggerClientEvent('esx:showNotification', targetServerId, ('Vous avez été ~g~embauché par %s~w~.'):format(sourceXPlayer.name))
end))

RegisterServerEvent('krz_personalmenu:Boss_virerplayer', makeTargetedEventFunction(function(targetServerId)
    local sourceXPlayer = ESX.GetPlayerFromId(source)
    local sourceJob = sourceXPlayer.getJob()

    if sourceJob.grade_name ~= 'boss' then
        TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous n\'avez pas ~r~l\'autorisation~w~.')
        return
    end

    local targetXPlayer = ESX.GetPlayerFromId(targetServerId)
    local targetJob = targetXPlayer.getJob()

    if sourceJob.name ~= targetJob.name then
        TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Le joueur n\'es pas dans votre entreprise.')
        return
    end

    targetXPlayer.setJob('unemployed', 0)
    TriggerClientEvent('esx:showNotification', sourceXPlayer.source, ('Vous avez ~r~viré %s~w~.'):format(targetXPlayer.name))
    TriggerClientEvent('esx:showNotification', targetServerId, ('Vous avez été ~g~viré par %s~w~.'):format(sourceXPlayer.name))
end))

RegisterServerEvent('krz_personalmenu:Boss_promouvoirplayer2', makeTargetedEventFunction(function(targetServerId)
    local sourceXPlayer = ESX.GetPlayerFromId(source)
    local sourceJob = sourceXPlayer.getJob2()

    if sourceJob.grade_name ~= 'boss' then
        TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous n\'avez pas ~r~l\'autorisation~w~.')
        return
    end

    local targetXPlayer = ESX.GetPlayerFromId(targetServerId)
    local targetJob = targetXPlayer.getJob2()

    if sourceJob.name ~= targetJob.name then
        TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Le joueur n\'es pas dans votre organisation.')
        return
    end

    local newGrade = tonumber(targetJob.grade) + 1

    if newGrade == getMaximumGrade(targetJob.name) then
        TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous devez demander une autorisation ~r~Gouvernementale~w~.')
        return
    end

    targetXPlayer.setJob2(targetJob.name, newGrade)

    TriggerClientEvent('esx:showNotification', sourceXPlayer.source, ('Vous avez ~g~promu %s~w~.'):format(targetXPlayer.name))
    TriggerClientEvent('esx:showNotification', targetServerId, ('Vous avez été ~g~promu par %s~w~.'):format(sourceXPlayer.name))
end))

RegisterServerEvent('krz_personalmenu:Boss_destituerplayer2', makeTargetedEventFunction(function(targetServerId)
    local sourceXPlayer = ESX.GetPlayerFromId(source)
    local sourceJob = sourceXPlayer.getJob2()

    if sourceJob.grade_name ~= 'boss' then
        TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous n\'avez pas ~r~l\'autorisation~w~.')
        return
    end

    local targetXPlayer = ESX.GetPlayerFromId(targetServerId)
    local targetJob = targetXPlayer.getJob2()

    if sourceJob.name ~= targetJob.name then
        TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Le joueur n\'es pas dans votre organisation.')
        return
    end

    local newGrade = tonumber(targetJob.grade) - 1

    if newGrade < 0 then
        TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous ne pouvez pas ~r~rétrograder~w~ d\'avantage.')
        return
    end

    targetXPlayer.setJob2(targetJob.name, newGrade)

    TriggerClientEvent('esx:showNotification', sourceXPlayer.source, ('Vous avez ~r~rétrogradé %s~w~.'):format(targetXPlayer.name))
    TriggerClientEvent('esx:showNotification', targetServerId, ('Vous avez été ~r~rétrogradé par %s~w~.'):format(sourceXPlayer.name))
end))

RegisterServerEvent('krz_personalmenu:Boss_recruterplayer2', makeTargetedEventFunction(function(targetServerId, grade2)
    local sourceXPlayer = ESX.GetPlayerFromId(source)
    local sourceJob = sourceXPlayer.getJob2()

    if sourceJob.grade_name ~= 'boss' then return end

    local targetXPlayer = ESX.GetPlayerFromId(targetServerId)

    targetXPlayer.setJob2(sourceJob.name, 0)
    TriggerClientEvent('esx:showNotification', sourceXPlayer.source, ('Vous avez ~g~recruté %s~w~.'):format(targetXPlayer.name))
    TriggerClientEvent('esx:showNotification', targetServerId, ('Vous avez été ~g~embauché par %s~w~.'):format(sourceXPlayer.name))
end))

RegisterServerEvent('krz_personalmenu:Boss_virerplayer2', makeTargetedEventFunction(function(targetServerId)
    local sourceXPlayer = ESX.GetPlayerFromId(source)
    local sourceJob = sourceXPlayer.getJob2()

    if sourceJob.grade_name ~= 'boss' then
        TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous n\'avez pas ~r~l\'autorisation~w~.')
        return
    end

    local targetXPlayer = ESX.GetPlayerFromId(targetServerId)
    local targetJob = targetXPlayer.getJob2()

    if sourceJob.name ~= targetJob.name then
        TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Le joueur n\'es pas dans votre organisation.')
        return
    end

    targetXPlayer.setJob2('unemployed2', 0)
    TriggerClientEvent('esx:showNotification', sourceXPlayer.source, ('Vous avez ~r~viré %s~w~.'):format(targetXPlayer.name))
    TriggerClientEvent('esx:showNotification', targetServerId, ('Vous avez été ~g~viré par %s~w~.'):format(sourceXPlayer.name))
end))
function LoadAnimDict(dict)
    RequestAnimDict(dict)

    while not HasAnimDictLoaded(dict) do
        Wait(0)
    end
end

function LoadAnimSet(animSet)
    RequestAnimSet(animSet)

    while not HasAnimSetLoaded(animSet) do
        Wait(0)
    end
end

function MathRound(v, numDecimal)
    if math.type(v) ~= 'float' then v += 0.0 end

    if numDecimal then
        local power = 10 ^ numDecimal
        return math.floor(v * power + 0.5) / power
    end

    return math.floor(v + 0.5)
end

if Config.Framework == 'esx' then
    local playerData = {
        inventory = {},
        accounts = {},
        job = {}
    }

    local societyMoney, societyMoney2 = nil, nil

    if Config.DoubleJob then
        playerData.job2 = {}
    end

    local function parsePlayerJob(job, xPlayerJob)
        job.id = xPlayerJob.name
        job.name = xPlayerJob.label
        job.gradeName = xPlayerJob.grade_label
        job.isBoss = xPlayerJob.grade_name == 'boss'
    end

    local function parsePlayerData(xPlayer)
        playerData.inventory = xPlayer.inventory
        playerData.accounts = xPlayer.accounts
        parsePlayerJob(playerData.job, xPlayer.job)

        if Config.DoubleJob then
            parsePlayerJob(playerData.job2, xPlayer.job2)
        end
    end

    function GetPlayerInventory()
        return playerData.inventory
    end

    function GetPlayerAccounts()
        return playerData.accounts
    end

    function GetPlayerJob()
        return playerData.job
    end

    function GetSocietyMoney()
        return societyMoney
    end

    if Config.DoubleJob then
        function GetPlayerJob2()
            return playerData.job2
        end

        function GetSocietyMoney2()
            return societyMoney2
        end
    end

    local function refreshMoney()
        local playerJob = GetPlayerJob()

        if playerJob.isBoss then
            ESX.TriggerServerCallback('esx_society:getSocietyMoney', function(money)
                societyMoney = money
            end, playerJob.id)
        end
    end

    local function refreshMoney2()
        local playerJob2 = GetPlayerJob2()

        if playerJob2.isBoss then
            ESX.TriggerServerCallback('esx_society:getSocietyMoney', function(money)
                societyMoney2 = money
            end, playerJob2.id)
        end
    end

    RegisterNetEvent('esx:playerLoaded', function(xPlayer)
        parsePlayerData(xPlayer)

        refreshMoney()

        if Config.DoubleJob then
            refreshMoney2()
        end
    end)

    RegisterNetEvent('esx:setJob', function(job)
        parsePlayerJob(playerData.job, job)
        refreshMoney()
    end)

    RegisterNetEvent('esx:setJob2', function(job)
        parsePlayerJob(playerData.job2, job)
        refreshMoney2()
    end)

    AddEventHandler('krz_personalmenu:menuOpening', function()
        parsePlayerData(ESX.GetPlayerData())
    end)

    RegisterNetEvent('esx_addonaccount:setMoney', function(societyId, money)
        local playerJob = GetPlayerJob()
        if playerJob.isBoss and ('society_%s'):format(playerJob.id) == societyId then
            societyMoney = money
        end

        if Config.DoubleJob then
            local playerJob = GetPlayerJob2()
            if playerJob2.isBoss and ('society_%s'):format(playerJob2.id) == societyId then
                societyMoney2 = money
            end
        end
    end)

    function GameNotification(msg)
        ESX.ShowNotification(msg)
    end

    function GetClosestPlayer()
        return ESX.Game.GetClosestPlayer()
    end

    function GroupDigits(number)
        return ESX.Math.GroupDigits(number)
    end

    function TriggerServerCallback(name, cb, ...)
        ESX.TriggerServerCallback(name, cb, ...)
    end

    CreateThread(function()
        ESX = exports['es_extended']:getSharedObject()

        while not ESX.GetPlayerData().job do
            Wait(100)
        end

        if Config.DoubleJob then
            while not ESX.GetPlayerData().job2 do
                Wait(100)
            end
        end

        parsePlayerData(ESX.GetPlayerData())
    end)
end
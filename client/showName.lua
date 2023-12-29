local GTComponents = {
    GAMER_NAME = 0,
    CREW_TAG = 1,
    healthArmour = 2,
    BIG_TEXT = 3,
    AUDIO_ICON = 4,
    MP_USING_MENU = 5,
    MP_PASSIVE_MODE = 6,
    WANTED_STARS = 7,
    MP_DRIVER = 8,
    MP_CO_DRIVER = 9,
    MP_TAGGED = 10,
    GAMER_NAME_NEARBY = 11,
    ARROW = 12,
    MP_PACKAGES = 13,
    INV_IF_PED_FOLLOWING = 14,
    RANK_TEXT = 15,
    MP_TYPING = 16,
    MP_BAG_LARGE = 17,
    MP_TAG_ARROW = 18,
    MP_GANG_CEO = 19,
    MP_GANG_BIKER = 20,
    BIKER_ARROW = 21,
    MC_ROLE_PRESIDENT = 22,
    MC_ROLE_VICE_PRESIDENT = 23,
    MC_ROLE_ROAD_CAPTAIN = 24,
    MC_ROLE_SARGEANT = 25,
    MC_ROLE_ENFORCER = 26,
    MC_ROLE_PROSPECT = 27,
    MP_TRANSMITTER = 28,
    MP_BOMB = 29
}

activeTags = {}
activeTagsMutex = {}

CreateThread(function()
    local playerId = PlayerId()
    local GetPlayerPed = GetPlayerPed
    local GetPlayerServerId = GetPlayerServerId
    local GetPlayerName = GetPlayerName

    local function sanitizeString(s)
        if type(s) ~= "string" then return "" end
        local res = s:gsub("[^\32-\126]", "")
            :gsub('[<>]', '')
            :gsub('~.*~', '')

        if res:len() < s:len() then
            local trimmedRes = res:gsub("%s", "")

            if trimmedRes == "" then
                return trimmedRes
            end
        end

        return res
    end

    local activeTagsMutex = activeTagsMutex

    while true do
        if PlayerVars.showName then
            local activeTagsByPlayerId = {}

            for i = #activeTagsMutex, 1, -1 do
                local tag = activeTagsMutex[i]

                if tag then
                    if IsMpGamerTagActive(tag.handle) then
                        activeTagsByPlayerId[tag.playerId] = true
                    else
                        table.remove(activeTagsMutex, i)
                    end
                end
            end

            do
                local activePlayers = GetActivePlayers()

                for i = 1, #activePlayers do
                    local targetPlayer = activePlayers[i]

                    if targetPlayer ~= playerId then
                        if not activeTagsByPlayerId[targetPlayer] then
                            local targetPed = GetPlayerPed(targetPlayer)

                            if targetPed > 0 then
                                local targetPlayerServerId = GetPlayerServerId(targetPlayer)
                                local sanitizedName = sanitizeString(GetPlayerName(targetPlayer))
                                local renderedText = ("[%d] %s"):format(targetPlayerServerId, sanitizedName == "" and "Inconnu" or sanitizedName)
                                local tagHandle = CreateFakeMpGamerTag(targetPed, renderedText, false, false, "", 0)

                                activeTagsMutex[#activeTagsMutex + 1] = {
                                    handle = tagHandle,
                                    playerId = targetPlayer
                                }
                            end
                        end
                    end
                end
            end

            local _activeTags = {}

            for i = 1, #activeTagsMutex do
                local tagMutex = activeTagsMutex[i]
                _activeTags[i] = tagMutex
            end

            activeTags = _activeTags
        end

        Wait(PlayerVars.showName and 100 or 200)
    end
end)

CreateThread(function()
    SetMpGamerTagsUseVehicleBehavior(false)
    SetMpGamerTagsVisibleDistance(424.0)

    local GetPlayerPed = GetPlayerPed
    local MumbleIsPlayerTalking = MumbleIsPlayerTalking

    while true do
        if PlayerVars.showName then
            for i = 1, #activeTags do
                local tag = activeTags[i]
                local targetPed = GetPlayerPed(tag.playerId)

                if targetPed > 0 then
                    local tagHandle = tag.handle
                    SetMpGamerTagVisibility(tagHandle, GTComponents["GAMER_NAME"], true)
                    SetMpGamerTagVisibility(tagHandle, GTComponents["healthArmour"], true)
                    SetMpGamerTagVisibility(tagHandle, GTComponents["AUDIO_ICON"], MumbleIsPlayerTalking(tag.playerId))

                    SetMpGamerTagAlpha(tagHandle, GTComponents["healthArmour"], 255)

                    SetMpGamerTagAlpha(tagHandle, GTComponents["AUDIO_ICON"], 255)
                    SetMpGamerTagColour(tagHandle, GTComponents["AUDIO_ICON"], 118)
                end
            end
        end

        Wait(PlayerVars.showName and 0 or 200)
    end
end)
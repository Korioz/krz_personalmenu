local function startPointing(ped)
    LoadAnimDict('anim@mp_point')
    SetPedConfigFlag(ped, 36, true)
    TaskMoveNetworkByName(ped, 'task_mp_pointing', 0.5, false, 'anim@mp_point', 24)
    RemoveAnimDict('anim@mp_point')
end

local function stopPointing(ped)
    RequestTaskMoveNetworkStateTransition(ped, 'Stop')
    SetPedConfigFlag(ped, 36, false)
    ClearPedSecondaryTask(ped)
end

function ResetOtherAnimsVals()
    PlayerVars.pointing = false

    if PlayerVars.handsUp then
        PlayerVars.handsUp = false
    end
end

if Config.Framework == 'esx' then
    AddEventHandler('esx:onPlayerDeath', ResetOtherAnimsVals)
end

RegisterCommand('+handsup', function()
    local playerPed = PlayerPedId()

    if not PlayerVars.isDead and IsPedOnFoot(playerPed) then
        if PlayerVars.pointing then
            PlayerVars.pointing = false
        end

        PlayerVars.handsUp = not PlayerVars.handsUp

        if PlayerVars.handsUp then
            LoadAnimDict('random@mugging3')
            TaskPlayAnim(playerPed, 'random@mugging3', 'handsup_standing_base', 8.0, -8.0, -1, 49, 0.0, false, false, false)
            RemoveAnimDict('random@mugging3')
        else
            StopAnimTask(playerPed, 'random@mugging3', 'handsup_standing_base', -4.0)
        end
    end
end, false)

RegisterCommand('-handsup', function() end, false)

RegisterKeyMapping('+handsup', 'Lever les mains', 'KEYBOARD', Config.Controls.HandsUP.keyboard)
TriggerEvent('chat:removeSuggestion', '/+handsup')
TriggerEvent('chat:removeSuggestion', '/-handsup')

RegisterCommand('+fingerpoint', function()
    local playerPed = PlayerPedId()

    if not PlayerVars.isDead and IsPedOnFoot(playerPed) then
        if PlayerVars.handsUp then
            PlayerVars.handsUp = false
        end

        PlayerVars.pointing = not PlayerVars.pointing

        if PlayerVars.pointing then
            startPointing(playerPed)
        else
            stopPointing(playerPed)
        end
    end
end, false)

RegisterCommand('-fingerpoint', function() end, false)

RegisterKeyMapping('+fingerpoint', 'Pointer du doigt', 'KEYBOARD', Config.Controls.Pointing.keyboard)
TriggerEvent('chat:removeSuggestion', '/+fingerpoint')
TriggerEvent('chat:removeSuggestion', '/-fingerpoint')

CreateThread(function()
    while true do
        Wait(0)
        local playerPed = PlayerPedId()

        DisableControlAction(0, Config.Controls.Crouch.keyboard, true)

        if IsDisabledControlJustReleased(0, Config.Controls.Crouch.keyboard) and IsUsingKeyboard(2) then
            if DoesEntityExist(playerPed) and not IsEntityDead(playerPed) and IsPedOnFoot(playerPed) then
                PlayerVars.crouched = not PlayerVars.crouched

                if PlayerVars.crouched then
                    LoadAnimSet('move_ped_crouched')
                    SetPedMovementClipset(playerPed, 'move_ped_crouched', 0.5)
                    RemoveAnimSet('move_ped_crouched')
                else
                    ResetPedMovementClipset(playerPed, 0.5)
                end
            end
        end

        if PlayerVars.crouched or PlayerVars.handsUp or PlayerVars.pointing then
            if not IsPedOnFoot(playerPed) then
                ResetPedMovementClipset(playerPed, 0.5)
                stopPointing()

                PlayerVars.crouched = false
                PlayerVars.pointing = false

                if PlayerVars.handsUp then
                    PlayerVars.handsUp = false
                end
            else
                if PlayerVars.pointing then
                    local camPitch = GetGameplayCamRelativePitch()
                    camPitch = (camPitch < -70.0 and -70.0) or (camPitch > 42.0 and 42.0) or camPitch
                    camPitch = (camPitch + 70.0) / 112.0

                    local camHeading = GetGameplayCamRelativeHeading()
                    local cosCamHeading, sinCamHeading = math.cos(camHeading * (math.pi / 180.0)), math.sin(camHeading * (math.pi / 180.0))

                    camHeading = (camHeading < -180.0 and -180.0) or (camHeading > 180.0 and 180.0) or camHeading
                    camHeading = (camHeading + 180.0) / 360.0

                    local coords = GetOffsetFromEntityInWorldCoords(playerPed, vec3((cosCamHeading * -0.2) - (sinCamHeading * (0.4 * camHeading + 0.3)), (sinCamHeading * -0.2) + (cosCamHeading * (0.4 * camHeading + 0.3)), 0.6))
                    local shapeTestHandle = StartShapeTestCapsule(coords - vec3(0.0, 0.0, 0.2), coords + vec3(0.0, 0.0, 0.2), 0.4, 95, playerPed, 7)

                    local shapeTestStatus, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(shapeTestHandle)
                    while shapeTestStatus == 1 do
                        Wait(0)
                        shapeTestStatus, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(shapeTestHandle)
                    end

                    SetTaskMoveNetworkSignalFloat(playerPed, 'Pitch', camPitch)
                    SetTaskMoveNetworkSignalFloat(playerPed, 'Heading', (camHeading * -1.0) + 1.0)
                    SetTaskMoveNetworkSignalBool(playerPed, 'isBlocked', shapeTestStatus == 2 and hit == 1)
                    SetTaskMoveNetworkSignalBool(playerPed, 'isFirstPerson', GetCamViewModeForContext(GetCamActiveViewModeContext()) == 4)
                end
            end
        end
    end
end)
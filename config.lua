local Keys = {
    ['ESC'] = 322, ['F1'] = 288, ['F2'] = 289, ['F3'] = 170, ['F5'] = 166, ['F6'] = 167, ['F7'] = 168, ['F8'] = 169, ['F9'] = 56, ['F10'] = 57,
    ['~'] = 243, ['1'] = 157, ['2'] = 158, ['3'] = 160, ['4'] = 164, ['5'] = 165, ['6'] = 159, ['7'] = 161, ['8'] = 162, ['9'] = 163, ['-'] = 84, ['='] = 83, ['BACKSPACE'] = 177,
    ['TAB'] = 37, ['Q'] = 44, ['W'] = 32, ['E'] = 38, ['R'] = 45, ['T'] = 245, ['Y'] = 246, ['U'] = 303, ['P'] = 199, ['['] = 39, [']'] = 40, ['ENTER'] = 18,
    ['CAPS'] = 137, ['A'] = 34, ['S'] = 8, ['D'] = 9, ['F'] = 23, ['G'] = 47, ['H'] = 74, ['K'] = 311, ['L'] = 182,
    ['LEFTSHIFT'] = 21, ['Z'] = 20, ['X'] = 73, ['C'] = 26, ['V'] = 0, ['B'] = 29, ['N'] = 249, ['M'] = 244, [','] = 82, ['.'] = 81,
    ['LEFTCTRL'] = 36, ['LEFTALT'] = 19, ['SPACE'] = 22, ['RIGHTCTRL'] = 70,
    ['HOME'] = 213, ['PAGEUP'] = 10, ['PAGEDOWN'] = 11, ['DELETE'] = 178,
    ['LEFT'] = 174, ['RIGHT'] = 175, ['TOP'] = 27, ['DOWN'] = 173,
    ['NENTER'] = 201, ['N4'] = 108, ['N5'] = 60, ['N6'] = 107, ['N+'] = 96, ['N-'] = 97, ['N7'] = 117, ['N8'] = 61, ['N9'] = 118
}

Config = {}

-- FRAMEWORK --
Config.Framework = 'esx' -- change it to 'qb' if you're using qbcore

-- LANGUAGE --
Config.Locale = 'en'

-- GENERAL --
Config.MenuTitle = 'ServerName' -- change it to you're server name
Config.DoubleJob = false -- enable if you're using esx double job
Config.NoclipSpeed = 1.0 -- change it to change the speed in noclip
Config.JSFourIDCard = false -- enable if you're using jsfour-idcard

-- CONTROLS --
Config.Controls = {
    OpenMenu = {keyboard = 'F5'},
    HandsUP = {keyboard = 'GRAVE'},
    Pointing = {keyboard = 'B'},
    Crouch = {keyboard = Keys['LEFTCTRL']},
    StopTasks = {keyboard = 'X'},
    TPMarker = {keyboard1 = Keys['LEFTALT'], keyboard2 = Keys['E']}
}

-- GPS --
Config.GPS = {
    {name = i18nU('none'), coords = nil},
    {name = i18nU('police_station'), coords = vec2(425.13, -979.55)},
    {name = i18nU('central_garage'), coords = vec2(-449.67, -340.83)},
    {name = i18nU('hospital'), coords = vec2(-33.88, -1102.37)},
    {name = i18nU('dealer'), coords = vec2(215.06, -791.56)},
    {name = i18nU('bennys_custom'), coords = vec2(-212.13, -1325.27)},
    {name = i18nU('job_center'), coords = vec2(-264.83, -964.54)},
    {name = i18nU('driving_school'), coords = vec2(-829.22, -696.99)},
    {name = i18nU('tequila-la'), coords = vec2(-565.09, 273.45)},
    {name = i18nU('bahama_mamas'), coords = vec2(-1391.06, -590.34)}
}

-- ANIMATIONS --
Config.Animations = {
    {
        name = 'party',
        name = i18nU('animation_party_title'),
        items = {
            {name = i18nU('animation_party_smoke'), type = "scenario", scenarioName = "WORLD_HUMAN_SMOKING"},
            {name = i18nU('animation_party_playsong'), type = "scenario", scenarioName = "WORLD_HUMAN_MUSICIAN"},
            {name = i18nU('animation_party_dj'), type = "anim", animDict = "anim@mp_player_intcelebrationmale@dj", animName = "dj"},
            {name = i18nU('animation_party_beer'), type = "scenario", scenarioName = "WORLD_HUMAN_DRINKING"},
            {name = i18nU('animation_party_dancing'), type = "scenario", scenarioName = "WORLD_HUMAN_PARTYING"},
            {name = i18nU('animation_party_airguitar'), type = "anim", animDict = "anim@mp_player_intcelebrationmale@air_guitar", animName = "air_guitar"},
            {name = i18nU('animation_party_shagging'), type = "anim", animDict = "anim@mp_player_intcelebrationfemale@air_shagging", animName = "air_shagging"},
            {name = i18nU('animation_party_rock'), type = "anim", animDict = "mp_player_int_upperrock", animName = "mp_player_int_rock"},
            {name = i18nU('animation_party_drunk'), type = "anim", animDict = "amb@world_human_bum_standing@drunk@idle_a", animName = "idle_a"},
            {name = i18nU('animation_party_vomit'), type = "anim", animDict = "oddjobs@taxi@tie", animName = "vomit_outside"}
        }
    },
    {
        name = 'salute',
        name = i18nU('animation_salute_title'),
        items = {
            {name = i18nU('animation_salute_saluate'), type = "anim", animDict = "gestures@m@standing@casual", animName = "gesture_hello"},
            {name = i18nU('animation_salute_serrer'), type = "anim", animDict = "mp_common", animName = "givetake1_a"},
            {name = i18nU('animation_salute_tchek'), type = "anim", animDict = "mp_ped_interaction", animName = "handshake_guy_a"},
            {name = i18nU('animation_salute_bandit'), type = "anim", animDict = "mp_ped_interaction", animName = "hugs_guy_a"},
            {name = i18nU('animation_salute_military'), type = "anim", animDict = "mp_player_int_uppersalute", animName = "mp_player_int_salute"}
        }
    },
    {
        name = 'work',
        name = i18nU('animation_work_title'),
        items = {
            {name = i18nU('animation_work_suspect'), type = "anim", animDict = "random@arrests@busted", animName = "idle_c"},
            {name = i18nU('animation_work_fisherman'), type = "scenario", scenarioName = "world_human_stand_fishing"},
            {name = i18nU('animation_work_inspect'), type = "anim", animDict = "amb@code_human_police_investigate@idle_b", animName = "idle_f"},
            {name = i18nU('animation_work_radio'), type = "anim", animDict = "random@arrests", animName = "generic_radio_chatter"},
            {name = i18nU('animation_work_circulation'), type = "scenario", scenarioName = "WORLD_HUMAN_CAR_PARK_ATTENDANT"},
            {name = i18nU('animation_work_binoculars'), type = "scenario", scenarioName = "WORLD_HUMAN_BINOCULARS"},
            {name = i18nU('animation_work_harvest'), type = "scenario", scenarioName = "world_human_gardener_plant"},
            {name = i18nU('animation_work_repair'), type = "anim", animDict = "mini@repair", animName = "fixing_a_ped"},
            {name = i18nU('animation_work_observe'), type = "scenario", scenarioName = "CODE_HUMAN_MEDIC_KNEEL"},
            {name = i18nU('animation_work_talk'), type = "anim", animDict = "oddjobs@taxi@driver", animName = "leanover_idle"},
            {name = i18nU('animation_work_bill'), type = "anim", animDict = "oddjobs@taxi@cyi", animName = "std_hand_off_ps_passenger"},
            {name = i18nU('animation_work_buy'), type = "anim", animDict = "mp_am_hold_up", animName = "purchase_beerbox_shopkeeper"},
            {name = i18nU('animation_work_shot'), type = "anim", animDict = "mini@drinking", animName = "shots_barman_b"},
            {name = i18nU('animation_work_picture'), type = "scenario", scenarioName = "WORLD_HUMAN_PAPARAZZI"},
            {name = i18nU('animation_work_notes'), type = "scenario", scenarioName = "WORLD_HUMAN_CLIPBOARD"},
            {name = i18nU('animation_work_hammer'), type = "scenario", scenarioName = "WORLD_HUMAN_HAMMERING"},
            {name = i18nU('animation_work_beg'), type = "scenario", scenarioName = "WORLD_HUMAN_BUM_FREEWAY"},
            {name = i18nU('animation_work_statue'), type = "scenario", scenarioName = "WORLD_HUMAN_HUMAN_STATUE"}
        }
    },
    {
        name = 'mood',
        name = i18nU('animation_mood_title'),
        items = {
            {name = i18nU('animation_mood_felicitate'), type = "scenario", scenarioName = "WORLD_HUMAN_CHEERING"},
            {name = i18nU('animation_mood_nice'), type = "anim", animDict = "mp_action", animName = "thanks_male_06"},
            {name = i18nU('animation_mood_you'), type = "anim", animDict = "gestures@m@standing@casual", animName = "gesture_point"},
            {name = i18nU('animation_mood_come'), type = "anim", animDict = "gestures@m@standing@casual", animName = "gesture_come_here_soft"},
            {name = i18nU('animation_mood_what'), type = "anim", animDict = "gestures@m@standing@casual", animName = "gesture_bring_it_on"},
            {name = i18nU('animation_mood_me'), type = "anim", animDict = "gestures@m@standing@casual", animName = "gesture_me"},
            {name = i18nU('animation_mood_seriously'), type = "anim", animDict = "anim@am_hold_up@male", animName = "shoplift_high"},
            {name = i18nU('animation_mood_tired'), type = "anim", animDict = "amb@world_human_jog_standing@male@idle_b", animName = "idle_d"},
            {name = i18nU('animation_mood_shit'), type = "anim", animDict = "amb@world_human_bum_standing@depressed@idle_a", animName = "idle_a"},
            {name = i18nU('animation_mood_facepalm'), type = "anim", animDict = "anim@mp_player_intcelebrationmale@face_palm", animName = "face_palm"},
            {name = i18nU('animation_mood_calm'), type = "anim", animDict = "gestures@m@standing@casual", animName = "gesture_easy_now"},
            {name = i18nU('animation_mood_why'), type = "anim", animDict = "oddjobs@assassinate@multi@", animName = "react_big_variations_a"},
            {name = i18nU('animation_mood_fear'), type = "anim", animDict = "amb@code_human_cower_stand@male@react_cowering", animName = "base_right"},
            {name = i18nU('animation_mood_fight'), type = "anim", animDict = "anim@deathmatch_intros@unarmed", animName = "intro_male_unarmed_e"},
            {name = i18nU('animation_mood_notpossible'), type = "anim", animDict = "gestures@m@standing@casual", animName = "gesture_damn"},
            {name = i18nU('animation_mood_embrace'), type = "anim", animDict = "mp_ped_interaction", animName = "kisses_guy_a"},
            {name = i18nU('animation_mood_fuckyou'), type = "anim", animDict = "mp_player_int_upperfinger", animName = "mp_player_int_finger_01_enter"},
            {name = i18nU('animation_mood_wanker'), type = "anim", animDict = "mp_player_int_upperwank", animName = "mp_player_int_wank_01"},
            {name = i18nU('animation_mood_suicide'), type = "anim", animDict = "mp_suicide", animName = "pistol"}
        }
    },
    {
        name = 'sports',
        name = i18nU('animation_sports_title'),
        items = {
            {name = i18nU('animation_sports_muscle'), type = "anim", animDict = "amb@world_human_muscle_flex@arms_at_side@base", animName = "base"},
            {name = i18nU('animation_sports_weightbar'), type = "anim", animDict = "amb@world_human_muscle_free_weights@male@barbell@base", animName = "base"},
            {name = i18nU('animation_sports_pushup'), type = "anim", animDict = "amb@world_human_push_ups@male@base", animName = "base"},
            {name = i18nU('animation_sports_abs'), type = "anim", animDict = "amb@world_human_sit_ups@male@base", animName = "base"},
            {name = i18nU('animation_sports_yoga'), type = "anim", animDict = "amb@world_human_yoga@male@base", animName = "base_a"}
        }
    },
    {
        name = 'other',
        name = i18nU('animation_other_title'),
        items = {
            {name = i18nU('animation_other_sit'), type = "anim", animDict = "anim@heists@prison_heistunfinished_biztarget_idle", animName = "target_idle"},
            {name = i18nU('animation_other_waitwall'), type = "scenario", scenarioName = "world_human_leaning"},
            {name = i18nU('animation_other_ontheback'), type = "scenario", scenarioName = "WORLD_HUMAN_SUNBATHE_BACK"},
            {name = i18nU('animation_other_stomach'), type = "scenario", scenarioName = "WORLD_HUMAN_SUNBATHE"},
            {name = i18nU('animation_other_clean'), type = "scenario", scenarioName = "world_human_maid_clean"},
            {name = i18nU('animation_other_cooking'), type = "scenario", scenarioName = "PROP_HUMAN_BBQ"},
            {name = i18nU('animation_other_search'), type = "anim", animDict = "mini@prostitutes@sexlow_veh", animName = "low_car_bj_to_prop_female"},
            {name = i18nU('animation_other_selfie'), type = "scenario", scenarioName = "world_human_tourist_mobile"},
            {name = i18nU('animation_other_door'), type = "anim", animDict = "mini@safe_cracking", animName = "idle_base"}
        }
    },
    {
        name = 'pegi',
        name = i18nU('animation_pegi_title'),
        items = {
            {name = i18nU('animation_pegi_hsuck'), type = "anim", animDict = "oddjobs@towing", animName = "m_blow_job_loop"},
            {name = i18nU('animation_pegi_fsuck'), type = "anim", animDict = "oddjobs@towing", animName = "f_blow_job_loop"},
            {name = i18nU('animation_pegi_hfuck'), type = "anim", animDict = "mini@prostitutes@sexlow_veh", animName = "low_car_sex_loop_player"},
            {name = i18nU('animation_pegi_ffuck'), type = "anim", animDict = "mini@prostitutes@sexlow_veh", animName = "low_car_sex_loop_female"},
            {name = i18nU('animation_pegi_scratch'), type = "anim", animDict = "mp_player_int_uppergrab_crotch", animName = "mp_player_int_grab_crotch"},
            {name = i18nU('animation_pegi_charm'), type = "anim", animDict = "mini@strip_club@idles@stripper", animName = "stripper_idle_02"},
            {name = i18nU('animation_pegi_golddigger'), type = "scenario", scenarioName = "WORLD_HUMAN_PROSTITUTE_HIGH_CLASS"},
            {name = i18nU('animation_pegi_breast'), type = "anim", animDict = "mini@strip_club@backroom@", animName = "stripper_b_backroom_idle_b"},
            {name = i18nU('animation_pegi_strip1'), type = "anim", animDict = "mini@strip_club@lap_dance@ld_girl_a_song_a_p1", animName = "ld_girl_a_song_a_p1_f"},
            {name = i18nU('animation_pegi_strip2'), type = "anim", animDict = "mini@strip_club@private_dance@part2", animName = "priv_dance_p2"},
            {name = i18nU('animation_pegi_stripfloor'), type = "anim", animDict = "mini@strip_club@private_dance@part3", animName = "priv_dance_p3"}
        }
    },
    {
        name = 'attitudes',
        name = i18nU('animation_attitudes_title'),
        items = {
            {name = "Normal", type = "attitude"},
            {name = "Confiant", type = "attitude", animSet = "move_m@confident"},
            {name = "Talons", type = "attitude", animSet = "move_f@heels@c"},
            {name = "Dépressif", type = "attitude", animSet = "move_m@depressed@a"},
            {name = "Dépressive", type = "attitude", animSet = "move_f@depressed@a"},
            {name = "Business", type = "attitude", animSet = "move_m@business@a"},
            {name = "Déterminé", type = "attitude", animSet = "move_m@brave@a"},
            {name = "Casual", type = "attitude", animSet = "move_m@casual@a"},
            {name = "Trop mange", type = "attitude", animSet = "move_m@fat@a"},
            {name = "Hipster", type = "attitude", animSet = "move_m@hipster@a"},
            {name = "Blesse", type = "attitude", animSet = "move_m@injured"},
            {name = "Intimide", type = "attitude", animSet = "move_m@hurry@a"},
            {name = "Hobo", type = "attitude", animSet = "move_m@hobo@a"},
            {name = "Malheureux", type = "attitude", animSet = "move_m@sad@a"},
            {name = "Muscle", type = "attitude", animSet = "move_m@muscle@a"},
            {name = "Choc", type = "attitude", animSet = "move_m@shocked@a"},
            {name = "Sombre", type = "attitude", animSet = "move_m@shadyped@a"},
            {name = "Fatigue", type = "attitude", animSet = "move_m@buzzed"},
            {name = "Pressee", type = "attitude", animSet = "move_m@hurry_butch@a"},
            {name = "Fièr", type = "attitude", animSet = "move_m@money"},
            {name = "Petite course", type = "attitude", animSet = "move_m@quick"},
            {name = "Mangeuse d'homme", type = "attitude", animSet = "move_f@maneater"},
            {name = "Impertinente", type = "attitude", animSet = "move_f@sassy"},
            {name = "Arrogante", type = "attitude", animSet = "move_f@arrogant@a"}
        }
    }
}

-- ADMIN --
Config.AdminCommands = {
    {
        id = 'goto',
        name = i18nU('admin_goto_button'),
        groups = {'_dev', 'owner', 'superadmin', 'admin', 'mod'},
        command = function()
            local targetServerId = KeyboardInput('PM_BOX_ID', i18nU('dialogbox_playerid'), '', 8)
            if not targetServerId then return end

            targetServerId = tonumber(targetServerId)
            if type(targetServerId) ~= 'number' then return end

            TriggerServerEvent('krz_personalmenu:Admin_BringS', GetPlayerServerId(PlayerId()), targetServerId)
            RageUI.CloseAll()
        end
    },
    {
        id = 'bring',
        name = i18nU('admin_bring_button'),
        groups = {'_dev', 'owner', 'superadmin', 'admin', 'mod'},
        command = function()
            local targetServerId = KeyboardInput('PM_BOX_ID', i18nU('dialogbox_playerid'), '', 8)
            if not targetServerId then return end

            targetServerId = tonumber(targetServerId)
            if type(targetServerId) ~= 'number' then return end

            TriggerServerEvent('krz_personalmenu:Admin_BringS', targetServerId, GetPlayerServerId(PlayerId()))
            RageUI.CloseAll()
        end
    },
    {
        id = 'tpxyz',
        name = i18nU('admin_tpxyz_button'),
        groups = {'_dev', 'owner', 'superadmin', 'admin'},
        command = function()
            local pos = KeyboardInput('PM_BOX_XYZ', i18nU('dialogbox_xyz'), '', 50)

            if pos ~= nil and pos ~= '' then
                local _, _, x, y, z = string.find(pos, '([%d%.]+) ([%d%.]+) ([%d%.]+)')

                if x ~= nil and y ~= nil and z ~= nil then
                    SetEntityCoords(plyPed, x + .0, y + .0, z + .0)
                end
            end

            RageUI.CloseAll()
        end
    },
    {
        id = 'noclip',
        name = i18nU('admin_noclip_button'),
        groups = {'_dev', 'owner', 'superadmin', 'admin', 'mod'},
        command = function()
            PlayerVars.noclip = not PlayerVars.noclip


            if PlayerVars.noclip then
                Citizen.CreateThreadNow(function()
                    while PlayerVars.noclip do
                        local plyPed = PlayerPedId()

                        FreezeEntityPosition(plyPed, true)
                        SetEntityInvincible(plyPed, true)
                        SetEntityCollision(plyPed, false, false)

                        SetEntityVisible(plyPed, false, false)

                        local playerId = PlayerId()
                        SetEveryoneIgnorePlayer(playerId, true)
                        SetPoliceIgnorePlayer(playerId, true)

                        local plyCoords = GetEntityCoords(plyPed, false)

                        local heading = GetGameplayCamRelativeHeading() + GetEntityPhysicsHeading(plyPed)
                        local pitch = GetGameplayCamRelativePitch()
                        local camCoords = vec3(-math.sin(heading * math.pi / 180.0), math.cos(heading * math.pi / 180.0), math.sin(pitch * math.pi / 180.0))

                        local len = math.sqrt((camCoords.x * camCoords.x) + (camCoords.y * camCoords.y) + (camCoords.z * camCoords.z))
                        if len ~= 0 then camCoords = camCoords / len end

                        SetEntityVelocity(plyPed, vec3(0))

                        local isShiftPressed, isCtrlPressed = IsControlPressed(0, 21), IsControlPressed(0, 326)

                        local noclipVelocity = isShiftPressed and isCtrlPressed and Config.NoclipSpeed
                            or isShiftPressed and Config.NoclipSpeed * 2.0
                            or isCtrlPressed and Config.NoclipSpeed / 2.0
                            or Config.NoclipSpeed

                        if IsControlPressed(0, 32) then plyCoords += noclipVelocity * camCoords end
                        if IsControlPressed(0, 269) then plyCoords -= noclipVelocity * camCoords end

                        SetEntityCoordsNoOffset(plyPed, plyCoords, true, true, true)

                        Wait(0)
                    end
                end)

                GameNotification(i18nU('admin_noclipon'))
            else
                local plyPed = PlayerPedId()

                FreezeEntityPosition(plyPed, false)
                SetEntityInvincible(plyPed, false)
                SetEntityCollision(plyPed, true, true)

                SetEntityVisible(plyPed, true, false)

                local playerId = PlayerId()
                SetEveryoneIgnorePlayer(playerId, false)
                SetPoliceIgnorePlayer(playerId, false)

                GameNotification(i18nU('admin_noclipoff'))
            end

            RageUI.CloseAll()
        end
    },
    {
        id = 'godmode',
        name = i18nU('admin_godmode_button'),
        groups = {'_dev', 'owner', 'superadmin'},
        command = function()
            PlayerVars.godmode = not PlayerVars.godmode

            if PlayerVars.godmode then
                SetEntityInvincible(plyPed, true)
                GameNotification(i18nU('admin_godmodeon'))
            else
                SetEntityInvincible(plyPed, false)
                GameNotification(i18nU('admin_godmodeoff'))
            end
        end
    },
    {
        id = 'ghostmode',
        name = i18nU('admin_ghostmode_button'),
        groups = {'_dev', 'owner', 'superadmin'},
        command = function()
            PlayerVars.ghostmode = not PlayerVars.ghostmode

            if PlayerVars.ghostmode then
                SetEntityVisible(plyPed, false, false)
                GameNotification(i18nU('admin_ghoston'))
            else
                SetEntityVisible(plyPed, true, false)
                GameNotification(i18nU('admin_ghostoff'))
            end
        end
    },
    {
        id = 'spawnveh',
        name = i18nU('admin_spawnveh_button'),
        groups = {'_dev', 'owner', 'superadmin'},
        command = function()
            local modelName = KeyboardInput('PM_BOX_VEHICLE_NAME', i18nU('dialogbox_vehiclespawner'), '', 50)
            if not modelName then return end

            modelName = tostring(modelName)
            if type(modelName) ~= 'string' then return end

            ESX.Game.SpawnVehicle(modelName, GetEntityCoords(plyPed), GetEntityHeading(plyPed), function(vehicle)
                TaskWarpPedIntoVehicle(plyPed, vehicle, -1)
            end)

            RageUI.CloseAll()
        end
    },
    {
        id = 'repairveh',
        name = i18nU('admin_repairveh_button'),
        groups = {'_dev', 'owner', 'superadmin', 'admin'},
        command = function()
            local plyVeh = GetVehiclePedIsIn(plyPed, false)
            SetVehicleFixed(plyVeh)
            SetVehicleDirtLevel(plyVeh, 0.0)
        end
    },
    {
        id = 'flipveh',
        name = i18nU('admin_flipveh_button'),
        groups = {'_dev', 'owner', 'superadmin', 'admin'},
        command = function()
            local plyCoords = GetEntityCoords(plyPed)
            local closestVeh = GetClosestVehicle(plyCoords, 10.0, 0, 70)

            SetVehicleOnGroundProperly(closestVeh)
            GameNotification(i18nU('admin_vehicleflip'))
        end
    },
    {
        id = 'givemoney',
        name = i18nU('admin_givemoney_button'),
        groups = {'_dev', 'owner', 'superadmin'},
        command = function()
            local amount = KeyboardInput('PM_BOX_AMOUNT', i18nU('dialogbox_amount'), '', 8)
            if not amount then return end

            amount = tonumber(amount)
            if type(amount) ~= 'number' then return end

            TriggerServerEvent('krz_personalmenu:Admin_giveCash', amount)
            RageUI.CloseAll()
        end
    },
    {
        id = 'givebank',
        name = i18nU('admin_givebank_button'),
        groups = {'_dev', 'owner', 'superadmin'},
        command = function()
            local amount = KeyboardInput('PM_BOX_AMOUNT', i18nU('dialogbox_amount'), '', 8)
            if not amount then return end

            amount = tonumber(amount)
            if type(amount) ~= 'number' then return end

            TriggerServerEvent('krz_personalmenu:Admin_giveBank', amount)
            RageUI.CloseAll()
        end
    },
    {
        id = 'givedirtymoney',
        name = i18nU('admin_givedirtymoney_button'),
        groups = {'_dev', 'owner', 'superadmin'},
        command = function()
            local amount = KeyboardInput('PM_BOX_AMOUNT', i18nU('dialogbox_amount'), '', 8)
            if not amount then return end

            amount = tonumber(amount)
            if type(amount) ~= 'number' then return end

            TriggerServerEvent('krz_personalmenu:Admin_giveDirtyMoney', amount)
            RageUI.CloseAll()
        end
    },
    {
        id = 'showxyz',
        name = i18nU('admin_showxyz_button'),
        groups = {'_dev', 'owner', 'superadmin', 'admin', 'mod'},
        command = function()
            PlayerVars.showCoords = not PlayerVars.showCoords
        end
    },
    {
        id = 'showname',
        name = i18nU('admin_showname_button'),
        groups = {'_dev', 'owner', 'superadmin', 'admin', 'mod'},
        command = function()
            PlayerVars.showName = not PlayerVars.showName

            if not PlayerVars.showName then
                for i = 1, #activeTags do
                    local tag = activeTags[i]

                    if IsMpGamerTagActive(tag.handle) then
                        RemoveMpGamerTag(tag.handle)
                    end
                end

                activeTags = {}
                table.wipe(activeTagsMutex)
            end
        end
    },
    {
        id = 'tpmarker',
        name = i18nU('admin_tpmarker_button'),
        groups = {'_dev', 'owner', 'superadmin', 'admin'},
        command = function()
            tpMarker()
        end
    },
    {
        id = 'revive',
        name = i18nU('admin_revive_button'),
        groups = {'_dev', 'owner', 'superadmin', 'admin'},
        command = function()
            local targetServerId = KeyboardInput('PM_BOX_ID', i18nU('dialogbox_playerid'), '', 8)
            if not targetServerId then return end

            targetServerId = tonumber(targetServerId)
            if type(targetServerId) ~= 'number' then return end

            TriggerServerEvent('esx_ambulancejob:revive', targetServerId)
            RageUI.CloseAll()
        end
    },
    {
        id = 'changeskin',
        name = i18nU('admin_changeskin_button'),
        groups = {'_dev', 'owner', 'superadmin'},
        command = function()
            RageUI.CloseAll()
            Wait(100)
            TriggerEvent('esx_skin:openSaveableMenu')
        end
    },
    {
        id = 'saveskin',
        name = i18nU('admin_saveskin_button'),
        groups = {'_dev', 'owner', 'superadmin'},
        command = function()
            TriggerEvent('esx_skin:requestSaveSkin')
        end
    }
}

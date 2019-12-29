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

-- LANGUAGE --
Config.Locale = 'fr'

-- GENERAL --
Config.MenuTitle = 'ServerName' -- change it to you're server name
Config.DoubleJob = false -- enable if you're using esx double job
Config.NoclipSpeed = 1.0 -- change it to change the speed in noclip
Config.JSFourIDCard = false -- enable if you're using jsfour-idcard

-- CONTROLS --
Config.Controls = {
	OpenMenu = {keyboard = Keys['F5']},
	HandsUP = {keyboard = Keys['~']},
	Pointing = {keyboard = Keys['B']},
	Crouch = {keyboard = Keys['LEFTCTRL']},
	StopTasks = {keyboard = Keys['X']},
	TPMarker = {keyboard1 = Keys['LEFTALT'], keyboard2 = Keys['E']}
}

-- GPS --
Config.GPS = {
	{label = 'Aucun', coords = nil},
	{label = 'Poste de Police', coords = vector2(425.13, -979.55)},
	{label = 'Garage Central', coords = vector2(-449.67, -340.83)},
	{label = 'Hôpital', coords = vector2(-33.88, -1102.37)},
	{label = 'Concessionnaire', coords = vector2(215.06, -791.56)},
	{label = 'Benny\'s Custom', coords = vector2(-212.13, -1325.27)},
	{label = 'Pôle Emploie', coords = vector2(-264.83, -964.54)},
	{label = 'Auto école', coords = vector2(-829.22, -696.99)},
	{label = 'Téquila-la', coords = vector2(-565.09, 273.45)},
	{label = 'Bahama Mamas', coords = vector2(-1391.06, -590.34)}
}

-- VOICE --
Config.Voice = {
	activated = true,
	defaultLevel = 8.0
}

Config.Voice.items = {
	{label = _U('voice_whisper'), level = 3.0},
	{label = _U('voice_normal'), level = Config.Voice.defaultLevel},
	{label = _U('voice_cry'), level = 14.0}
}

-- ANIMATIONS --
Config.Animations = {
	{
		name = 'party',
		label = _U('animation_party_title'),
		items = {
			{label = _U('animation_party_smoke'), type = "scenario", data = {anim = "WORLD_HUMAN_SMOKING"}},
			{label = _U('animation_party_playsong'), type = "scenario", data = {anim = "WORLD_HUMAN_MUSICIAN"}},
			{label = _U('animation_party_dj'), type = "anim", data = {lib = "anim@mp_player_intcelebrationmale@dj", anim = "dj"}},
			{label = _U('animation_party_beer'), type = "scenario", data = {anim = "WORLD_HUMAN_DRINKING"}},
			{label = _U('animation_party_dancing'), type = "scenario", data = {anim = "WORLD_HUMAN_PARTYING"}},
			{label = _U('animation_party_airguitar'), type = "anim", data = {lib = "anim@mp_player_intcelebrationmale@air_guitar", anim = "air_guitar"}},
			{label = _U('animation_party_shagging'), type = "anim", data = {lib = "anim@mp_player_intcelebrationfemale@air_shagging", anim = "air_shagging"}},
			{label = _U('animation_party_rock'), type = "anim", data = {lib = "mp_player_int_upperrock", anim = "mp_player_int_rock"}},
			{label = _U('animation_party_drunk'), type = "anim", data = {lib = "amb@world_human_bum_standing@drunk@idle_a", anim = "idle_a"}},
			{label = _U('animation_party_vomit'), type = "anim", data = {lib = "oddjobs@taxi@tie", anim = "vomit_outside"}}
		}
	},
	{
		name = 'salute',
		label = _U('animation_salute_title'),
		items = {
			{label = _U('animation_salute_saluate'), type = "anim", data = {lib = "gestures@m@standing@casual", anim = "gesture_hello"}},
			{label = _U('animation_salute_serrer'), type = "anim", data = {lib = "mp_common", anim = "givetake1_a"}},
			{label = _U('animation_salute_tchek'), type = "anim", data = {lib = "mp_ped_interaction", anim = "handshake_guy_a"}},
			{label = _U('animation_salute_bandit'), type = "anim", data = {lib = "mp_ped_interaction", anim = "hugs_guy_a"}},
			{label = _U('animation_salute_military'), type = "anim", data = {lib = "mp_player_int_uppersalute", anim = "mp_player_int_salute"}}
		}
	},
	{
		name = 'work',
		label = _U('animation_work_title'),
		items = {
			{label = _U('animation_work_suspect'), type = "anim", data = {lib = "random@arrests@busted", anim = "idle_c"}},
			{label = _U('animation_work_fisherman'), type = "scenario", data = {anim = "world_human_stand_fishing"}},
			{label = _U('animation_work_inspect'), type = "anim", data = {lib = "amb@code_human_police_investigate@idle_b", anim = "idle_f"}},
			{label = _U('animation_work_radio'), type = "anim", data = {lib = "random@arrests", anim = "generic_radio_chatter"}},
			{label = _U('animation_work_circulation'), type = "scenario", data = {anim = "WORLD_HUMAN_CAR_PARK_ATTENDANT"}},
			{label = _U('animation_work_binoculars'), type = "scenario", data = {anim = "WORLD_HUMAN_BINOCULARS"}},
			{label = _U('animation_work_harvest'), type = "scenario", data = {anim = "world_human_gardener_plant"}},
			{label = _U('animation_work_repair'), type = "anim", data = {lib = "mini@repair", anim = "fixing_a_ped"}},
			{label = _U('animation_work_observe'), type = "scenario", data = {anim = "CODE_HUMAN_MEDIC_KNEEL"}},
			{label = _U('animation_work_talk'), type = "anim", data = {lib = "oddjobs@taxi@driver", anim = "leanover_idle"}},
			{label = _U('animation_work_bill'), type = "anim", data = {lib = "oddjobs@taxi@cyi", anim = "std_hand_off_ps_passenger"}},
			{label = _U('animation_work_buy'), type = "anim", data = {lib = "mp_am_hold_up", anim = "purchase_beerbox_shopkeeper"}},
			{label = _U('animation_work_shot'), type = "anim", data = {lib = "mini@drinking", anim = "shots_barman_b"}},
			{label = _U('animation_work_picture'), type = "scenario", data = {anim = "WORLD_HUMAN_PAPARAZZI"}},
			{label = _U('animation_work_notes'), type = "scenario", data = {anim = "WORLD_HUMAN_CLIPBOARD"}},
			{label = _U('animation_work_hammer'), type = "scenario", data = {anim = "WORLD_HUMAN_HAMMERING"}},
			{label = _U('animation_work_beg'), type = "scenario", data = {anim = "WORLD_HUMAN_BUM_FREEWAY"}},
			{label = _U('animation_work_statue'), type = "scenario", data = {anim = "WORLD_HUMAN_HUMAN_STATUE"}}
		}
	},
	{
		name = 'mood',
		label = _U('animation_mood_title'),
		items = {
			{label = _U('animation_mood_felicitate'), type = "scenario", data = {anim = "WORLD_HUMAN_CHEERING"}},
			{label = _U('animation_mood_nice'), type = "anim", data = {lib = "mp_action", anim = "thanks_male_06"}},
			{label = _U('animation_mood_you'), type = "anim", data = {lib = "gestures@m@standing@casual", anim = "gesture_point"}},
			{label = _U('animation_mood_come'), type = "anim", data = {lib = "gestures@m@standing@casual", anim = "gesture_come_here_soft"}}, 
			{label = _U('animation_mood_what'), type = "anim", data = {lib = "gestures@m@standing@casual", anim = "gesture_bring_it_on"}},
			{label = _U('animation_mood_me'), type = "anim", data = {lib = "gestures@m@standing@casual", anim = "gesture_me"}},
			{label = _U('animation_mood_seriously'), type = "anim", data = {lib = "anim@am_hold_up@male", anim = "shoplift_high"}},
			{label = _U('animation_mood_tired'), type = "scenario", data = {lib = "amb@world_human_jog_standing@male@idle_b", anim = "idle_d"}},
			{label = _U('animation_mood_shit'), type = "scenario", data = {lib = "amb@world_human_bum_standing@depressed@idle_a", anim = "idle_a"}},
			{label = _U('animation_mood_facepalm'), type = "anim", data = {lib = "anim@mp_player_intcelebrationmale@face_palm", anim = "face_palm"}},
			{label = _U('animation_mood_calm'), type = "anim", data = {lib = "gestures@m@standing@casual", anim = "gesture_easy_now"}},
			{label = _U('animation_mood_why'), type = "anim", data = {lib = "oddjobs@assassinate@multi@", anim = "react_big_variations_a"}},
			{label = _U('animation_mood_fear'), type = "anim", data = {lib = "amb@code_human_cower_stand@male@react_cowering", anim = "base_right"}},
			{label = _U('animation_mood_fight'), type = "anim", data = {lib = "anim@deathmatch_intros@unarmed", anim = "intro_male_unarmed_e"}},
			{label = _U('animation_mood_notpossible'), type = "anim", data = {lib = "gestures@m@standing@casual", anim = "gesture_damn"}},
			{label = _U('animation_mood_embrace'), type = "anim", data = {lib = "mp_ped_interaction", anim = "kisses_guy_a"}},
			{label = _U('animation_mood_fuckyou'), type = "anim", data = {lib = "mp_player_int_upperfinger", anim = "mp_player_int_finger_01_enter"}},
			{label = _U('animation_mood_wanker'), type = "anim", data = {lib = "mp_player_int_upperwank", anim = "mp_player_int_wank_01"}},
			{label = _U('animation_mood_suicide'), type = "anim", data = {lib = "mp_suicide", anim = "pistol"}}
		}
	},
	{
		name = 'sports',
		label = _U('animation_sports_title'),
		items = {
			{label = _U('animation_sports_muscle'), type = "anim", data = {lib = "amb@world_human_muscle_flex@arms_at_side@base", anim = "base"}},
			{label = _U('animation_sports_weightbar'), type = "anim", data = {lib = "amb@world_human_muscle_free_weights@male@barbell@base", anim = "base"}},
			{label = _U('animation_sports_pushup'), type = "anim", data = {lib = "amb@world_human_push_ups@male@base", anim = "base"}},
			{label = _U('animation_sports_abs'), type = "anim", data = {lib = "amb@world_human_sit_ups@male@base", anim = "base"}},
			{label = _U('animation_sports_yoga'), type = "anim", data = {lib = "amb@world_human_yoga@male@base", anim = "base_a"}}
		}
	},
	{
		name = 'other',
		label = _U('animation_other_title'),
		items = {
			{label = _U('animation_other_sit'), type = "anim", data = {lib = "anim@heists@prison_heistunfinished_biztarget_idle", anim = "target_idle"}},
			{label = _U('animation_other_waitwall'), type = "scenario", data = {anim = "world_human_leaning"}},
			{label = _U('animation_other_ontheback'), type = "scenario", data = {anim = "WORLD_HUMAN_SUNBATHE_BACK"}},
			{label = _U('animation_other_stomach'), type = "scenario", data = {anim = "WORLD_HUMAN_SUNBATHE"}},
			{label = _U('animation_other_clean'), type = "scenario", data = {anim = "world_human_maid_clean"}},
			{label = _U('animation_other_cooking'), type = "scenario", data = {anim = "PROP_HUMAN_BBQ"}},
			{label = _U('animation_other_search'), type = "anim", data = {lib = "mini@prostitutes@sexlow_veh", anim = "low_car_bj_to_prop_female"}},
			{label = _U('animation_other_selfie'), type = "scenario", data = {anim = "world_human_tourist_mobile"}},
			{label = _U('animation_other_door'), type = "anim", data = {lib = "mini@safe_cracking", anim = "idle_base"}}
		}
	},
	{
		name = 'pegi',
		label = _U('animation_pegi_title'),
		items = {
			{label = _U('animation_pegi_hsuck'), type = "anim", data = {lib = "oddjobs@towing", anim = "m_blow_job_loop"}},
			{label = _U('animation_pegi_fsuck'), type = "anim", data = {lib = "oddjobs@towing", anim = "f_blow_job_loop"}},
			{label = _U('animation_pegi_hfuck'), type = "anim", data = {lib = "mini@prostitutes@sexlow_veh", anim = "low_car_sex_loop_player"}},
			{label = _U('animation_pegi_ffuck'), type = "anim", data = {lib = "mini@prostitutes@sexlow_veh", anim = "low_car_sex_loop_female"}},
			{label = _U('animation_pegi_scratch'), type = "anim", data = {lib = "mp_player_int_uppergrab_crotch", anim = "mp_player_int_grab_crotch"}},
			{label = _U('animation_pegi_charm'), type = "anim", data = {lib = "mini@strip_club@idles@stripper", anim = "stripper_idle_02"}},
			{label = _U('animation_pegi_golddigger'), type = "scenario", data = {anim = "WORLD_HUMAN_PROSTITUTE_HIGH_CLASS"}},
			{label = _U('animation_pegi_breast'), type = "anim", data = {lib = "mini@strip_club@backroom@", anim = "stripper_b_backroom_idle_b"}},
			{label = _U('animation_pegi_strip1'), type = "anim", data = {lib = "mini@strip_club@lap_dance@ld_girl_a_song_a_p1", anim = "ld_girl_a_song_a_p1_f"}},
			{label = _U('animation_pegi_strip2'), type = "anim", data = {lib = "mini@strip_club@private_dance@part2", anim = "priv_dance_p2"}},
			{label = _U('animation_pegi_stripfloor'), type = "anim", data = {lib = "mini@strip_club@private_dance@part3", anim = "priv_dance_p3"}}
		}
	},
	{
		name = 'attitudes',
		label = _U('animation_attitudes_title'),
		items = {
			{label = "Normal M", type = "attitude", data = {lib = "move_m@confident", anim = "move_m@confident"}},
			{label = "Normal F", type = "attitude", data = {lib = "move_f@heels@c", anim = "move_f@heels@c"}},
			{label = "Depressif", type = "attitude", data = {lib = "move_m@depressed@a", anim = "move_m@depressed@a"}},
			{label = "Depressif F", type = "attitude", data = {lib = "move_f@depressed@a", anim = "move_f@depressed@a"}},
			{label = "Business", type = "attitude", data = {lib = "move_m@business@a", anim = "move_m@business@a"}},
			{label = "Determine", type = "attitude", data = {lib = "move_m@brave@a", anim = "move_m@brave@a"}},
			{label = "Casual", type = "attitude", data = {lib = "move_m@casual@a", anim = "move_m@casual@a"}},
			{label = "Trop mange", type = "attitude", data = {lib = "move_m@fat@a", anim = "move_m@fat@a"}},
			{label = "Hipster", type = "attitude", data = {lib = "move_m@hipster@a", anim = "move_m@hipster@a"}},
			{label = "Blesse", type = "attitude", data = {lib = "move_m@injured", anim = "move_m@injured"}},
			{label = "Intimide", type = "attitude", data = {lib = "move_m@hurry@a", anim = "move_m@hurry@a"}},
			{label = "Hobo", type = "attitude", data = {lib = "move_m@hobo@a", anim = "move_m@hobo@a"}},
			{label = "Malheureux", type = "attitude", data = {lib = "move_m@sad@a", anim = "move_m@sad@a"}},
			{label = "Muscle", type = "attitude", data = {lib = "move_m@muscle@a", anim = "move_m@muscle@a"}},
			{label = "Choc", type = "attitude", data = {lib = "move_m@shocked@a", anim = "move_m@shocked@a"}},
			{label = "Sombre", type = "attitude", data = {lib = "move_m@shadyped@a", anim = "move_m@shadyped@a"}},
			{label = "Fatigue", type = "attitude", data = {lib = "move_m@buzzed", anim = "move_m@buzzed"}},
			{label = "Pressee", type = "attitude", data = {lib = "move_m@hurry_butch@a", anim = "move_m@hurry_butch@a"}},
			{label = "Fier", type = "attitude", data = {lib = "move_m@money", anim = "move_m@money"}},
			{label = "Petite course", type = "attitude", data = {lib = "move_m@quick", anim = "move_m@quick"}},
			{label = "Mangeuse d'homme", type = "attitude", data = {lib = "move_f@maneater", anim = "move_f@maneater"}},
			{label = "Impertinent", type = "attitude", data = {lib = "move_f@sassy", anim = "move_f@sassy"}},
			{label = "Arrogante", type = "attitude", data = {lib = "move_f@arrogant@a", anim = "move_f@arrogant@a"}}
		}
	}
}

-- ADMIN --
Config.Admin = {
	{
		name = 'goto',
		label = _U('admin_goto_button'),
		groups = {'_dev', 'owner', 'superadmin', 'admin', 'mod'},
		command = function()
			local plyId = KeyboardInput('KORIOZ_BOX_ID', _U('dialogbox_playerid'), '', 8)

			if plyId ~= nil then
				plyId = tonumber(plyId)
				
				if type(plyId) == 'number' then
					local targetPlyCoords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(plyId)))
					SetEntityCoords(plyPed, targetPlyCoords)
				end
			end

			RageUI.CloseAll()
		end
	},
	{
		name = 'bring',
		label = _U('admin_bring_button'),
		groups = {'_dev', 'owner', 'superadmin', 'admin', 'mod'},
		command = function()
			local plyId = KeyboardInput('KORIOZ_BOX_ID', _U('dialogbox_playerid'), '', 8)

			if plyId ~= nil then
				plyId = tonumber(plyId)
				
				if type(plyId) == 'number' then
					local plyPedCoords = GetEntityCoords(plyPed)
					TriggerServerEvent('KorioZ-PersonalMenu:Admin_BringS', plyId, plyPedCoords)
				end
			end

			RageUI.CloseAll()
		end
	},
	{
		name = 'tpxyz',
		label = _U('admin_tpxyz_button'),
		groups = {'_dev', 'owner', 'superadmin', 'admin'},
		command = function()
			local pos = KeyboardInput('KORIOZ_BOX_XYZ', _U('dialogbox_xyz'), '', 50)

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
		name = 'noclip',
		label = _U('admin_noclip_button'),
		groups = {'_dev', 'owner', 'superadmin', 'admin', 'mod'},
		command = function()
			Player.noclip = not Player.noclip

			if Player.noclip then
				FreezeEntityPosition(plyPed, true)
				SetEntityInvincible(plyPed, true)
				SetEntityCollision(plyPed, false, false)

				SetEntityVisible(plyPed, false, false)

				SetEveryoneIgnorePlayer(PlayerId(), true)
				SetPoliceIgnorePlayer(PlayerId(), true)
				ESX.ShowNotification(_U('admin_noclipon'))
			else
				FreezeEntityPosition(plyPed, false)
				SetEntityInvincible(plyPed, false)
				SetEntityCollision(plyPed, true, true)

				SetEntityVisible(plyPed, true, false)

				SetEveryoneIgnorePlayer(PlayerId(), false)
				SetPoliceIgnorePlayer(PlayerId(), false)
				ESX.ShowNotification(_U('admin_noclipoff'))
			end

			RageUI.CloseAll()
		end
	},
	{
		name = 'godmode',
		label = _U('admin_godmode_button'),
		groups = {'_dev', 'owner', 'superadmin'},
		command = function()
			godmode = not godmode

			if godmode then
				SetEntityInvincible(plyPed, true)
				ESX.ShowNotification(_U('admin_godmodeon'))
			else
				SetEntityInvincible(plyPed, false)
				ESX.ShowNotification(_U('admin_godmodeoff'))
			end
		end
	},
	{
		name = 'ghostmode',
		label = _U('admin_ghostmode_button'),
		groups = {'_dev', 'owner', 'superadmin'},
		command = function()
			invisible = not invisible

			if invisible then
				SetEntityVisible(plyPed, false, false)
				ESX.ShowNotification(_U('admin_ghoston'))
			else
				SetEntityVisible(plyPed, true, false)
				ESX.ShowNotification(_U('admin_ghostoff'))
			end
		end
	},
	{
		name = 'spawnveh',
		label = _U('admin_spawnveh_button'),
		groups = {'_dev', 'owner', 'superadmin'},
		command = function()
			local plyVeh = GetVehiclePedIsIn(plyPed, false)
			SetVehicleFixed(plyVeh)
			SetVehicleDirtLevel(plyVeh, 0.0)
			RageUI.CloseAll()
		end
	},
	{
		name = 'repairveh',
		label = _U('admin_repairveh_button'),
		groups = {'_dev', 'owner', 'superadmin', 'admin'},
		command = function()
			local modelName = KeyboardInput('KORIOZ_BOX_VEHICLE_NAME', _U('dialogbox_vehiclespawner'), '', 50)

			if modelName ~= nil then
				modelName = tostring(modelName)

				if type(modelName) == 'string' then
					ESX.Game.SpawnVehicle(modelName, GetEntityCoords(plyPed), GetEntityHeading(plyPed), function(vehicle)
						TaskWarpPedIntoVehicle(plyPed, vehicle, -1)
					end)
				end
			end
		end
	},
	{
		name = 'flipveh',
		label = _U('admin_flipveh_button'),
		groups = {'_dev', 'owner', 'superadmin', 'admin'},
		command = function()
			local plyCoords = GetEntityCoords(plyPed)
			local newCoords = plyCoords + vector3(0.0, 2.0, 0.0)
			local closestVeh = GetClosestVehicle(plyCoords, 10.0, 0, 70)

			SetEntityCoords(closestVeh, newCoords)
			ESX.ShowNotification(_U('admin_vehicleflip'))
		end
	},
	{
		name = 'givemoney',
		label = _U('admin_givemoney_button'),
		groups = {'_dev', 'owner', 'superadmin'},
		command = function()
			local amount = KeyboardInput('KORIOZ_BOX_AMOUNT', _U('dialogbox_amount'), '', 8)

			if amount ~= nil then
				amount = tonumber(amount)

				if type(amount) == 'number' then
					TriggerServerEvent('KorioZ-PersonalMenu:Admin_giveCash', amount)
				end
			end

			RageUI.CloseAll()
		end
	},
	{
		name = 'givebank',
		label = _U('admin_givebank_button'),
		groups = {'_dev', 'owner', 'superadmin'},
		command = function()
			local amount = KeyboardInput('KORIOZ_BOX_AMOUNT', _U('dialogbox_amount'), '', 8)

			if amount ~= nil then
				amount = tonumber(amount)

				if type(amount) == 'number' then
					TriggerServerEvent('KorioZ-PersonalMenu:Admin_giveBank', amount)
				end
			end

			RageUI.CloseAll()
		end
	},
	{
		name = 'givedirtymoney',
		label = _U('admin_givedirtymoney_button'),
		groups = {'_dev', 'owner', 'superadmin'},
		command = function()
			local amount = KeyboardInput('KORIOZ_BOX_AMOUNT', _U('dialogbox_amount'), '', 8)

			if amount ~= nil then
				amount = tonumber(amount)

				if type(amount) == 'number' then
					TriggerServerEvent('KorioZ-PersonalMenu:Admin_giveDirtyMoney', amount)
				end
			end

			RageUI.CloseAll()
		end
	},
	{
		name = 'showxyz',
		label = _U('admin_showxyz_button'),
		groups = {'_dev', 'owner', 'superadmin', 'admin', 'mod'},
		command = function()
			showcoord = not showcoord
		end
	},
	{
		name = 'showname',
		label = _U('admin_showname_button'),
		groups = {'_dev', 'owner', 'superadmin', 'admin', 'mod'},
		command = function()
			showname = not showname

			if not showname then
				for k, v in pairs(gamerTags) do
					RemoveMpGamerTag(v)
					gamerTags[k] = nil
				end
			end
		end
	},
	{
		name = 'tpmarker',
		label = _U('admin_tpmarker_button'),
		groups = {'_dev', 'owner', 'superadmin', 'admin'},
		command = function()
			local waypointHandle = GetFirstBlipInfoId(8)

			if DoesBlipExist(waypointHandle) then
				Citizen.CreateThread(function()
					local waypointCoords = GetBlipInfoIdCoord(waypointHandle)
					local foundGround, zCoords, zPos = false, -500.0, 0.0

					while not foundGround do
						zCoords = zCoords + 10.0
						RequestCollisionAtCoord(waypointCoords.x, waypointCoords.y, zCoords)
						Citizen.Wait(0)
						foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords.x, waypointCoords.y, zCoords)

						if not foundGround and zCoords >= 2000.0 then
							foundGround = true
						end
					end

					SetPedCoordsKeepVehicle(plyPed, waypointCoords.x, waypointCoords.y, zPos)
					ESX.ShowNotification(_U('admin_tpmarker'))
				end)
			else
				ESX.ShowNotification(_U('admin_nomarker'))
			end
		end
	},
	{
		name = 'revive',
		label = _U('admin_revive_button'),
		groups = {'_dev', 'owner', 'superadmin', 'admin'},
		command = function()
			local plyId = KeyboardInput('KORIOZ_BOX_ID', _U('dialogbox_playerid'), '', 8)

			if plyId ~= nil then
				plyId = tonumber(plyId)
				
				if type(plyId) == 'number' then
					TriggerServerEvent('esx_ambulancejob:revive', plyId)
				end
			end

			RageUI.CloseAll()
		end
	},
	{
		name = 'changeskin',
		label = _U('admin_changeskin_button'),
		groups = {'_dev', 'owner', 'superadmin'},
		command = function()
			RageUI.CloseAll()
			Citizen.Wait(100)
			TriggerEvent('esx_skin:openSaveableMenu')
		end
	},
	{
		name = 'saveskin',
		label = _U('admin_saveskin_button'),
		groups = {'_dev', 'owner', 'superadmin'},
		command = function()
			TriggerEvent('esx_skin:requestSaveSkin')
		end
	}
}
print("^0======================================================================^7")
print("^0[^4Author^0] ^7:^0 ^0Korioz^7")
print("^0[^3Version^0] ^7:^0 ^02.0^7")
print("^0[^2Download^0] ^7:^0 ^5https://github.com/korioz/krz_personalmenu/releases^7")
print("^0[^1Issues^0] ^7:^0 ^5https://github.com/korioz/krz_personalmenu/issues^7")
print("^0======================================================================^7")

ESX = nil

local PersonalMenu = {
	ItemSelected = {},
	ItemIndex = {},
	WeaponData = {},
	WalletIndex = {},
	WalletList = {
		_U('wallet_option_give'),
		_U('wallet_option_drop')
	},
	BillData = {},
	ClothesButtons = {'torso', 'pants', 'shoes', 'bag', 'bproof'},
	AccessoriesButtons = {'Ears', 'Glasses', 'Helmet', 'Mask'},
	DoorState = {
		FrontLeft = false,
		FrontRight = false,
		BackLeft = false,
		BackRight = false,
		Hood = false,
		Trunk = false
	},
	DoorIndex = 1,
	DoorList = {
		_U('vehicle_door_frontleft'),
		_U('vehicle_door_frontright'),
		_U('vehicle_door_backleft'),
		_U('vehicle_door_backright')
	},
	GPSSelected = _U('default_gps'),
	GPSIndex = 1,
	GPSList = {},
	VoiceSelected = _U('default_voice'),
	VoiceIndex = 2,
	VoiceList = {
		_U('voice_whisper'),
		_U('voice_normal'),
		_U('voice_cry')
	},
	PlayerGroup = 'user'
}

local isDead, inAnim = false, false
local noclip, godmode, visible, gamerTags = false, false, false, {}
local societymoney, societymoney2 = nil, nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj)
			ESX = obj
		end)

		Citizen.Wait(10)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	if Config.DoubleJob then
		while ESX.GetPlayerData().job2 == nil do
			Citizen.Wait(10)
		end
	end

	ESX.PlayerData = ESX.GetPlayerData()

	while actualSkin == nil do
		TriggerEvent('skinchanger:getSkin', function(skin)
			actualSkin = skin
		end)

		Citizen.Wait(10)
	end

	RefreshMoney()

	if Config.DoubleJob then
		RefreshMoney2()
	end

	PersonalMenu.WeaponData = ESX.GetWeaponList()

	for i = 1, #PersonalMenu.WeaponData, 1 do
		if PersonalMenu.WeaponData[i].name == 'WEAPON_UNARMED' then
			PersonalMenu.WeaponData[i] = nil
		else
			PersonalMenu.WeaponData[i].hash = GetHashKey(PersonalMenu.WeaponData[i].name)
		end
	end

	RMenu.Add('rageui', 'personal', RageUI.CreateMenu(Config.MenuTitle, _U('mainmenu_subtitle'), 0, 0, 'commonmenu', 'interaction_bgd', 255, 255, 255, 255))

	RMenu.Add('personal', 'inventory', RageUI.CreateSubMenu(RMenu.Get('rageui', 'personal'), _U('inventory_title')))
	RMenu.Add('personal', 'loadout', RageUI.CreateSubMenu(RMenu.Get('rageui', 'personal'), _U('loadout_title')))
	RMenu.Add('personal', 'wallet', RageUI.CreateSubMenu(RMenu.Get('rageui', 'personal'), _U('wallet_title')))
	RMenu.Add('personal', 'billing', RageUI.CreateSubMenu(RMenu.Get('rageui', 'personal'), _U('bills_title')))
	RMenu.Add('personal', 'clothes', RageUI.CreateSubMenu(RMenu.Get('rageui', 'personal'), _U('clothes_title')))
	RMenu.Add('personal', 'accessories', RageUI.CreateSubMenu(RMenu.Get('rageui', 'personal'), _U('accessories_title')))
	RMenu.Add('personal', 'animation', RageUI.CreateSubMenu(RMenu.Get('rageui', 'personal'), _U('animation_title')))
	RMenu.Add('personal', 'vehicle', RageUI.CreateSubMenu(RMenu.Get('rageui', 'personal'), _U('vehicle_title')))
	RMenu.Add('personal', 'boss', RageUI.CreateSubMenu(RMenu.Get('rageui', 'personal'), _U('bossmanagement_title', ESX.PlayerData.job.label)))

	if Config.DoubleJob then
		RMenu.Add('personal', 'boss2', RageUI.CreateSubMenu(RMenu.Get('rageui', 'personal'), _U('bossmanagement2_title', ESX.PlayerData.job2.label)))
	end

	RMenu.Add('personal', 'admin', RageUI.CreateSubMenu(RMenu.Get('rageui', 'personal'), _U('admin_title')))

	RMenu.Add('inventory', 'actions', RageUI.CreateSubMenu(RMenu.Get('personal', 'inventory'), _U('inventory_actions_title')))
	RMenu.Get('inventory', 'actions').Closed = function()
		PersonalMenu.ItemSelected = nil
	end

	RMenu.Add('loadout', 'actions', RageUI.CreateSubMenu(RMenu.Get('personal', 'loadout'), _U('loadout_actions_title')))
	RMenu.Get('loadout', 'actions').Closed = function()
		PersonalMenu.ItemSelected = nil
	end

	for i = 1, #Config.Animations, 1 do
		RMenu.Add('animation', Config.Animations[i].name, RageUI.CreateSubMenu(RMenu.Get('personal', 'animation'), Config.Animations[i].label))
		RMenu.Get('animation', Config.Animations[i].name).Closed = function()
			PersonalMenu.ItemSelected = nil
		end
	end

	for i = 1, #Config.GPS, 1 do
		table.insert(PersonalMenu.GPSList, Config.GPS[i].label)
	end
end)

Citizen.CreateThread(function()
	local fixingVoice = true
	NetworkSetTalkerProximity(0.1)

	while true do
		NetworkSetTalkerProximity(8.0)

		if not fixingVoice then
			break
		end

		Citizen.Wait(10)
	end

	SetTimeout(10000, function()
		fixingVoice = false
	end)
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

AddEventHandler('esx:onPlayerDeath', function()
	isDead = true
	RageUI.CloseAll()
	ESX.UI.Menu.CloseAll()
end)

AddEventHandler('playerSpawned', function()
	isDead = false
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
	RefreshMoney()
end)

RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job2)
	ESX.PlayerData.job2 = job2
	RefreshMoney2()
end)

RegisterNetEvent('esx_addonaccount:setMoney')
AddEventHandler('esx_addonaccount:setMoney', function(society, money)
	if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' and 'society_' .. ESX.PlayerData.job.name == society then
		UpdateSocietyMoney(money)
	end
	if ESX.PlayerData.job2 ~= nil and ESX.PlayerData.job2.grade_name == 'boss' and 'society_' .. ESX.PlayerData.job2.name == society then
		UpdateSociety2Money(money)
	end
end)

-- Weapon Menu --
RegisterNetEvent('KorioZ-PersonalMenu:Weapon_addAmmoToPedC')
AddEventHandler('KorioZ-PersonalMenu:Weapon_addAmmoToPedC', function(value, quantity)
	local weaponHash = GetHashKey(value)

	if HasPedGotWeapon(plyPed, weaponHash, false) and value ~= 'WEAPON_UNARMED' then
		AddAmmoToPed(plyPed, value, quantity)
	end
end)

-- Admin Menu --
RegisterNetEvent('KorioZ-PersonalMenu:Admin_BringC')
AddEventHandler('KorioZ-PersonalMenu:Admin_BringC', function(plyPedCoords)
	SetEntityCoords(plyPed, plyPedCoords)
end)

function RefreshMoney()
	if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' then
		ESX.TriggerServerCallback('esx_society:getSocietyMoney', function(money)
			UpdateSocietyMoney(money)
		end, ESX.PlayerData.job.name)
	end
end

function RefreshMoney2()
	if ESX.PlayerData.job2 ~= nil and ESX.PlayerData.job2.grade_name == 'boss' then
		ESX.TriggerServerCallback('esx_society:getSocietyMoney', function(money)
			UpdateSociety2Money(money)
		end, ESX.PlayerData.job2.name)
	end
end

function UpdateSocietyMoney(money)
	societymoney = ESX.Math.GroupDigits(money)
end

function UpdateSociety2Money(money)
	societymoney2 = ESX.Math.GroupDigits(money)
end

--Message text joueur
function Text(text)
	SetTextColour(186, 186, 186, 255)
	SetTextFont(0)
	SetTextScale(0.378, 0.378)
	SetTextWrap(0.0, 1.0)
	SetTextCentre(false)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 205)
	BeginTextCommandDisplayText('STRING')
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandDisplayText(0.017, 0.977)
end

function KeyboardInput(entryTitle, textEntry, inputText, maxLength)
	AddTextEntry(entryTitle, textEntry)
	DisplayOnscreenKeyboard(1, entryTitle, '', inputText, '', '', '', maxLength)
	blockinput = true

	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
		Citizen.Wait(0)
	end

	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult()
		Citizen.Wait(500)
		blockinput = false
		return result
	else
		Citizen.Wait(500)
		blockinput = false
		return nil
	end
end

-- GOTO JOUEUR
function admin_tp_toplayer()
	local plyId = KeyboardInput('KORIOZ_BOX_ID', _U('dialogbox_playerid'), '', 8)

	if plyId ~= nil then
		plyId = tonumber(plyId)
		
		if type(plyId) == 'number' then
			local targetPlyCoords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(plyId)))
			SetEntityCoords(plyPed, targetPlyCoords)
		end
	end
end

-- TP UN JOUEUR A MOI
function admin_tp_playertome()
	local plyId = KeyboardInput('KORIOZ_BOX_ID', _U('dialogbox_playerid'), '', 8)

	if plyId ~= nil then
		plyId = tonumber(plyId)
		
		if type(plyId) == 'number' then
			local plyPedCoords = GetEntityCoords(plyPed)
			TriggerServerEvent('KorioZ-PersonalMenu:Admin_BringS', plyId, plyPedCoords)
		end
	end
end

-- TP A POSITION
function admin_tp_pos()
	local pos = KeyboardInput('KORIOZ_BOX_XYZ', _U('dialogbox_xyz'), '', 50)

	if pos ~= nil and pos ~= '' then
		local _, _, x, y, z = string.find(pos, '([%d%.]+) ([%d%.]+) ([%d%.]+)')
				
		if x ~= nil and y ~= nil and z ~= nil then
			SetEntityCoords(plyPed, x + .0, y + .0, z + .0)
		end
	end
end

-- NOCLIP 
function admin_no_clip()
	noclip = not noclip

	if noclip then
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
end

function getCamDirection()
	local heading = GetGameplayCamRelativeHeading() + GetEntityHeading(plyPed)
	local pitch = GetGameplayCamRelativePitch()
	local coords = vector3(-math.sin(heading * math.pi / 180.0), math.cos(heading * math.pi / 180.0), math.sin(pitch * math.pi / 180.0))
	local len = math.sqrt((coords.x * coords.x) + (coords.y * coords.y) + (coords.z * coords.z))

	if len ~= 0 then
		coords = coords / len
	end

	return coords
end

-- GOD MODE
function admin_godmode()
	godmode = not godmode

	if godmode then
		SetEntityInvincible(plyPed, true)
		ESX.ShowNotification(_U('admin_godmodeon'))
	else
		SetEntityInvincible(plyPed, false)
		ESX.ShowNotification(_U('admin_godmodeoff'))
	end
end

-- INVISIBLE
function admin_mode_fantome()
	invisible = not invisible

	if invisible then
		SetEntityVisible(plyPed, false, false)
		ESX.ShowNotification(_U('admin_ghoston'))
	else
		SetEntityVisible(plyPed, true, false)
		ESX.ShowNotification(_U('admin_ghostoff'))
	end
end

-- Réparer vehicule
function admin_vehicle_repair()
	local plyVeh = GetVehiclePedIsIn(plyPed, false)
	SetVehicleFixed(plyVeh)
	SetVehicleDirtLevel(plyVeh, 0.0)
end

-- Spawn vehicule
function admin_vehicle_spawn()
	local vehicleName = KeyboardInput('KORIOZ_BOX_VEHICLE_NAME', _U('dialogbox_vehiclespawner'), '', 50)

	if vehicleName ~= nil then
		vehicleName = tostring(vehicleName)

		if type(vehicleName) == 'string' then
			ESX.Game.SpawnVehicle(vehicleName, GetEntityCoords(plyPed), GetEntityHeading(plyPed), function(vehicle)
				TaskWarpPedIntoVehicle(plyPed, vehicle, -1)
			end)
		end
	end
end

-- flipVehicle
function admin_vehicle_flip()
	local plyCoords = GetEntityCoords(plyPed)
	local closestCar = GetClosestVehicle(plyCoords, 10.0, 0, 70)
	local plyCoords = plyCoords + vector3(0, 2, 0)

	SetEntityCoords(closestCar, plyCoords)
	ESX.ShowNotification(_U('admin_vehicleflip'))
end

-- GIVE DE L'ARGENT
function admin_give_money()
	local amount = KeyboardInput('KORIOZ_BOX_AMOUNT', _U('dialogbox_amount'), '', 8)

	if amount ~= nil then
		amount = tonumber(amount)

		if type(amount) == 'number' then
			TriggerServerEvent('KorioZ-PersonalMenu:Admin_giveCash', amount)
		end
	end
end

-- GIVE DE L'ARGENT EN BANQUE
function admin_give_bank()
	local amount = KeyboardInput('KORIOZ_BOX_AMOUNT', _U('dialogbox_amount'), '', 8)

	if amount ~= nil then
		amount = tonumber(amount)

		if type(amount) == 'number' then
			TriggerServerEvent('KorioZ-PersonalMenu:Admin_giveBank', amount)
		end
	end
end

-- GIVE DE L'ARGENT SALE
function admin_give_dirty()
	local amount = KeyboardInput('KORIOZ_BOX_AMOUNT', _U('dialogbox_amount'), '', 8)

	if amount ~= nil then
		amount = tonumber(amount)

		if type(amount) == 'number' then
			TriggerServerEvent('KorioZ-PersonalMenu:Admin_giveDirtyMoney', amount)
		end
	end
end

-- Afficher Coord
function admin_showcoord()
	showcoord = not showcoord
end

-- Afficher Nom
function admin_showname()
	showname = not showname

	if not showname then
		for k, v in pairs(gamerTags) do
			RemoveMpGamerTag(v)
			gamerTags[k] = nil
		end
	end
end

-- TP MARKER
function admin_tp_marker()
	local WaypointHandle = GetFirstBlipInfoId(8)

	if DoesBlipExist(WaypointHandle) then
		local waypointCoords = GetBlipInfoIdCoord(WaypointHandle)

		for i = -100, 1000, 1 do
			local foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords.x, waypointCoords.y, i + 0.0)

			if foundGround then
				SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords.x, waypointCoords.y, zPos)
				ESX.ShowNotification(_U('admin_tpmarker'))
				break
			end
		end
	else
		ESX.ShowNotification(_U('admin_nomarker'))
	end
end

-- HEAL JOUEUR
function admin_heal_player()
	local plyId = KeyboardInput('KORIOZ_BOX_ID', _U('dialogbox_playerid'), '', 8)

	if plyId ~= nil then
		plyId = tonumber(plyId)
		
		if type(plyId) == 'number' then
			TriggerServerEvent('esx_ambulancejob:revive', plyId)
		end
	end
end

function changer_skin()
	RageUI.CloseAll()
	Citizen.Wait(100)
	TriggerEvent('esx_skin:openSaveableMenu', source)
end

function save_skin()
	TriggerEvent('esx_skin:requestSaveSkin', source)
end

function startAttitude(lib, anim)
	Citizen.CreateThread(function()
		RequestAnimSet(anim)

		while not HasAnimSetLoaded(anim) do
			Citizen.Wait(0)
		end

		SetPedMotionBlur(plyPed, false)
		SetPedMovementClipset(plyPed, anim, true)
	end)
end

function startAnim(lib, anim)
	Citizen.CreateThread(function()
		ESX.Streaming.RequestAnimDict(lib, function()
			TaskPlayAnim(plyPed, lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
		end)
	end)
end

function startAnimAction(lib, anim)
	Citizen.CreateThread(function()
		ESX.Streaming.RequestAnimDict(lib, function()
			TaskPlayAnim(plyPed, lib, anim, 8.0, 1.0, -1, 49, 0, false, false, false)
		end)
	end)
end

function startScenario(anim)
	TaskStartScenarioInPlace(plyPed, anim, 0, false)
end

function setUniform(value, plyPed)
	ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
		TriggerEvent('skinchanger:getSkin', function(skina)
			if value == 'torso' then
				startAnimAction('clothingtie', 'try_tie_neutral_a')
				Citizen.Wait(1000)
				handsup, pointing = false, false
				ClearPedTasks(plyPed)

				if skin.torso_1 ~= skina.torso_1 then
					TriggerEvent('skinchanger:loadClothes', skina, {['torso_1'] = skin.torso_1, ['torso_2'] = skin.torso_2, ['tshirt_1'] = skin.tshirt_1, ['tshirt_2'] = skin.tshirt_2, ['arms'] = skin.arms})
				else
					TriggerEvent('skinchanger:loadClothes', skina, {['torso_1'] = 15, ['torso_2'] = 0, ['tshirt_1'] = 15, ['tshirt_2'] = 0, ['arms'] = 15})
				end
			elseif value == 'pants' then
				if skin.pants_1 ~= skina.pants_1 then
					TriggerEvent('skinchanger:loadClothes', skina, {['pants_1'] = skin.pants_1, ['pants_2'] = skin.pants_2})
				else
					if skin.sex == 0 then
						TriggerEvent('skinchanger:loadClothes', skina, {['pants_1'] = 61, ['pants_2'] = 1})
					else
						TriggerEvent('skinchanger:loadClothes', skina, {['pants_1'] = 15, ['pants_2'] = 0})
					end
				end
			elseif value == 'shoes' then
				if skin.shoes_1 ~= skina.shoes_1 then
					TriggerEvent('skinchanger:loadClothes', skina, {['shoes_1'] = skin.shoes_1, ['shoes_2'] = skin.shoes_2})
				else
					if skin.sex == 0 then
						TriggerEvent('skinchanger:loadClothes', skina, {['shoes_1'] = 34, ['shoes_2'] = 0})
					else
						TriggerEvent('skinchanger:loadClothes', skina, {['shoes_1'] = 35, ['shoes_2'] = 0})
					end
				end
			elseif value == 'bag' then
				if skin.bags_1 ~= skina.bags_1 then
					TriggerEvent('skinchanger:loadClothes', skina, {['bags_1'] = skin.bags_1, ['bags_2'] = skin.bags_2})
				else
					TriggerEvent('skinchanger:loadClothes', skina, {['bags_1'] = 0, ['bags_2'] = 0})
				end
			elseif value == 'bproof' then
				startAnimAction('clothingtie', 'try_tie_neutral_a')
				Citizen.Wait(1000)
				handsup, pointing = false, false
				ClearPedTasks(plyPed)

				if skin.bproof_1 ~= skina.bproof_1 then
					TriggerEvent('skinchanger:loadClothes', skina, {['bproof_1'] = skin.bproof_1, ['bproof_2'] = skin.bproof_2})
				else
					TriggerEvent('skinchanger:loadClothes', skina, {['bproof_1'] = 0, ['bproof_2'] = 0})
				end
			end
		end)
	end)
end

function SetUnsetAccessory(accessory)
	ESX.TriggerServerCallback('esx_accessories:get', function(hasAccessory, accessorySkin)
		local _accessory = (accessory):lower()

		if hasAccessory then
			TriggerEvent('skinchanger:getSkin', function(skin)
				local mAccessory = -1
				local mColor = 0

				if _accessory == 'ears' then
					startAnimAction('mini@ears_defenders', 'takeoff_earsdefenders_idle')
					Citizen.Wait(250)
					handsup, pointing = false, false
					ClearPedTasks(plyPed)
				elseif _accessory == 'glasses' then
					mAccessory = 0
					startAnimAction('clothingspecs', 'try_glasses_positive_a')
					Citizen.Wait(1000)
					handsup, pointing = false, false
					ClearPedTasks(plyPed)
				elseif _accessory == 'helmet' then
					startAnimAction('missfbi4', 'takeoff_mask')
					Citizen.Wait(1000)
					handsup, pointing = false, false
					ClearPedTasks(plyPed)
				elseif _accessory == 'mask' then
					mAccessory = 0
					startAnimAction('missfbi4', 'takeoff_mask')
					Citizen.Wait(850)
					handsup, pointing = false, false
					ClearPedTasks(plyPed)
				end

				if skin[_accessory .. '_1'] == mAccessory then
					mAccessory = accessorySkin[_accessory .. '_1']
					mColor = accessorySkin[_accessory .. '_2']
				end

				local accessorySkin = {}
				accessorySkin[_accessory .. '_1'] = mAccessory
				accessorySkin[_accessory .. '_2'] = mColor
				TriggerEvent('skinchanger:loadClothes', skin, accessorySkin)
			end)
		else
			if _accessory == 'ears' then
				ESX.ShowNotification(_U('accessories_no_ears'))
			elseif _accessory == 'glasses' then
				ESX.ShowNotification(_U('accessories_no_glasses'))
			elseif _accessory == 'helmet' then
				ESX.ShowNotification(_U('accessories_no_helmet'))
			elseif _accessory == 'mask' then
				ESX.ShowNotification(_U('accessories_no_mask'))
			end
		end
	end, accessory)
end

function CheckQuantity(number)
	if type(number) == 'number' then
		number = ESX.Math.Round(tonumber(number))

		if number > 0 then
			return true, number
		end
	end

	return false, number
end

function RenderPersonalMenu()
	RageUI.DrawContent({header = true, glare = true, instructionalButton = true}, function()
		local Menus = RMenu.GetType('personal')

		for i = 1, #Menus, 1 do
			RageUI.Button(Menus[i].Menu.Title, nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, Menus[i].Menu)
		end

		RageUI.List(_U('mainmenu_gps_button'), PersonalMenu.GPSList, PersonalMenu.GPSIndex, nil, {}, true, function(Hovered, Active, Selected, Index)
		end)

		RageUI.List(_U('mainmenu_voice_button'), PersonalMenu.VoiceList, PersonalMenu.VoiceIndex, nil, {}, true, function(Hovered, Active, Selected, Index)
		end)
	end)
	local gpsItem = NativeUI.CreateListItem(_U('mainmenu_gps_button'), PersonalMenu.GPSList, PersonalMenu.GPSIndex)
	local voixItem = NativeUI.CreateListItem(_U('mainmenu_voice_button'), PersonalMenu.VoiceList, PersonalMenu.VoiceIndex)

	menu.OnListSelect = function(sender, item, index)
		if item == gpsItem then
			PersonalMenu.GPSSelected = item:IndexToItem(index)
			PersonalMenu.GPSIndex = index
			ESX.ShowNotification(_U('gps', PersonalMenu.GPSSelected))

			if PersonalMenu.GPSSelected == 'Aucun' then
			end
		elseif item == voixItem then
			PersonalMenu.VoiceSelected = item:IndexToItem(index)
			PersonalMenu.VoiceIndex = index
			ESX.ShowNotification(_U('voice', PersonalMenu.VoiceSelected))

			if index == 1 then
				NetworkSetTalkerProximity(1.0)
			elseif index == 2 then
				NetworkSetTalkerProximity(8.0)
			elseif index == 3 then
				NetworkSetTalkerProximity(14.0)
			end
		end
	end
end

function RenderActionsMenu(type)
	RageUI.DrawContent({header = true, glare = true, instructionalButton = true}, function()
		if type == 'inventory' then
			RageUI.Button(_U('inventory_use_button'), "", {}, true, function(Hovered, Active, Selected)
				if (Selected) then
					if PersonalMenu.ItemSelected.usable then
						TriggerServerEvent('esx:useItem', PersonalMenu.ItemSelected.name)
					else
						ESX.ShowNotification(_U('not_usable', PersonalMenu.ItemSelected.label))
					end
				end
			end)

			RageUI.Button(_U('inventory_give_button'), "", {}, true, function(Hovered, Active, Selected)
				if (Selected) then
					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

					if closestDistance ~= -1 and closestDistance <= 3 then
						local closestPed = GetPlayerPed(closestPlayer)

						if not IsPedSittingInAnyVehicle(closestPed) then
							if PersonalMenu.ItemIndex[PersonalMenu.ItemSelected.name] ~= nil and PersonalMenu.ItemSelected.count > 0 then
								TriggerServerEvent('esx:giveInventoryItem', GetPlayerServerId(closestPlayer), 'item_standard', PersonalMenu.ItemSelected.name, PersonalMenu.ItemIndex[PersonalMenu.ItemSelected.name])
								RageUI.CloseAll()
							else
								ESX.ShowNotification(_U('amount_invalid'))
							end
						else
							ESX.ShowNotification(_U('in_vehicle_give', PersonalMenu.ItemSelected.label))
						end
					else
						ESX.ShowNotification(_U('players_nearby'))
					end
				end
			end)

			RageUI.Button(_U('inventory_drop_button'), "", {RightBadge = RageUI.BadgeStyle.Alert}, true, function(Hovered, Active, Selected)
				if (Selected) then
					if PersonalMenu.ItemSelected.canRemove then
						if not IsPedSittingInAnyVehicle(plyPed) then
							if PersonalMenu.ItemIndex[PersonalMenu.ItemSelected.name] ~= nil then
								TriggerServerEvent('esx:removeInventoryItem', 'item_standard', PersonalMenu.ItemSelected.name, PersonalMenu.ItemIndex[PersonalMenu.ItemSelected.name])
								RageUI.CloseAll()
							else
								ESX.ShowNotification(_U('amount_invalid'))
							end
						else
							ESX.ShowNotification(_U('in_vehicle_drop', PersonalMenu.ItemSelected.label))
						end
					else
						ESX.ShowNotification(_U('not_droppable', PersonalMenu.ItemSelected.label))
					end
				end
			end)
		elseif type == 'loadout' then
			if HasPedGotWeapon(plyPed, PersonalMenu.ItemSelected.hash, false) then
				RageUI.Button(_U('loadout_give_button'), "", {}, true, function(Hovered, Active, Selected)
					if (Selected) then
						local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

						if closestDistance ~= -1 and closestDistance <= 3 then
							local closestPed = GetPlayerPed(closestPlayer)

							if not IsPedSittingInAnyVehicle(closestPed) then
								local ammo = GetAmmoInPedWeapon(plyPed, PersonalMenu.ItemSelected.hash)
								TriggerServerEvent('esx:giveInventoryItem', GetPlayerServerId(closestPlayer), 'item_weapon', PersonalMenu.ItemSelected.name, ammo)
								RageUI.CloseAll()
							else
								ESX.ShowNotification(_U('in_vehicle_give', PersonalMenu.ItemSelected.label))
							end
						else
							ESX.ShowNotification(_U('players_nearby'))
						end
					end
				end)

				RageUI.Button(_U('loadout_givemun_button'), "", {RightBadge = RageUI.BadgeStyle.Ammo}, true, function(Hovered, Active, Selected)
					if (Selected) then
						local post, quantity = CheckQuantity(KeyboardInput('KORIOZ_BOX_AMMO_AMOUNT', _U('dialogbox_amount_ammo'), '', 8))

						if post then
							local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

							if closestDistance ~= -1 and closestDistance <= 3 then
								local closestPed = GetPlayerPed(closestPlayer)

								if not IsPedSittingInAnyVehicle(closestPed) then
									local ammo = GetAmmoInPedWeapon(plyPed, PersonalMenu.ItemSelected.hash)

									if ammo > 0 then
										if quantity <= ammo and quantity >= 0 then
											local finalAmmo = math.floor(ammo - quantity)
											SetPedAmmo(plyPed, value, finalAmmo)

											TriggerServerEvent('KorioZ-PersonalMenu:Weapon_addAmmoToPedS', GetPlayerServerId(closestPlayer), PersonalMenu.ItemSelected.name, quantity)
											ESX.ShowNotification(_U('gave_ammo', quantity, GetPlayerName(closestPlayer)))
											RageUI.CloseAll()
										else
											ESX.ShowNotification(_U('not_enough_ammo'))
										end
									else
										ESX.ShowNotification(_U('no_ammo'))
									end
								else
									ESX.ShowNotification(_U('in_vehicle_give', PersonalMenu.ItemSelected.label))
								end
							else
								ESX.ShowNotification(_U('players_nearby'))
							end
						else
							ESX.ShowNotification(_U('amount_invalid'))
						end
					end
				end)

				RageUI.Button(_U('loadout_drop_button'), "", {RightBadge = RageUI.BadgeStyle.Alert}, true, function(Hovered, Active, Selected)
					if (Selected) then
						if not IsPedSittingInAnyVehicle(plyPed) then
							TriggerServerEvent('esx:removeInventoryItem', 'item_weapon', PersonalMenu.ItemSelected.name)
							RageUI.CloseAll()
						else
							ESX.ShowNotification(_U('in_vehicle_drop', PersonalMenu.ItemSelected.label))
						end
					end
				end)
			else
				RageUI.GoBack()
			end
		end
	end)
end

function RenderInventoryMenu()
	RageUI.DrawContent({header = true, glare = true, instructionalButton = true}, function()
		for i = 1, #ESX.PlayerData.inventory, 1 do
			if ESX.PlayerData.inventory[i].count > 0 then
				local invCount = {}

				for i = 1, ESX.PlayerData.inventory[i].count, 1 do
					table.insert(invCount, i)
				end

				RageUI.List(ESX.PlayerData.inventory[i].label .. ' (' .. ESX.PlayerData.inventory[i].count .. ')', invCount, PersonalMenu.ItemIndex[ESX.PlayerData.inventory[i].name] or 1, nil, {}, true, function(Hovered, Active, Selected, Index)
					if (Selected) then
						PersonalMenu.ItemSelected = ESX.PlayerData.inventory[i]
					end

					PersonalMenu.ItemIndex[ESX.PlayerData.inventory[i].name] = Index
				end, RMenu.Get('inventory', 'actions'))
			end
		end
	end)
end

function RenderWeaponMenu()
	RageUI.DrawContent({header = true, glare = true, instructionalButton = true}, function()
		for i = 1, #PersonalMenu.WeaponData, 1 do
			if HasPedGotWeapon(plyPed, PersonalMenu.WeaponData[i].hash, false) then
				local ammo = GetAmmoInPedWeapon(plyPed, PersonalMenu.WeaponData[i].hash)

				RageUI.Button(PersonalMenu.WeaponData[i].label .. ' [' .. ammo .. ']', nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
					if (Selected) then
						PersonalMenu.ItemSelected = PersonalMenu.WeaponData[i]
					end
				end, RMenu.Get('loadout', 'actions'))
			end
		end
	end)
end

function RenderWalletMenu()
	RageUI.DrawContent({header = true, glare = true, instructionalButton = true}, function()
		RageUI.Button(_U('wallet_job_button', ESX.PlayerData.job.label, ESX.PlayerData.job.grade_label), nil, {}, true, function(Hovered, Active, Selected) end)

		if Config.DoubleJob then
			RageUI.Button(_U('wallet_job2_button', ESX.PlayerData.job2.label, ESX.PlayerData.job2.grade_label), nil, {}, true, function(Hovered, Active, Selected) end)
		end

		if PersonalMenu.WalletIndex['money'] == nil then PersonalMenu.WalletIndex['money'] = 1 end
		RageUI.List(_U('wallet_money_button', ESX.Math.GroupDigits(ESX.PlayerData.money)), PersonalMenu.WalletList, PersonalMenu.WalletIndex['money'] or 1, nil, {}, true, function(Hovered, Active, Selected, Index)
			if (Selected) then
				if Index == 1 then
					local post, quantity = CheckQuantity(KeyboardInput('KORIOZ_BOX_AMOUNT', _U('dialogbox_amount'), '', 8))

					if post then
						local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

						if closestDistance ~= -1 and closestDistance <= 3 then
							local closestPed = GetPlayerPed(closestPlayer)

							if not IsPedSittingInAnyVehicle(closestPed) then
								TriggerServerEvent('esx:giveInventoryItem', GetPlayerServerId(closestPlayer), 'item_money', 'money', quantity)
								RageUI.CloseAll()
							else
								ESX.ShowNotification(_U('in_vehicle_give', 'de l\'argent'))
							end
						else
							ESX.ShowNotification(_U('players_nearby'))
						end
					else
						ESX.ShowNotification(_U('amount_invalid'))
					end
				elseif Index == 2 then
					local post, quantity = CheckQuantity(KeyboardInput('KORIOZ_BOX_AMOUNT', _U('dialogbox_amount'), '', 8))

					if post then
						if not IsPedSittingInAnyVehicle(plyPed) then
							TriggerServerEvent('esx:removeInventoryItem', 'item_money', 'money', quantity)
							RageUI.CloseAll()
						else
							ESX.ShowNotification(_U('in_vehicle_drop', 'de l\'argent'))
						end
					else
						ESX.ShowNotification(_U('amount_invalid'))
					end
				end
			end

			PersonalMenu.WalletIndex['money'] = Index
		end)

		for i = 1, #ESX.PlayerData.accounts, 1 do
			if ESX.PlayerData.accounts[i].name == 'bank' then
				RageUI.Button(_U('wallet_bankmoney_button', ESX.Math.GroupDigits(ESX.PlayerData.accounts[i].money)), nil, {}, true, function(Hovered, Active, Selected) end)
			end

			if ESX.PlayerData.accounts[i].name == 'black_money' then
				if PersonalMenu.WalletIndex[ESX.PlayerData.accounts[i].name] == nil then PersonalMenu.WalletIndex[ESX.PlayerData.accounts[i].name] = 1 end
				RageUI.List(_U('wallet_blackmoney_button', ESX.Math.GroupDigits(ESX.PlayerData.accounts[i].money)), PersonalMenu.WalletList, PersonalMenu.WalletIndex[ESX.PlayerData.accounts[i].name] or 1, nil, {}, true, function(Hovered, Active, Selected, Index)
					if (Selected) then
						if Index == 1 then
							local post, quantity = CheckQuantity(KeyboardInput('KORIOZ_BOX_AMOUNT', _U('dialogbox_amount'), '', 8))

							if post then
								local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

								if closestDistance ~= -1 and closestDistance <= 3 then
									local closestPed = GetPlayerPed(closestPlayer)

									if not IsPedSittingInAnyVehicle(closestPed) then
										TriggerServerEvent('esx:giveInventoryItem', GetPlayerServerId(closestPlayer), 'item_account', ESX.PlayerData.accounts[i].name, quantity)
										RageUI.CloseAll()
									else
										ESX.ShowNotification(_U('in_vehicle_give', 'de l\'argent'))
									end
								else
									ESX.ShowNotification(_U('players_nearby'))
								end
							else
								ESX.ShowNotification(_U('amount_invalid'))
							end
						elseif Index == 2 then
							local post, quantity = CheckQuantity(KeyboardInput('KORIOZ_BOX_AMOUNT', _U('dialogbox_amount'), '', 8))

							if post then
								if not IsPedSittingInAnyVehicle(plyPed) then
									TriggerServerEvent('esx:removeInventoryItem', 'item_account', ESX.PlayerData.accounts[i].name, quantity)
									RageUI.CloseAll()
								else
									ESX.ShowNotification(_U('in_vehicle_drop', 'de l\'argent'))
								end
							else
								ESX.ShowNotification(_U('amount_invalid'))
							end
						end
					end

					PersonalMenu.WalletIndex[ESX.PlayerData.accounts[i].name] = Index
				end)
			end
		end

		if Config.JSFourIDCard then
			RageUI.Button(_U('wallet_show_idcard_button'), nil, {}, true, function(Hovered, Active, Selected)
				if (Selected) then
					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

					if closestDistance ~= -1 and closestDistance <= 3.0 then
						TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer))
					else
						ESX.ShowNotification(_U('players_nearby'))
					end
				end
			end)

			RageUI.Button(_U('wallet_check_idcard_button'), nil, {}, true, function(Hovered, Active, Selected)
				if (Selected) then
					TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()))
				end
			end)

			RageUI.Button(_U('wallet_show_driver_button'), nil, {}, true, function(Hovered, Active, Selected)
				if (Selected) then
					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

					if closestDistance ~= -1 and closestDistance <= 3.0 then
						TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer), 'driver')
					else
						ESX.ShowNotification(_U('players_nearby'))
					end
				end
			end)

			RageUI.Button(_U('wallet_check_driver_button'), nil, {}, true, function(Hovered, Active, Selected)
				if (Selected) then
					TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'driver')
				end
			end)

			RageUI.Button(_U('wallet_show_firearms_button'), nil, {}, true, function(Hovered, Active, Selected)
				if (Selected) then
					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

					if closestDistance ~= -1 and closestDistance <= 3.0 then
						TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer), 'weapon')
					else
						ESX.ShowNotification(_U('players_nearby'))
					end
				end
			end)

			RageUI.Button(_U('wallet_check_firearms_button'), nil, {}, true, function(Hovered, Active, Selected)
				if (Selected) then
					TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'weapon')
				end
			end)
		end
	end)
end

function RenderBillingMenu()
	RageUI.DrawContent({header = true, glare = true, instructionalButton = true}, function()
		for i = 1, #PersonalMenu.BillData, 1 do
			RageUI.Button(PersonalMenu.BillData[i].label, nil, {RightLabel = '$' .. ESX.Math.GroupDigits(PersonalMenu.BillData[i].amount)}, true, function(Hovered, Active, Selected)
				if (Selected) then
					ESX.TriggerServerCallback('esx_billing:payBill', function()
						RageUI.CloseAll()
					end, PersonalMenu.BillData[i].id)
				end
			end)
		end
	end)
end

function RenderClothesMenu()
	RageUI.DrawContent({header = true, glare = true, instructionalButton = true}, function()
		for i = 1, #PersonalMenu.ClothesButtons, 1 do
			RageUI.Button(_U(('clothes_%s'):format(PersonalMenu.ClothesButtons[i])), nil, {RightBadge = RageUI.BadgeStyle.Clothes}, true, function(Hovered, Active, Selected)
				if (Selected) then
					setUniform(PersonalMenu.ClothesButtons[i], plyPed)
				end
			end)
		end
	end)
end

function RenderAccessoriesMenu()
	RageUI.DrawContent({header = true, glare = true, instructionalButton = true}, function()
		for i = 1, #PersonalMenu.AccessoriesButtons, 1 do
			RageUI.Button(_U(('accessories_%s'):format((PersonalMenu.AccessoriesButtons[i]:lower()))), nil, {RightBadge = RageUI.BadgeStyle.Clothes}, true, function(Hovered, Active, Selected)
				if (Selected) then
					SetUnsetAccessory(PersonalMenu.AccessoriesButtons[i])
				end
			end)
		end
	end)
end

function RenderAnimationMenu()
	RageUI.DrawContent({header = true, glare = true, instructionalButton = true}, function()
		local Menus = RMenu.GetType('animation')

		for i = 1, #Menus, 1 do
			RageUI.Button(Menus[i].Menu.Title, nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, Menus[i].Menu)
		end
	end)
end

function RenderAnimationsSubMenu(menu)
	RageUI.DrawContent({header = true, glare = true, instructionalButton = true}, function()
		for i = 1, #Config.Animations, 1 do
			if Config.Animations[i].name == menu then
				for j = 1, #Config.Animations[i].items, 1 do
					RageUI.Button(Config.Animations[i].items[j].label, nil, {}, true, function(Hovered, Active, Selected)
						if (Selected) then
							if Config.Animations[i].items[j].type == 'anim' then
								startAnim(Config.Animations[i].items[j].data.lib, Config.Animations[i].items[j].data.anim)
							elseif Config.Animations[i].items[j].type == 'scenario' then
								startScenario(Config.Animations[i].items[j].data.anim)
							elseif Config.Animations[i].items[j].type == 'attitude' then
								startAttitude(Config.Animations[i].items[j].data.lib, Config.Animations[i].items[j].data.anim)
							end
						end
					end)
				end
			end
		end
	end)
end

function RenderVehicleMenu()
	RageUI.DrawContent({header = true, glare = true, instructionalButton = true}, function()
		RageUI.Button(_U('vehicle_engine_button'), nil, {}, true, function(Hovered, Active, Selected)
			if (Selected) then
				if not IsPedSittingInAnyVehicle(plyPed) then
					ESX.ShowNotification(_U('no_vehicle'))
				elseif IsPedSittingInAnyVehicle(plyPed) then
					local plyVeh = GetVehiclePedIsIn(plyPed, false)

					if GetIsVehicleEngineRunning(plyVeh) then
						SetVehicleEngineOn(plyVeh, false, false, true)
						SetVehicleUndriveable(plyVeh, true)
					elseif not GetIsVehicleEngineRunning(plyVeh) then
						SetVehicleEngineOn(plyVeh, true, false, true)
						SetVehicleUndriveable(plyVeh, false)
					end
				end
			end
		end)

		RageUI.List(_U('vehicle_door_button'), PersonalMenu.DoorList, 1, nil, {}, true, function(Hovered, Active, Selected, Index)
			if (Selected) then
				if not IsPedSittingInAnyVehicle(plyPed) then
					ESX.ShowNotification(_U('no_vehicle'))
				elseif IsPedSittingInAnyVehicle(plyPed) then
					local plyVeh = GetVehiclePedIsIn(plyPed, false)

					if Index == 1 then
						if not PersonalMenu.DoorState.FrontLeft then
							PersonalMenu.DoorState.FrontLeft = true
							SetVehicleDoorOpen(plyVeh, 0, false, false)
						elseif PersonalMenu.DoorState.FrontLeft then
							PersonalMenu.DoorState.FrontLeft = false
							SetVehicleDoorShut(plyVeh, 0, false, false)
						end
					elseif Index == 2 then
						if not PersonalMenu.DoorState.FrontRight then
							PersonalMenu.DoorState.FrontRight = true
							SetVehicleDoorOpen(plyVeh, 1, false, false)
						elseif PersonalMenu.DoorState.FrontRight then
							PersonalMenu.DoorState.FrontRight = false
							SetVehicleDoorShut(plyVeh, 1, false, false)
						end
					elseif Index == 3 then
						if not PersonalMenu.DoorState.BackLeft then
							PersonalMenu.DoorState.BackLeft = true
							SetVehicleDoorOpen(plyVeh, 2, false, false)
						elseif PersonalMenu.DoorState.BackLeft then
							PersonalMenu.DoorState.BackLeft = false
							SetVehicleDoorShut(plyVeh, 2, false, false)
						end
					elseif Index == 4 then
						if not PersonalMenu.DoorState.BackRight then
							PersonalMenu.DoorState.BackRight = true
							SetVehicleDoorOpen(plyVeh, 3, false, false)
						elseif PersonalMenu.DoorState.BackRight then
							PersonalMenu.DoorState.BackRight = false
							SetVehicleDoorShut(plyVeh, 3, false, false)
						end
					end
				end

				DoorIndex = Index
			end
		end)

		RageUI.Button(_U('vehicle_hood_button'), nil, {}, true, function(Hovered, Active, Selected)
			if (Selected) then
				if not IsPedSittingInAnyVehicle(plyPed) then
					ESX.ShowNotification(_U('no_vehicle'))
				elseif IsPedSittingInAnyVehicle(plyPed) then
					local plyVeh = GetVehiclePedIsIn(plyPed, false)

					if not PersonalMenu.DoorState.Hood then
						PersonalMenu.DoorState.Hood = true
						SetVehicleDoorOpen(plyVeh, 4, false, false)
					elseif PersonalMenu.DoorState.Hood then
						PersonalMenu.DoorState.Hood = false
						SetVehicleDoorShut(plyVeh, 4, false, false)
					end
				end
			end
		end)

		RageUI.Button(_U('vehicle_trunk_button'), nil, {}, true, function(Hovered, Active, Selected)
			if (Selected) then
				if not IsPedSittingInAnyVehicle(plyPed) then
					ESX.ShowNotification(_U('no_vehicle'))
				elseif IsPedSittingInAnyVehicle(plyPed) then
					local plyVehicle = GetVehiclePedIsIn(plyPed, false)

					if not PersonalMenu.DoorState.Trunk then
						PersonalMenu.DoorState.Trunk = true
						SetVehicleDoorOpen(plyVeh, 5, false, false)
					elseif PersonalMenu.DoorState.Trunk then
						PersonalMenu.DoorState.Trunk = false
						SetVehicleDoorShut(plyVeh, 5, false, false)
					end
				end
			end
		end)
	end)
end

function RenderBossMenu()
	RageUI.DrawContent({header = true, glare = true, instructionalButton = true}, function()
		if societymoney ~= nil then
			RageUI.Button(_U('bossmanagement_chest_button'), nil, {RightLabel = '$' .. societymoney}, true, function(Hovered, Active, Selected)
				if (Selected) then
				end
			end)
		end

		RageUI.Button(_U('bossmanagement_hire_button'), nil, {}, true, function(Hovered, Active, Selected)
			if (Selected) then
				if ESX.PlayerData.job.grade_name == 'boss' then
					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

					if closestPlayer == -1 or closestDistance > 3.0 then
						ESX.ShowNotification(_U('players_nearby'))
					else
						TriggerServerEvent('KorioZ-PersonalMenu:Boss_recruterplayer', GetPlayerServerId(closestPlayer), ESX.PlayerData.job.name, 0)
					end
				else
					ESX.ShowNotification(_U('missing_rights'))
				end
			end
		end)

		RageUI.Button(_U('bossmanagement_fire_button'), nil, {}, true, function(Hovered, Active, Selected)
			if (Selected) then
				if ESX.PlayerData.job.grade_name == 'boss' then
					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

					if closestPlayer == -1 or closestDistance > 3.0 then
						ESX.ShowNotification(_U('players_nearby'))
					else
						TriggerServerEvent('KorioZ-PersonalMenu:Boss_virerplayer', GetPlayerServerId(closestPlayer))
					end
				else
					ESX.ShowNotification(_U('missing_rights'))
				end
			end
		end)

		RageUI.Button(_U('bossmanagement_promote_button'), nil, {}, true, function(Hovered, Active, Selected)
			if (Selected) then
				if ESX.PlayerData.job.grade_name == 'boss' then
					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

					if closestPlayer == -1 or closestDistance > 3.0 then
						ESX.ShowNotification(_U('players_nearby'))
					else
						TriggerServerEvent('KorioZ-PersonalMenu:Boss_promouvoirplayer', GetPlayerServerId(closestPlayer))
					end
				else
					ESX.ShowNotification(_U('missing_rights'))
				end
			end
		end)

		RageUI.Button(_U('bossmanagement_demote_button'), nil, {}, true, function(Hovered, Active, Selected)
			if (Selected) then
				if ESX.PlayerData.job.grade_name == 'boss' then
					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

					if closestPlayer == -1 or closestDistance > 3.0 then
						ESX.ShowNotification(_U('players_nearby'))
					else
						TriggerServerEvent('KorioZ-PersonalMenu:Boss_destituerplayer', GetPlayerServerId(closestPlayer))
					end
				else
					ESX.ShowNotification(_U('missing_rights'))
				end
			end
		end)
	end)
end

function RenderBoss2Menu()
	RageUI.DrawContent({header = true, glare = true, instructionalButton = true}, function()
		if societymoney ~= nil then
			RageUI.Button(_U('bossmanagement2_chest_button'), nil, {RightLabel = '$' .. societymoney2}, true, function(Hovered, Active, Selected) end)
		end

		RageUI.Button(_U('bossmanagement2_hire_button'), nil, {}, true, function(Hovered, Active, Selected)
			if (Selected) then
				if ESX.PlayerData.job2.grade_name == 'boss' then
					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

					if closestPlayer == -1 or closestDistance > 3.0 then
						ESX.ShowNotification(_U('players_nearby'))
					else
						TriggerServerEvent('KorioZ-PersonalMenu:Boss_recruterplayer2', GetPlayerServerId(closestPlayer), ESX.PlayerData.job2.name, 0)
					end
				else
					ESX.ShowNotification(_U('missing_rights'))
				end
			end
		end)

		RageUI.Button(_U('bossmanagement2_fire_button'), nil, {}, true, function(Hovered, Active, Selected)
			if (Selected) then
				if ESX.PlayerData.job2.grade_name == 'boss' then
					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

					if closestPlayer == -1 or closestDistance > 3.0 then
						ESX.ShowNotification(_U('players_nearby'))
					else
						TriggerServerEvent('KorioZ-PersonalMenu:Boss_virerplayer2', GetPlayerServerId(closestPlayer))
					end
				else
					ESX.ShowNotification(_U('missing_rights'))
				end
			end
		end)

		RageUI.Button(_U('bossmanagement2_promote_button'), nil, {}, true, function(Hovered, Active, Selected)
			if (Selected) then
				if ESX.PlayerData.job2.grade_name == 'boss' then
					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

					if closestPlayer == -1 or closestDistance > 3.0 then
						ESX.ShowNotification(_U('players_nearby'))
					else
						TriggerServerEvent('KorioZ-PersonalMenu:Boss_promouvoirplayer2', GetPlayerServerId(closestPlayer))
					end
				else
					ESX.ShowNotification(_U('missing_rights'))
				end
			end
		end)

		RageUI.Button(_U('bossmanagement2_demote_button'), nil, {}, true, function(Hovered, Active, Selected)
			if (Selected) then
				if ESX.PlayerData.job2.grade_name == 'boss' then
					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

					if closestPlayer == -1 or closestDistance > 3.0 then
						ESX.ShowNotification(_U('players_nearby'))
					else
						TriggerServerEvent('KorioZ-PersonalMenu:Boss_destituerplayer2', GetPlayerServerId(closestPlayer))
					end
				else
					ESX.ShowNotification(_U('missing_rights'))
				end
			end
		end)
	end)
end

function RenderAdminMenu()
	if PersonalMenu.PlayerGroup == 'mod' then
		local tptoPlrItem = NativeUI.CreateItem(_U('admin_goto_button'), '')
		adminMenu.SubMenu:AddItem(tptoPlrItem)
		local tptoMeItem = NativeUI.CreateItem(_U('admin_bring_button'), '')
		adminMenu.SubMenu:AddItem(tptoMeItem)
		local showXYZItem = NativeUI.CreateItem(_U('admin_showxyz_button'), '')
		adminMenu.SubMenu:AddItem(showXYZItem)
		local showPlrNameItem = NativeUI.CreateItem(_U('admin_showname_button'), '')
		adminMenu.SubMenu:AddItem(showPlrNameItem)

		adminMenu.SubMenu.OnItemSelect = function(sender, item, index)
			if item == tptoPlrItem then
				admin_tp_toplayer()
				RageUI.CloseAll()
			elseif item == tptoMeItem then
				admin_tp_playertome()
				RageUI.CloseAll()
			elseif item == showXYZItem then
				admin_showcoord()
			elseif item == showPlrNameItem then
				admin_showname()
			end
		end
	elseif PersonalMenu.PlayerGroup == 'admin' then
		local tptoPlrItem = NativeUI.CreateItem(_U('admin_goto_button'), '')
		adminMenu.SubMenu:AddItem(tptoPlrItem)
		local tptoMeItem = NativeUI.CreateItem(_U('admin_bring_button'), '')
		adminMenu.SubMenu:AddItem(tptoMeItem)
		local noclipItem = NativeUI.CreateItem(_U('admin_noclip_button'), '')
		adminMenu.SubMenu:AddItem(noclipItem)
		local repairVehItem = NativeUI.CreateItem(_U('admin_repairveh_button'), '')
		adminMenu.SubMenu:AddItem(repairVehItem)
		local returnVehItem = NativeUI.CreateItem(_U('admin_flipveh_button'), '')
		adminMenu.SubMenu:AddItem(returnVehItem)
		local showXYZItem = NativeUI.CreateItem(_U('admin_showxyz_button'), '')
		adminMenu.SubMenu:AddItem(showXYZItem)
		local showPlrNameItem = NativeUI.CreateItem(_U('admin_showname_button'), '')
		adminMenu.SubMenu:AddItem(showPlrNameItem)
		local tptoWaypointItem = NativeUI.CreateItem(_U('admin_tpmarker_button'), '')
		adminMenu.SubMenu:AddItem(tptoWaypointItem)
		local revivePlrItem = NativeUI.CreateItem(_U('admin_revive_button'), '')
		adminMenu.SubMenu:AddItem(revivePlrItem)

		adminMenu.SubMenu.OnItemSelect = function(sender, item, index)
			if item == tptoPlrItem then
				admin_tp_toplayer()
				RageUI.CloseAll()
			elseif item == tptoMeItem then
				admin_tp_playertome()
				RageUI.CloseAll()
			elseif item == noclipItem then
				admin_no_clip()
				RageUI.CloseAll()
			elseif item == repairVehItem then
				admin_vehicle_repair()
			elseif item == returnVehItem then
				admin_vehicle_flip()
			elseif item == showXYZItem then
				admin_showcoord()
			elseif item == showPlrNameItem then
				admin_showname()
			elseif item == tptoWaypointItem then
				admin_tp_marker()
			elseif item == revivePlrItem then
				admin_heal_player()
				RageUI.CloseAll()
			end
		end
	elseif PersonalMenu.PlayerGroup == 'superadmin' or PersonalMenu.PlayerGroup == 'owner' then
		local tptoPlrItem = NativeUI.CreateItem(_U('admin_goto_button'), '')
		adminMenu.SubMenu:AddItem(tptoPlrItem)
		local tptoMeItem = NativeUI.CreateItem(_U('admin_bring_button'), '')
		adminMenu.SubMenu:AddItem(tptoMeItem)
		local tptoXYZItem = NativeUI.CreateItem(_U('admin_tpxyz_button'), '')
		adminMenu.SubMenu:AddItem(tptoXYZItem)
		local noclipItem = NativeUI.CreateItem(_U('admin_noclip_button'), '')
		adminMenu.SubMenu:AddItem(noclipItem)
		local godmodeItem = NativeUI.CreateItem(_U('admin_godmode_button'), '')
		adminMenu.SubMenu:AddItem(godmodeItem)
		local ghostmodeItem = NativeUI.CreateItem(_U('admin_ghostmode_button'), '')
		adminMenu.SubMenu:AddItem(ghostmodeItem)
		local spawnVehItem = NativeUI.CreateItem(_U('admin_spawnveh_button'), '')
		adminMenu.SubMenu:AddItem(spawnVehItem)
		local repairVehItem = NativeUI.CreateItem(_U('admin_repairveh_button'), '')
		adminMenu.SubMenu:AddItem(repairVehItem)
		local returnVehItem = NativeUI.CreateItem(_U('admin_flipveh_button'), '')
		adminMenu.SubMenu:AddItem(returnVehItem)
		local givecashItem = NativeUI.CreateItem(_U('admin_givemoney_button'), '')
		adminMenu.SubMenu:AddItem(givecashItem)
		local givebankItem = NativeUI.CreateItem(_U('admin_givebank_button'), '')
		adminMenu.SubMenu:AddItem(givebankItem)
		local givedirtyItem = NativeUI.CreateItem(_U('admin_givedirtymoney_button'), '')
		adminMenu.SubMenu:AddItem(givedirtyItem)
		local showXYZItem = NativeUI.CreateItem(_U('admin_showxyz_button'), '')
		adminMenu.SubMenu:AddItem(showXYZItem)
		local showPlrNameItem = NativeUI.CreateItem(_U('admin_showname_button'), '')
		adminMenu.SubMenu:AddItem(showPlrNameItem)
		local tptoWaypointItem = NativeUI.CreateItem(_U('admin_tpmarker_button'), '')
		adminMenu.SubMenu:AddItem(tptoWaypointItem)
		local revivePlrItem = NativeUI.CreateItem(_U('admin_revive_button'), '')
		adminMenu.SubMenu:AddItem(revivePlrItem)
		local skinPlrItem = NativeUI.CreateItem(_U('admin_changeskin_button'), '')
		adminMenu.SubMenu:AddItem(skinPlrItem)
		local saveSkinPlrItem = NativeUI.CreateItem(_U('admin_saveskin_button'), '')
		adminMenu.SubMenu:AddItem(saveSkinPlrItem)

		adminMenu.SubMenu.OnItemSelect = function(sender, item, index)
			if item == tptoPlrItem then
				admin_tp_toplayer()
				RageUI.CloseAll()
			elseif item == tptoMeItem then
				admin_tp_playertome()
				RageUI.CloseAll()
			elseif item == tptoXYZItem then
				admin_tp_pos()
				RageUI.CloseAll()
			elseif item == noclipItem then
				admin_no_clip()
				RageUI.CloseAll()
			elseif item == godmodeItem then
				admin_godmode()
			elseif item == ghostmodeItem then
				admin_mode_fantome()
			elseif item == spawnVehItem then
				admin_vehicle_spawn()
				RageUI.CloseAll()
			elseif item == repairVehItem then
				admin_vehicle_repair()
			elseif item == returnVehItem then
				admin_vehicle_flip()
			elseif item == givecashItem then
				admin_give_money()
				RageUI.CloseAll()
			elseif item == givebankItem then
				admin_give_bank()
				RageUI.CloseAll()
			elseif item == givedirtyItem then
				admin_give_dirty()
				RageUI.CloseAll()
			elseif item == showXYZItem then
				admin_showcoord()
			elseif item == showPlrNameItem then
				admin_showname()
			elseif item == tptoWaypointItem then
				admin_tp_marker()
			elseif item == revivePlrItem then
				admin_heal_player()
				RageUI.CloseAll()
			elseif item == skinPlrItem then
				changer_skin()
			elseif item == saveSkinPlrItem then
				save_skin()
			end
		end
	end
end

RageUI.CreateWhile(1.0, function()
	if IsControlJustReleased(0, Config.Controls.OpenMenu.keyboard) and not isDead then
		if not RageUI.Visible() then
			ESX.TriggerServerCallback('KorioZ-PersonalMenu:Admin_getUsergroup', function(plyGroup)
				PersonalMenu.PlayerGroup = playerGroup

				ESX.TriggerServerCallback('KorioZ-PersonalMenu:Bill_getBills', function(bills)
					PersonalMenu.BillData = bills
					ESX.PlayerData = ESX.GetPlayerData()
					RageUI.Visible(RMenu.Get('rageui', 'personal'), true)
				end)
			end)
		end
	end

	if RageUI.Visible(RMenu.Get('rageui', 'personal')) then
		RenderPersonalMenu()
	end

	if RageUI.Visible(RMenu.Get('inventory', 'actions')) then
		RenderActionsMenu('inventory')
	elseif RageUI.Visible(RMenu.Get('loadout', 'actions')) then
		RenderActionsMenu('loadout')
	end

	if RageUI.Visible(RMenu.Get('personal', 'inventory')) then
		RenderInventoryMenu()
	end

	if RageUI.Visible(RMenu.Get('personal', 'loadout')) then
		RenderWeaponMenu()
	end

	if RageUI.Visible(RMenu.Get('personal', 'wallet')) then
		RenderWalletMenu()
	end

	if RageUI.Visible(RMenu.Get('personal', 'billing')) then
		RenderBillingMenu()
	end

	if RageUI.Visible(RMenu.Get('personal', 'clothes')) then
		RenderClothesMenu()
	end

	if RageUI.Visible(RMenu.Get('personal', 'accessories')) then
		RenderAccessoriesMenu()
	end

	if RageUI.Visible(RMenu.Get('personal', 'animation')) then
		RenderAnimationMenu()
	end

	if RageUI.Visible(RMenu.Get('personal', 'vehicle')) then
		if IsPedSittingInAnyVehicle(plyPed) then
			if (GetPedInVehicleSeat(GetVehiclePedIsIn(plyPed, false), -1) == plyPed) then
				RenderVehicleMenu()
			end
		end
	end

	--[[
	if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' then
		RenderBossMenu()
	end

	if Config.DoubleJob then
		if ESX.PlayerData.job2 ~= nil and ESX.PlayerData.job2.grade_name == 'boss' then
			RenderBoss2Menu()
		end
	end

	if PersonalMenu.PlayerGroup ~= nil and (PersonalMenu.PlayerGroup == 'mod' or PersonalMenu.PlayerGroup == 'admin' or PersonalMenu.PlayerGroup == 'superadmin' or PersonalMenu.PlayerGroup == 'owner') then
		RenderAdminMenu()
	end
	]]--

	for i = 1, #Config.Animations, 1 do
		if RageUI.Visible(RMenu.Get('animation', Config.Animations[i].name)) then
			RenderAnimationsSubMenu(Config.Animations[i].name)
		end
	end
end, true)

Citizen.CreateThread(function()
	while true do
		plyPed = PlayerPedId()

		if IsControlJustReleased(0, Config.Controls.StopTasks.keyboard) and IsInputDisabled(2) and not isDead then
			handsup, pointing = false, false
			ClearPedTasks(plyPed)
		end

		if IsControlPressed(1, Config.Controls.TPMarker.keyboard1) and IsControlJustReleased(1, Config.Controls.TPMarker.keyboard2) and IsInputDisabled(2) and not isDead then
			ESX.TriggerServerCallback('KorioZ-PersonalMenu:Admin_getUsergroup', function(playerGroup)
				if playerGroup ~= nil and (playerGroup == 'mod' or playerGroup == 'admin' or playerGroup == 'superadmin' or playerGroup == '_dev') then
					admin_tp_marker()
				end
			end)
		end

		if showcoord then
			local playerPos = GetEntityCoords(plyPed, false)
			Text('~r~X~s~: ' .. playerPos.x .. ' ~b~Y~s~: ' .. playerPos.y .. ' ~g~Z~s~: ' .. playerPos.z .. ' ~y~Angle~s~: ' .. GetEntityHeading(plyPed))
		end

		if noclip then
			local coords = GetEntityCoords(plyPed, false)
			local camCoords = getCamDirection()
			SetEntityVelocity(plyPed, 0.01, 0.01, 0.01)

			if IsControlPressed(0, 32) then
				coords = coords + (Config.NoclipSpeed * camCoords)
			end

			if IsControlPressed(0, 269) then
				coords = coords - (Config.NoclipSpeed * camCoords)
			end

			SetEntityCoordsNoOffset(plyPed, coords, true, true, true)
		end

		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	while true do
		if showname then
			for k, v in ipairs(ESX.Game.GetPlayers()) do
				local otherPed = GetPlayerPed(v)

				if otherPed ~= plyPed then
					if GetDistanceBetweenCoords(GetEntityCoords(plyPed, false), GetEntityCoords(otherPed, false)) < 5000.0 then
						gamerTags[v] = CreateFakeMpGamerTag(otherPed, ('[%s] %s'):format(GetPlayerServerId(v), GetPlayerName(v)), false, false, '', 0)
					else
						RemoveMpGamerTag(gamerTags[v])
						gamerTags[v] = nil
					end
				end
			end
		end

		Citizen.Wait(100)
	end
end)
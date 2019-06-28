local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX = nil

local personalmenu = {}
local invItem = {}
local wepItem = {}
local billItem = {}

local plyPed, plyVehicle = nil, nil

local actualGPS, actualGPSIndex = "Aucun", 1
local actualDemarche, actualDemarcheIndex = "Normal", 1
local actualVoix, actualVoixIndex = "Normal", 2

local isDead = false
local inAnim = false

local playergroup = nil

local societymoney, societymoney2 = nil, nil

_menuPool = NativeUI.CreatePool()

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	if Config.doublejob then
		while ESX.GetPlayerData().job2 == nil do
			Citizen.Wait(10)
		end
	end

	ESX.PlayerData = ESX.GetPlayerData()

	while actualSkin == nil do
		TriggerEvent('skinchanger:getSkin', function(skin) actualSkin = skin end)
		Citizen.Wait(10)
	end

	RefreshMoney()
	RefreshMoney2()
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

AddEventHandler('esx:onPlayerDeath', function(data)
	isDead = true
	_menuPool:CloseAllMenus()
	ESX.UI.Menu.CloseAll()
end)

AddEventHandler('playerSpawned', function(spawn)
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

RegisterNetEvent('esx_addonaccount:setMoney')
AddEventHandler('esx_addonaccount:setMoney', function(society, money)
	if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' and 'society_' .. ESX.PlayerData.job.name == society then
		UpdateSocietyMoney(money)
	end
	if ESX.PlayerData.job2 ~= nil and ESX.PlayerData.job2.grade_name == 'boss' and 'society_' .. ESX.PlayerData.job2.name == society then
		UpdateSociety2Money(money)
	end
end)

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
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(0.017, 0.977)
end

function KeyboardInput(entryTitle, textEntry, inputText, maxLength)
    AddTextEntry(entryTitle, textEntry)
    DisplayOnscreenKeyboard(1, entryTitle, "", inputText, "", "", "", maxLength)
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

-- Weapon Menu --

RegisterNetEvent("KorioZ-PersonalMenu:Weapon_addAmmoToPedC")
AddEventHandler("KorioZ-PersonalMenu:Weapon_addAmmoToPedC", function(value, quantity)
	AddAmmoToPed(plyPed, value, quantity)
end)

-- Admin Menu --

RegisterNetEvent('KorioZ-PersonalMenu:Admin_BringC')
AddEventHandler('KorioZ-PersonalMenu:Admin_BringC', function(plyPedCoords)
	SetEntityCoords(plyPed, plyPedCoords)
end)

-- GOTO JOUEUR
function admin_tp_toplayer()
	local plyId = KeyboardInput("KORIOZ_BOX_ID", "ID du Joueur (8 Caractères Maximum):", "", 8)

	if plyId ~= nil then
		plyId = tonumber(plyId)
		
		if type(plyId) == 'number' then
			local targetPlyCoords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(plyId)))
			SetEntityCoords(plyPed, targetPlyCoords)
		end
	end
end
-- FIN GOTO JOUEUR

-- TP UN JOUEUR A MOI
function admin_tp_playertome()
	local plyId = KeyboardInput("KORIOZ_BOX_ID", "ID du Joueur (8 Caractères Maximum):", "", 8)

	if plyId ~= nil then
		plyId = tonumber(plyId)
		
		if type(plyId) == 'number' then
			local plyPedCoords = GetEntityCoords(plyPed)
			print(plyId)
			TriggerServerEvent('KorioZ-PersonalMenu:Admin_BringS', plyId, plyPedCoords)
		end
	end
end
-- FIN TP UN JOUEUR A MOI

-- TP A POSITION
function admin_tp_pos()
	local pos = KeyboardInput("KORIOZ_BOX_XYZ", "Position (50 Caractères Maximum):", "", 50)

	local _, _, x, y, z = string.find(pos, "([%d%.]+) ([%d%.]+) ([%d%.]+)")
			
	if x ~= nil and y ~= nil and z ~= nil then
		SetEntityCoords(plyPed, x + .0, y + .0, z + .0)
	end
end
-- FIN TP A POSITION

-- FONCTION NOCLIP 
function admin_no_clip()
	noclip = not noclip

	if noclip then
		SetEntityInvincible(plyPed, true)
		SetEntityVisible(plyPed, false, false)
		ESX.ShowNotification("Noclip ~g~activé")
	else
		SetEntityInvincible(plyPed, false)
		SetEntityVisible(plyPed, true, false)
		ESX.ShowNotification("Noclip ~r~désactivé")
	end
end

function getPosition()
	local x, y, z = table.unpack(GetEntityCoords(plyPed, true))

	return x, y, z
end

function getCamDirection()
	local heading = GetGameplayCamRelativeHeading() + GetEntityHeading(plyPed)
	local pitch = GetGameplayCamRelativePitch()

	local x = -math.sin(heading * math.pi/180.0)
	local y = math.cos(heading * math.pi/180.0)
	local z = math.sin(pitch * math.pi/180.0)

	local len = math.sqrt(x * x + y * y + z * z)

	if len ~= 0 then
		x = x/len
		y = y/len
		z = z/len
	end

	return x, y, z
end

function isNoclip()
	return noclip
end
-- FIN NOCLIP

-- GOD MODE
function admin_godmode()
	local godmode = not godmode

	if godmode then
		SetEntityInvincible(plyPed, true)
		ESX.ShowNotification("Mode invincible ~g~activé")
	else
		SetEntityInvincible(plyPed, false)
		ESX.ShowNotification("Mode invincible ~r~désactivé")
	end
end
-- FIN GOD MODE

-- INVISIBLE
function admin_mode_fantome()
	local invisible = not invisible

	if invisible then
		SetEntityVisible(plyPed, false, false)
		ESX.ShowNotification("Mode fantôme : activé")
	else
		SetEntityVisible(plyPed, true, false)
		ESX.ShowNotification("Mode fantôme : désactivé")
	end
end
-- FIN INVISIBLE

-- Réparer vehicule
function admin_vehicle_repair()
	local car = GetVehiclePedIsUsing(plyPed)

	SetVehicleFixed(car)
	SetVehicleDirtLevel(car, 0.0)
end
-- FIN Réparer vehicule

-- Spawn vehicule
function admin_vehicle_spawn()
	local vehicleName = KeyboardInput("KORIOZ_BOX_VEHICLE_NAME", "Nom du Véhicule (50 Caractères Maximum):", "", 50)

	if vehicleName ~= nil then
		vehicleName = tostring(vehicleName)
		
		if type(vehicleName) == 'string' then
			local car = GetHashKey(vehicleName)
				
			Citizen.CreateThread(function()
				RequestModel(car)

				while not HasModelLoaded(car) do
					Citizen.Wait(0)
				end

				local x, y, z = table.unpack(GetEntityCoords(plyPed, true))

				local veh = CreateVehicle(car, x, y, z, 0.0, true, false)
				local id = NetworkGetNetworkIdFromEntity(veh)

				SetEntityVelocity(veh, 2000)
				SetVehicleOnGroundProperly(veh)
				SetVehicleHasBeenOwnedByPlayer(veh, true)
				SetNetworkIdCanMigrate(id, true)
				SetVehRadioStation(veh, "OFF")
				SetPedIntoVehicle(plyPed, veh, -1)
			end)
		end
	end
end
-- FIN Spawn vehicule

-- flipVehicle
function admin_vehicle_flip()
	local plyCoords = GetEntityCoords(plyPed)
	local closestCar = GetClosestVehicle(plyCoords['x'], plyCoords['y'], plyCoords['z'], 10.0, 0, 70)
	local plyCoords = plyCoords + vector3(0, 2, 0)

	SetEntityCoords(closestCar, plyCoords)

	ESX.ShowNotification("Voiture retourné")
end
-- FIN flipVehicle

-- GIVE DE L'ARGENT
function admin_give_money()
	local amount = KeyboardInput("KORIOZ_BOX_AMOUNT", "Montant (8 Caractères Maximum):", "", 8)

	if amount ~= nil then
		amount = tonumber(amount)
		
		if type(amount) == 'number' then
			TriggerServerEvent('KorioZ-PersonalMenu:Admin_giveCash', amount)
		end
	end
end
-- FIN GIVE DE L'ARGENT

-- GIVE DE L'ARGENT EN BANQUE
function admin_give_bank()
	local amount = KeyboardInput("KORIOZ_BOX_AMOUNT", "Montant (8 Caractères Maximum):", "", 8)

	if amount ~= nil then
		amount = tonumber(amount)
		
		if type(amount) == 'number' then
			TriggerServerEvent('KorioZ-PersonalMenu:Admin_giveBank', amount)
		end
	end
end
-- FIN GIVE DE L'ARGENT EN BANQUE

-- GIVE DE L'ARGENT SALE
function admin_give_dirty()
	local amount = KeyboardInput("KORIOZ_BOX_AMOUNT", "Montant (8 Caractères Maximum):", "", 8)

	if amount ~= nil then
		amount = tonumber(amount)
		
		if type(amount) == 'number' then
			TriggerServerEvent('KorioZ-PersonalMenu:Admin_giveDirtyMoney', amount)
		end
	end
end
-- FIN GIVE DE L'ARGENT SALE

-- Afficher Coord
function modo_showcoord()
	showcoord = not showcoord
end
-- FIN Afficher Coord

-- Afficher Nom
function modo_showname()
	if showname then
		showname = false
	else
		showname = true
	end
end
-- FIN Afficher Nom

-- TP MARKER
function admin_tp_marker()
	local WaypointHandle = GetFirstBlipInfoId(8)

	if DoesBlipExist(WaypointHandle) then
		local waypointCoords = GetBlipInfoIdCoord(WaypointHandle)

		for height = 1, 1000 do
			SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

			local foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords["x"], waypointCoords["y"], height + 0.0)

			if foundGround then
				SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

				break
			end

			Citizen.Wait(0)
		end

		ESX.ShowNotification("Téléporté sur le marqueur !")
	else
		ESX.ShowNotification("Pas de marqueur sur la carte !")
	end
end
-- FIN TP MARKER

-- HEAL JOUEUR
function admin_heal_player()
	local plyId = KeyboardInput("KORIOZ_BOX_ID", "ID du Joueur (8 Caractères Maximum):", "", 8)

	if plyId ~= nil then
		plyId = tonumber(plyId)
		
		if type(plyId) == 'number' then
			TriggerServerEvent('esx_ambulancejob:revive', plyId)
		end
	end
end
-- FIN HEAL JOUEUR

function changer_skin()
	_menuPool:CloseAllMenus()
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
	ESX.Streaming.RequestAnimDict(lib, function()
		TaskPlayAnim(plyPed, lib, anim, 8.0, 1.0, -1, 49, 0, false, false, false)
	end)
end

function startScenario(anim)
	TaskStartScenarioInPlace(plyPed, anim, 0, false)
end

function AddMenuInventoryMenu(menu)
	inventorymenu = _menuPool:AddSubMenu(menu, "Inventaire")
	local invCount = {}

	for i=1, #ESX.PlayerData.inventory, 1 do
		if ESX.PlayerData.inventory[i].count > 0 then
			local label	    = ESX.PlayerData.inventory[i].label
			local count	    = ESX.PlayerData.inventory[i].count
			local value	    = ESX.PlayerData.inventory[i].name
			local usable	= ESX.PlayerData.inventory[i].usable
			local rare	    = ESX.PlayerData.inventory[i].rare
			local canRemove = ESX.PlayerData.inventory[i].canRemove

			invCount = {}
			local okCount = 0

			for i = 1, count, 1 do
				okCount = okCount + 1
				table.insert(invCount, okCount)
			end
			
			table.insert(invItem, value)

			invItem[value] = NativeUI.CreateListItem(label .. " (" .. count .. ")", invCount, 1)
			inventorymenu.SubMenu:AddItem(invItem[value])
		end
	end

	local useItem = NativeUI.CreateItem("Utiliser", "")
	itemMenu:AddItem(useItem)

	local giveItem = NativeUI.CreateItem("Donner", "")
	itemMenu:AddItem(giveItem)

	local dropItem = NativeUI.CreateItem("Jeter", "")
	dropItem:SetRightBadge(4)
	itemMenu:AddItem(dropItem)

	inventorymenu.SubMenu.OnListSelect = function(sender, item, index)
		_menuPool:CloseAllMenus(true)
		itemMenu:Visible(true)

		for i = 1, #ESX.PlayerData.inventory, 1 do
			local label	    = ESX.PlayerData.inventory[i].label
			local count	    = ESX.PlayerData.inventory[i].count
			local value	    = ESX.PlayerData.inventory[i].name
			local usable	= ESX.PlayerData.inventory[i].usable
			local rare	    = ESX.PlayerData.inventory[i].rare
			local canRemove = ESX.PlayerData.inventory[i].canRemove
			local quantity  = index

			if item == invItem[value] then
				itemMenu.OnItemSelect = function(sender, item, index)
					if item == useItem then
						if usable then
							TriggerServerEvent('esx:useItem', value)
						else
							ESX.ShowNotification(label .. " n'est pas utilisable")
						end
					elseif item == giveItem then
						local foundPlayers = false
						personalmenu.closestPlayer, personalmenu.closestDistance = ESX.Game.GetClosestPlayer()

						if personalmenu.closestDistance ~= -1 and personalmenu.closestDistance <= 3 then
			 				foundPlayers = true
						end

						if foundPlayers == true then
							local closestPed = GetPlayerPed(personalmenu.closestPlayer)

							if not IsPedSittingInAnyVehicle(closestPed) then
								if quantity ~= nil and count > 0 then
									TriggerServerEvent('esx:giveInventoryItem', GetPlayerServerId(personalmenu.closestPlayer), 'item_standard', value, quantity)
									_menuPool:CloseAllMenus()
								else
									ESX.ShowNotification("Montant Invalide")
								end
							else
								ESX.ShowNotification("Impossible de donner " .. label .. " dans un véhicule")
							end
						else
							ESX.ShowNotification("Aucun citoyen à proximité")
						end
					elseif item == dropItem then
						if canRemove then
							if not IsPedSittingInAnyVehicle(closestPed) then
								if quantity ~= nil then
									TriggerServerEvent('esx:removeInventoryItem', 'item_standard', value, quantity)
									_menuPool:CloseAllMenus()
								else
									ESX.ShowNotification("Montant Invalide")
								end
							else
								ESX.ShowNotification("Impossible de jeter de l'argent dans un véhicule")
							end
						else
							ESX.ShowNotification(label .. " n'est pas jetable")
						end
					end
				end
			end
		end
	end
end

function AddMenuWalletMenu(menu)
	local moneyOption = {}
	
	moneyOption = {
		"Donner",
		"Jeter"
	}

	walletmenu = _menuPool:AddSubMenu(menu, "Portefeuille")

	local walletJob = NativeUI.CreateItem("Métier: " .. ESX.PlayerData.job.label .. " - " .. ESX.PlayerData.job.grade_label, "")
	walletmenu.SubMenu:AddItem(walletJob)

	if Config.doublejob then
		local walletJob2 = NativeUI.CreateItem("Organisation: " .. ESX.PlayerData.job2.label .. " - " .. ESX.PlayerData.job2.grade_label, "")
		walletmenu.SubMenu:AddItem(walletJob2)
	end

	local walletMoney = NativeUI.CreateListItem("Argent: $" .. ESX.Math.GroupDigits(ESX.PlayerData.money), moneyOption, 1)
	walletmenu.SubMenu:AddItem(walletMoney)

	local walletdirtyMoney = nil

	for i = 1, #ESX.PlayerData.accounts, 1 do
		if ESX.PlayerData.accounts[i].name == 'black_money' then
			walletdirtyMoney = NativeUI.CreateListItem("Argent Sale: $" .. ESX.Math.GroupDigits(ESX.PlayerData.accounts[i].money), moneyOption, 1)
			walletmenu.SubMenu:AddItem(walletdirtyMoney)
		elseif ESX.PlayerData.accounts[i].name == 'point' then
			walletPoint = NativeUI.CreateItem("Point de Loyauté: " .. ESX.Math.GroupDigits(ESX.PlayerData.accounts[i].money), "")
			walletmenu.SubMenu:AddItem(walletPoint)
		end
	end

	if Config.EnableESXIdentity then
		local showID = NativeUI.CreateItem("Montrer sa carte d'identité", "")
		walletmenu.SubMenu:AddItem(showID)

		local checkID = NativeUI.CreateItem("Regarder sa carte d'identité", "")
		walletmenu.SubMenu:AddItem(checkID)

		walletmenu.SubMenu.OnItemSelect = function(sender, item, index)
			if item == showID then
				personalmenu.closestPlayer, personalmenu.closestDistance = ESX.Game.GetClosestPlayer()
											
				if personalmenu.closestDistance ~= -1 and personalmenu.closestDistance <= 3.0 then
					TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(personalmenu.closestPlayer))
				else
					ESX.ShowNotification("Aucun citoyen à proximité")
				end
			elseif item == checkID then
				TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()))
			end
		end
	end

	walletmenu.SubMenu.OnListSelect = function(sender, item, index)
		if item == walletMoney or item == walletdirtyMoney then
			if index == 1 then
				local quantity = KeyboardInput("KORIOZ_BOX_AMOUNT", "Montant (8 Caractères Maximum):", "", 8)

				if quantity ~= nil then
					local post = true
					quantity = tonumber(quantity)

					if type(quantity) == 'number' then
						quantity = ESX.Math.Round(quantity)

						if quantity <= 0 then
							post = false
						end
					end

					local foundPlayers = false
					personalmenu.closestPlayer, personalmenu.closestDistance = ESX.Game.GetClosestPlayer()

					if personalmenu.closestDistance ~= -1 and personalmenu.closestDistance <= 3 then
						foundPlayers = true
					end

					if foundPlayers == true then
						local closestPed = GetPlayerPed(personalmenu.closestPlayer)

						if not IsPedSittingInAnyVehicle(closestPed) then
							if post == true then
								if item == walletMoney then
									TriggerServerEvent('esx:giveInventoryItem', GetPlayerServerId(personalmenu.closestPlayer), 'item_money', 'money', quantity)
									_menuPool:CloseAllMenus()
								elseif item == walletdirtyMoney then
									TriggerServerEvent('esx:giveInventoryItem', GetPlayerServerId(personalmenu.closestPlayer), 'item_account', 'black_money', quantity)
									_menuPool:CloseAllMenus()
								end
							else
								ESX.ShowNotification("Montant Invalide")
							end
						else
							ESX.ShowNotification("Impossible de donner de l'argent dans un véhicule")
						end
					else
						ESX.ShowNotification("Aucun citoyen à proximité")
					end
				end
			elseif index == 2 then
				local quantity = KeyboardInput("KORIOZ_BOX_AMOUNT", "Montant (8 Caractères Maximum):", "", 8)

				if quantity ~= nil then
					local post = true
					quantity = tonumber(quantity)

					if type(quantity) == 'number' then
						quantity = ESX.Math.Round(quantity)

						if quantity <= 0 then
							post = false
						end
					end

					if not IsPedSittingInAnyVehicle(closestPed) then
						if post == true then
							if item == walletMoney then
								TriggerServerEvent('esx:removeInventoryItem', 'item_money', 'money', quantity)
								_menuPool:CloseAllMenus()
							elseif item == walletdirtyMoney then
								TriggerServerEvent('esx:removeInventoryItem', 'item_account', 'black_money', quantity)
								_menuPool:CloseAllMenus()
							end
						else
							ESX.ShowNotification("Montant Invalide")
						end
					else
						ESX.ShowNotification("Impossible de jeter de l'argent dans un véhicule")
					end
				end
			end
		end
	end
end

function AddMenuFacturesMenu(menu)
	billMenu = _menuPool:AddSubMenu(menu, "Factures")
	billItem = {}
	
	ESX.TriggerServerCallback('KorioZ-PersonalMenu:Bill_getBills', function(bills)
		for i = 1, #bills, 1 do
			local label = bills[i].label
			local amount = bills[i].amount
			local value = bills[i].id

			table.insert(billItem, value)

			billItem[value] = NativeUI.CreateItem(label, "")
			billItem[value]:RightLabel("$" .. ESX.Math.GroupDigits(amount))
			billMenu.SubMenu:AddItem(billItem[value])
		end

		billMenu.SubMenu.OnItemSelect = function(sender, item, index)
			for i = 1, #bills, 1 do
				local label  = bills[i].label
				local value = bills[i].id

				if item == billItem[value] then
					ESX.TriggerServerCallback('esx_billing:payBill', function()
						_menuPool:CloseAllMenus()
					end, value)
				end
			end
		end
	end)
end

function AddMenuClothesMenu(menu)
	clothesMenu = _menuPool:AddSubMenu(menu, "Vêtements")

	local torsoItem = NativeUI.CreateItem("Haut", "")
	clothesMenu.SubMenu:AddItem(torsoItem)
	local pantsItem = NativeUI.CreateItem("Bas", "")
	clothesMenu.SubMenu:AddItem(pantsItem)
	local shoesItem = NativeUI.CreateItem("Chaussures", "")
	clothesMenu.SubMenu:AddItem(shoesItem)
	local bagItem = NativeUI.CreateItem("Sac", "")
	clothesMenu.SubMenu:AddItem(bagItem)
	local bproofItem = NativeUI.CreateItem("Gilet Par Balle", "")
	clothesMenu.SubMenu:AddItem(bproofItem)

	clothesMenu.SubMenu.OnItemSelect = function(sender, item, index)
		if item == torsoItem then
			setUniform('torso', plyPed)
		elseif item == pantsItem then
			setUniform('pants', plyPed)
		elseif item == shoesItem then
			setUniform('shoes', plyPed)
		elseif item == bagItem then
			setUniform('bag', plyPed)
		elseif item == bproofItem then
			setUniform('bproof', plyPed)
		end
	end
end

function setUniform(value, plyPed)
	ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
		TriggerEvent('skinchanger:getSkin', function(skina)
			if value == 'torso' then
				startAnim("clothingtie", "try_tie_neutral_a")
				Citizen.Wait(1000)
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
					TriggerEvent('skinchanger:loadClothes', skina, {['pants_1'] = 61, ['pants_2'] = 1})
				end
			elseif value == 'shoes' then
				if skin.shoes_1 ~= skina.shoes_1 then
					TriggerEvent('skinchanger:loadClothes', skina, {['shoes_1'] = skin.shoes_1, ['shoes_2'] = skin.shoes_2})
				else
					TriggerEvent('skinchanger:loadClothes', skina, {['shoes_1'] = 34, ['shoes_2'] = 0})
				end
			elseif value == 'bag' then
				if skin.bags_1 ~= skina.bags_1 then
					TriggerEvent('skinchanger:loadClothes', skina, {['bags_1'] = skin.bags_1, ['bags_2'] = skin.bags_2})
				else
					TriggerEvent('skinchanger:loadClothes', skina, {['bags_1'] = 0, ['bags_2'] = 0})
				end
			elseif value == 'bproof' then
				startAnim("clothingtie", "try_tie_neutral_a")
				Citizen.Wait(1000)
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

function AddMenuAccessoryMenu(menu)
	accessoryMenu = _menuPool:AddSubMenu(menu, "Accessoires")

	local earsItem = NativeUI.CreateItem("Accessoire d'Oreilles", "")
	accessoryMenu.SubMenu:AddItem(earsItem)
	local glassesItem = NativeUI.CreateItem("Lunettes", "")
	accessoryMenu.SubMenu:AddItem(glassesItem)
	local helmetItem = NativeUI.CreateItem("Chapeau/Casque", "")
	accessoryMenu.SubMenu:AddItem(helmetItem)
	local maskItem = NativeUI.CreateItem("Masque", "")
	accessoryMenu.SubMenu:AddItem(maskItem)

	accessoryMenu.SubMenu.OnItemSelect = function(sender, item, index)
		if item == earsItem then
			SetUnsetAccessory('Ears')
		elseif item == glassesItem then
			SetUnsetAccessory('Glasses')
		elseif item == helmetItem then
			SetUnsetAccessory('Helmet')
		elseif item == maskItem then
			SetUnsetAccessory('Mask')
		end
	end
end

function SetUnsetAccessory(accessory)
	ESX.TriggerServerCallback('esx_accessories:get', function(hasAccessory, accessorySkin)
		local _accessory = string.lower(accessory)

		if hasAccessory then
			TriggerEvent('skinchanger:getSkin', function(skin)
				local mAccessory = -1
				local mColor = 0

				if _accessory == 'ears' then
				elseif _accessory == "glasses" then
					mAccessory = 0
					startAnim("clothingspecs", "try_glasses_positive_a")
					Citizen.Wait(1000)
					ClearPedTasks(plyPed)
				elseif _accessory == 'helmet' then
					startAnim("missfbi4", "takeoff_mask")
					Citizen.Wait(1000)
					ClearPedTasks(plyPed)
				elseif _accessory == "mask" then
					mAccessory = 0
					startAnim("missfbi4", "takeoff_mask")
					Citizen.Wait(850)
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
				ESX.ShowNotification("Vous ne possédez pas d'Accessoire d'Oreilles")
			elseif _accessory == 'glasses' then
				ESX.ShowNotification("Vous ne possédez pas de Lunettes")
			elseif _accessory == 'helmet' then
				ESX.ShowNotification("Vous ne possédez pas de Casque/Chapeau")
			elseif _accessory == 'mask' then
				ESX.ShowNotification("Vous ne possédez pas de Masque")
			end
		end

	end, accessory)
end

function AddMenuAnimationMenu(menu)
	animMenu = _menuPool:AddSubMenu(menu, "Animations")

	AddSubMenuFestivesMenu(animMenu)
	AddSubMenuSalutationsMenu(animMenu)
	AddSubMenuTravailMenu(animMenu)
	AddSubMenuHumeursMenu(animMenu)
	AddSubMenuSportsMenu(animMenu)
	AddSubMenuDiversMenu(animMenu)
	AddSubMenuPEGI21Menu(animMenu)
end

function AddSubMenuFestivesMenu(menu)
	animFeteMenu = _menuPool:AddSubMenu(menu.SubMenu, "Festives")

	local cigaretteItem = NativeUI.CreateItem("Fumer une cigarette", "")
	animFeteMenu.SubMenu:AddItem(cigaretteItem)
	local musiqueItem = NativeUI.CreateItem("Jouer de la musique", "")
	animFeteMenu.SubMenu:AddItem(musiqueItem)
	local DJItem = NativeUI.CreateItem("DJ", "")
	animFeteMenu.SubMenu:AddItem(DJItem)
	local zikItem = NativeUI.CreateItem("Bière en zik", "")
	animFeteMenu.SubMenu:AddItem(zikItem)
	local guitarItem = NativeUI.CreateItem("Air Guitar", "")
	animFeteMenu.SubMenu:AddItem(guitarItem)
	local shaggingItem = NativeUI.CreateItem("Air Shagging", "")
	animFeteMenu.SubMenu:AddItem(shaggingItem)
	local rockItem = NativeUI.CreateItem("Rock'n'roll", "")
	animFeteMenu.SubMenu:AddItem(rockItem)
	local bourreItem = NativeUI.CreateItem("Bourré sur place", "")
	animFeteMenu.SubMenu:AddItem(bourreItem)
	local vomirItem = NativeUI.CreateItem("Vomir en voiture", "")
	animFeteMenu.SubMenu:AddItem(vomirItem)

	animFeteMenu.SubMenu.OnItemSelect = function(sender, item, index)
		if item == cigaretteItem then
			startScenario("WORLD_HUMAN_SMOKING")
		elseif item == musiqueItem then
			startScenario("WORLD_HUMAN_MUSICIAN")
		elseif item == DJItem then
			startAnim("anim@mp_player_intcelebrationmale@dj", "dj")
		elseif item == zikItem then
			startScenario("WORLD_HUMAN_PARTYING")
		elseif item == guitarItem then
			startAnim("anim@mp_player_intcelebrationmale@air_guitar", "air_guitar")
		elseif item == shaggingItem then
			startAnim("anim@mp_player_intcelebrationfemale@air_shagging", "air_shagging")
		elseif item == rockItem then
			startAnim("mp_player_int_upperrock", "mp_player_int_rock")
		elseif item == bourreItem then
			startAnim("amb@world_human_bum_standing@drunk@idle_a", "idle_a")
		elseif item == vomirItem then
			startAnim("oddjobs@taxi@tie", "vomit_outside")
		end
	end
end

function AddSubMenuSalutationsMenu(menu)
	animSaluteMenu = _menuPool:AddSubMenu(menu.SubMenu, "Salutations")

	local saluerItem = NativeUI.CreateItem("Saluer", "")
	animSaluteMenu.SubMenu:AddItem(saluerItem)
	local serrerItem = NativeUI.CreateItem("Serrer la main", "")
	animSaluteMenu.SubMenu:AddItem(serrerItem)
	local tchekItem = NativeUI.CreateItem("Tchek", "")
	animSaluteMenu.SubMenu:AddItem(tchekItem)
	local banditItem = NativeUI.CreateItem("Salut bandit", "")
	animSaluteMenu.SubMenu:AddItem(banditItem)
	local militaireItem = NativeUI.CreateItem("Salut Militaire", "")
	animSaluteMenu.SubMenu:AddItem(militaireItem)

	animSaluteMenu.SubMenu.OnItemSelect = function(sender, item, index)
		if item == saluerItem then
			startAnim("gestures@m@standing@casual", "gesture_hello")
		elseif item == serrerItem then
			startAnim("mp_common", "givetake1_a")
		elseif item == tchekItem then
			startAnim("mp_ped_interaction", "handshake_guy_a")
		elseif item == banditItem then
			startAnim("mp_ped_interaction", "hugs_guy_a")
		elseif item == militaireItem then
			startAnim("mp_player_int_uppersalute", "mp_player_int_salute")
		end
	end
end

function AddSubMenuTravailMenu(menu)
	animTravailMenu = _menuPool:AddSubMenu(menu.SubMenu, "Travail")

	local suspectItem = NativeUI.CreateItem("Se rendre", "")
	animTravailMenu.SubMenu:AddItem(suspectItem)
	local pecheurItem = NativeUI.CreateItem("Pêcheur", "")
	animTravailMenu.SubMenu:AddItem(pecheurItem)
	local pEnqueterItem = NativeUI.CreateItem("Police : enquêter", "")
	animTravailMenu.SubMenu:AddItem(pEnqueterItem)
	local pRadioItem = NativeUI.CreateItem("Police : parler à la radio", "")
	animTravailMenu.SubMenu:AddItem(pRadioItem)
	local pCirculationItem = NativeUI.CreateItem("Police : circulation", "")
	animTravailMenu.SubMenu:AddItem(pCirculationItem)
	local pJumelleItem = NativeUI.CreateItem("Police : jumelles", "")
	animTravailMenu.SubMenu:AddItem(pJumelleItem)
	local aRecolterItem = NativeUI.CreateItem("Agriculture : récolter", "")
	animTravailMenu.SubMenu:AddItem(aRecolterItem)
	local dReparerItem = NativeUI.CreateItem("Dépanneur : réparer le moteur", "")
	animTravailMenu.SubMenu:AddItem(dReparerItem)
	local mObserverItem = NativeUI.CreateItem("Médecin : observer", "")
	animTravailMenu.SubMenu:AddItem(mObserverItem)
	local tParlerItem = NativeUI.CreateItem("Taxi : parler au client", "")
	animTravailMenu.SubMenu:AddItem(tParlerItem)
	local tFacturerItem = NativeUI.CreateItem("Taxi : donner la facture", "")
	animTravailMenu.SubMenu:AddItem(tFacturerItem)
	local eCoursesItem = NativeUI.CreateItem("Epicier : donner les courses", "")
	animTravailMenu.SubMenu:AddItem(eCoursesItem)
	local bShotItem = NativeUI.CreateItem("Barman : servir un shot", "")
	animTravailMenu.SubMenu:AddItem(bShotItem)
	local jPhotoItem = NativeUI.CreateItem("Journaliste : Prendre une photo", "")
	animTravailMenu.SubMenu:AddItem(jPhotoItem)
	local NotesItem = NativeUI.CreateItem("Tout : Prendre des notes", "")
	animTravailMenu.SubMenu:AddItem(NotesItem)
	local MarteauItem = NativeUI.CreateItem("Tout : Coup de marteau", "")
	animTravailMenu.SubMenu:AddItem(MarteauItem)
	local sdfMancheItem = NativeUI.CreateItem("SDF : Faire la manche", "")
	animTravailMenu.SubMenu:AddItem(sdfMancheItem)
	local sdfStatueItem = NativeUI.CreateItem("SDF : Faire la statue", "")
	animTravailMenu.SubMenu:AddItem(sdfStatueItem)

	animTravailMenu.SubMenu.OnItemSelect = function(sender, item, index)
		if item == suspectItem then
			startAnim("random@arrests@busted", "idle_c")
		elseif item == pecheurItem then
			startScenario("world_human_stand_fishing")
		elseif item == pEnqueterItem then
			startAnim("amb@code_human_police_investigate@idle_b", "idle_f")
		elseif item == pRadioItem then
			startAnim("random@arrests", "generic_radio_chatter")
		elseif item == pCirculationItem then
			startScenario("WORLD_HUMAN_CAR_PARK_ATTENDANT")
		elseif item == pJumelleItem then
			startScenario("WORLD_HUMAN_BINOCULARS")
		elseif item == aRecolterItem then
			startScenario("world_human_gardener_plant")
		elseif item == dReparerItem then
			startAnim("mini@repair", "fixing_a_ped")
		elseif item == mObserverItem then
			startScenario("CODE_HUMAN_MEDIC_KNEEL")
		elseif item == tParlerItem then
			startAnim("oddjobs@taxi@driver", "leanover_idle")
		elseif item == tFacturerItem then
			startAnim("oddjobs@taxi@cyi", "std_hand_off_ps_passenger")
		elseif item == eCoursesItem then
			startAnim("mp_am_hold_up", "purchase_beerbox_shopkeeper")
		elseif item == bShotItem then
			startAnim("mini@drinking", "shots_barman_b")
		elseif item == jPhotoItem then
			startScenario("WORLD_HUMAN_PAPARAZZI")
		elseif item == NotesItem then
			startScenario("WORLD_HUMAN_CLIPBOARD")
		elseif item == MarteauItem then
			startScenario("WORLD_HUMAN_HAMMERING")
		elseif item == sdfMancheItem then
			startScenario("WORLD_HUMAN_BUM_FREEWAY")
		elseif item == sdfStatueItem then
			startScenario("WORLD_HUMAN_HUMAN_STATUE")
		end
	end
end

function AddSubMenuHumeursMenu(menu)
	animHumeurMenu = _menuPool:AddSubMenu(menu.SubMenu, "Humeurs")

	local feliciterItem = NativeUI.CreateItem("Féliciter", "")
	animHumeurMenu.SubMenu:AddItem(feliciterItem)
	local superItem = NativeUI.CreateItem("Super", "")
	animHumeurMenu.SubMenu:AddItem(superItem)
	local toiItem = NativeUI.CreateItem("Toi", "")
	animHumeurMenu.SubMenu:AddItem(toiItem)
	local viensItem = NativeUI.CreateItem("Viens", "")
	animHumeurMenu.SubMenu:AddItem(viensItem)
	local keskyaItem = NativeUI.CreateItem("Keskya ?", "")
	animHumeurMenu.SubMenu:AddItem(keskyaItem)
	local moiItem = NativeUI.CreateItem("A moi", "")
	animHumeurMenu.SubMenu:AddItem(moiItem)
	local putainItem = NativeUI.CreateItem("Je le savais, putain", "")
	animHumeurMenu.SubMenu:AddItem(putainItem)
	local epuiserItem = NativeUI.CreateItem("Etre épuisé", "")
	animHumeurMenu.SubMenu:AddItem(epuiserItem)
	local merdeItem = NativeUI.CreateItem("Je suis dans la merde", "")
	animHumeurMenu.SubMenu:AddItem(merdeItem)
	local facepalmItem = NativeUI.CreateItem("Facepalm", "")
	animHumeurMenu.SubMenu:AddItem(facepalmItem)
	local calmeItem = NativeUI.CreateItem("Calme-toi ", "")
	animHumeurMenu.SubMenu:AddItem(calmeItem)
	local jaifaitItem = NativeUI.CreateItem("Qu'est ce que j'ai fait ?", "")
	animHumeurMenu.SubMenu:AddItem(jaifaitItem)
	local peurItem = NativeUI.CreateItem("Avoir peur", "")
	animHumeurMenu.SubMenu:AddItem(peurItem)
	local fightItem = NativeUI.CreateItem("Fight ?", "")
	animHumeurMenu.SubMenu:AddItem(fightItem)
	local paspossibleItem = NativeUI.CreateItem("C'est pas Possible !", "")
	animHumeurMenu.SubMenu:AddItem(paspossibleItem)
	local enlacerItem = NativeUI.CreateItem("Enlacer", "")
	animHumeurMenu.SubMenu:AddItem(enlacerItem)
	local doigtItem = NativeUI.CreateItem("Doigt d'honneur", "")
	animHumeurMenu.SubMenu:AddItem(doigtItem)
	local branleurItem = NativeUI.CreateItem("Branleur", "")
	animHumeurMenu.SubMenu:AddItem(branleurItem)
	local balleItem = NativeUI.CreateItem("Balle dans la tete", "")
	animHumeurMenu.SubMenu:AddItem(balleItem)

	animHumeurMenu.SubMenu.OnItemSelect = function(sender, item, index)
		if item == feliciterItem then
			startScenario("WORLD_HUMAN_CHEERING")
		elseif item == superItem then
			startAnim("mp_action", "thanks_male_06")
		elseif item == toiItem then
			startAnim("gestures@m@standing@casual", "gesture_point")
		elseif item == viensItem then
			startAnim("gestures@m@standing@casual", "gesture_come_here_soft")
		elseif item == keskyaItem then
			startAnim("gestures@m@standing@casual", "gesture_bring_it_on")
		elseif item == moiItem then
			startAnim("gestures@m@standing@casual", "gesture_me")
		elseif item == putainItem then
			startAnim("anim@am_hold_up@male", "shoplift_high")
		elseif item == epuiserItem then
			startAnim("amb@world_human_jog_standing@male@idle_b", "idle_d")
		elseif item == merdeItem then
			startAnim("amb@world_human_bum_standing@depressed@idle_a", "idle_a")
		elseif item == facepalmItem then
			startAnim("anim@mp_player_intcelebrationmale@face_palm", "face_palm")
		elseif item == calmeItem then
			startAnim("gestures@m@standing@casual", "gesture_easy_now")
		elseif item == jaifaitItem then
			startAnim("oddjobs@assassinate@multi@", "react_big_variations_a")
		elseif item == peurItem then
			startAnim("amb@code_human_cower_stand@male@react_cowering", "base_right")
		elseif item == fightItem then
			startAnim("anim@deathmatch_intros@unarmed", "intro_male_unarmed_e")
		elseif item == paspossibleItem then
			startAnim("gestures@m@standing@casual", "gesture_damn")
		elseif item == enlacerItem then
			startAnim("mp_ped_interaction", "kisses_guy_a")
		elseif item == doigtItem then
			startAnim("mp_player_int_upperfinger", "mp_player_int_finger_01_enter")
		elseif item == branleurItem then
			startAnim("mp_player_int_upperwank", "mp_player_int_wank_01")
		elseif item == balleItem then
			startAnim("mp_suicide", "pistol")
		end
	end
end

function AddSubMenuSportsMenu(menu)
	animSportMenu = _menuPool:AddSubMenu(menu.SubMenu, "Sports")

	local muscleItem = NativeUI.CreateItem("Montrer ses muscles", "")
	animSportMenu.SubMenu:AddItem(muscleItem)
	local muscuItem = NativeUI.CreateItem("Barre de musculation", "")
	animSportMenu.SubMenu:AddItem(muscuItem)
	local pompeItem = NativeUI.CreateItem("Faire des pompes", "")
	animSportMenu.SubMenu:AddItem(pompeItem)
	local abdoItem = NativeUI.CreateItem("Faire des abdos", "")
	animSportMenu.SubMenu:AddItem(abdoItem)
	local yogaItem = NativeUI.CreateItem("Faire du yoga", "")
	animSportMenu.SubMenu:AddItem(yogaItem)

	animSportMenu.SubMenu.OnItemSelect = function(sender, item, index)
		if item == muscleItem then
			startAnim("amb@world_human_muscle_flex@arms_at_side@base", "base")
		elseif item == muscuItem then
			startAnim("amb@world_human_muscle_free_weights@male@barbell@base", "base")
		elseif item == pompeItem then
			startAnim("amb@world_human_push_ups@male@base", "base")
		elseif item == abdoItem then
			startAnim("amb@world_human_sit_ups@male@base", "base")
		elseif item == yogaItem then
			startAnim("amb@world_human_yoga@male@base", "base_a")
		end
	end
end

function AddSubMenuDiversMenu(menu)
	animDiversMenu = _menuPool:AddSubMenu(menu.SubMenu, "Divers")

	local zikItem = NativeUI.CreateItem("Bière en Zik", "")
	animDiversMenu.SubMenu:AddItem(zikItem)
	local asseoirItem = NativeUI.CreateItem("S'asseoir", "")
	animDiversMenu.SubMenu:AddItem(asseoirItem)
	local murItem = NativeUI.CreateItem("Attendre contre un mur", "")
	animDiversMenu.SubMenu:AddItem(murItem)
	local dosItem = NativeUI.CreateItem("Couché sur le dos", "")
	animDiversMenu.SubMenu:AddItem(dosItem)
	local ventreItem = NativeUI.CreateItem("Couché sur le ventre", "")
	animDiversMenu.SubMenu:AddItem(ventreItem)
	local nettoyerItem = NativeUI.CreateItem("Nettoyer quelque chose", "")
	animDiversMenu.SubMenu:AddItem(nettoyerItem)
	local mangerItem = NativeUI.CreateItem("Préparer à manger", "")
	animDiversMenu.SubMenu:AddItem(mangerItem)
	local fouilleItem = NativeUI.CreateItem("Position de Fouille", "")
	animDiversMenu.SubMenu:AddItem(fouilleItem)
	local selfieItem = NativeUI.CreateItem("Prendre un selfie", "")
	animDiversMenu.SubMenu:AddItem(selfieItem)
	local porteItem = NativeUI.CreateItem("Ecouter à une porte", "")
	animDiversMenu.SubMenu:AddItem(porteItem)

	animDiversMenu.SubMenu.OnItemSelect = function(sender, item, index)
		if item == zikItem then
			startScenario("WORLD_HUMAN_DRINKING")
		elseif item == asseoirItem then
			startAnim("anim@heists@prison_heistunfinished_biztarget_idle", "target_idle")
		elseif item == murItem then
			startScenario("world_human_leaning")
		elseif item == dosItem then
			startScenario("WORLD_HUMAN_SUNBATHE_BACK")
		elseif item == ventreItem then
			startScenario("WORLD_HUMAN_SUNBATHE")
		elseif item == nettoyerItem then
			startScenario("world_human_maid_clean")
		elseif item == mangerItem then
			startScenario("PROP_HUMAN_BBQ")
		elseif item == fouilleItem then
			startAnim("mini@prostitutes@sexlow_veh", "low_car_bj_to_prop_female")
		elseif item == selfieItem then
			startScenario("world_human_tourist_mobile")
		elseif item == porteItem then
			startAnim("mini@safe_cracking", "idle_base")
		end
	end
end

function AddSubMenuPEGI21Menu(menu)
	animPegiMenu = _menuPool:AddSubMenu(menu.SubMenu, "PEGI 21")

	local hSuceItem = NativeUI.CreateItem("Homme se faire su* en voiture", "")
	animPegiMenu.SubMenu:AddItem(hSuceItem)
	local fSuceItem = NativeUI.CreateItem("Femme faire une gaterie en voiture", "")
	animPegiMenu.SubMenu:AddItem(fSuceItem)
	local hBaiserItem = NativeUI.CreateItem("Homme bais en voiture", "")
	animPegiMenu.SubMenu:AddItem(hBaiserItem)
	local fBaiserItem = NativeUI.CreateItem("Femme bais** en voiture", "")
	animPegiMenu.SubMenu:AddItem(fBaiserItem)
	local gratterItem = NativeUI.CreateItem("Se gratter les couilles", "")
	animPegiMenu.SubMenu:AddItem(gratterItem)
	local charmeItem = NativeUI.CreateItem("Faire du charme", "")
	animPegiMenu.SubMenu:AddItem(charmeItem)
	local michtoItem = NativeUI.CreateItem("Pose michto", "")
	animPegiMenu.SubMenu:AddItem(michtoItem)
	local poitrineItem = NativeUI.CreateItem("Montrer sa poitrine", "")
	animPegiMenu.SubMenu:AddItem(poitrineItem)
	local strip1Item = NativeUI.CreateItem("Strip Tease 1", "")
	animPegiMenu.SubMenu:AddItem(strip1Item)
	local strip2Item = NativeUI.CreateItem("Strip Tease 2", "")
	animPegiMenu.SubMenu:AddItem(strip2Item)
	local stripsolItem = NativeUI.CreateItem("Stip Tease au sol", "")
	animPegiMenu.SubMenu:AddItem(stripsolItem)

	animPegiMenu.SubMenu.OnItemSelect = function(sender, item, index)
		if item == hSuceItem then
			startAnim("oddjobs@towing", "m_blow_job_loop")
		elseif item == fSuceItem then
			startAnim("oddjobs@towing", "f_blow_job_loop")
		elseif item == hBaiserItem then
			startAnim("mini@prostitutes@sexlow_veh", "low_car_sex_loop_player")
		elseif item == fBaiserItem then
			startAnim("mini@prostitutes@sexlow_veh", "low_car_sex_loop_female")
		elseif item == gratterItem then
			startAnim("mp_player_int_uppergrab_crotch", "mp_player_int_grab_crotch")
		elseif item == charmeItem then
			startAnim("mini@strip_club@idles@stripper", "stripper_idle_02")
		elseif item == michtoItem then
			startScenario("WORLD_HUMAN_PROSTITUTE_HIGH_CLASS")
		elseif item == poitrineItem then
			startAnim("mini@strip_club@backroom@", "stripper_b_backroom_idle_b")
		elseif item == strip1Item then
			startAnim("mini@strip_club@lap_dance@ld_girl_a_song_a_p1", "ld_girl_a_song_a_p1_f")
		elseif item == strip2Item then
			startAnim("mini@strip_club@private_dance@part2", "priv_dance_p2")
		elseif item == stripsolItem then
			startAnim("mini@strip_club@private_dance@part3", "priv_dance_p3")
		end
	end
end

function AddMenuWeaponMenu(menu)
	weaponMenu = _menuPool:AddSubMenu(menu, "Gestion des armes")

	for i=1, #Config.Weapons, 1 do
		local weaponHash = GetHashKey(Config.Weapons[i].name)

		if HasPedGotWeapon(plyPed, weaponHash, false) and Config.Weapons[i].name ~= 'WEAPON_UNARMED' then
			local ammo 		= GetAmmoInPedWeapon(plyPed, weaponHash)
			local label	    = Config.Weapons[i].label .. ' [' .. ammo .. ']'
			local count	    = 1
			local type	    = 'item_weapon'
			local value	    = Config.Weapons[i].name
			local ammo	    = ammo
			local usable	= false
			local rare	    = false
			local canRemove = true

			wepItem[value] = NativeUI.CreateItem(label, "")
			weaponMenu.SubMenu:AddItem(wepItem[value])
		end
	end

	local giveItem = NativeUI.CreateItem("Donner", "")
	weaponItemMenu:AddItem(giveItem)

	local giveMunItem = NativeUI.CreateItem("Donner Munitions", "")
	weaponItemMenu:AddItem(giveMunItem)

	local dropItem = NativeUI.CreateItem("Jeter", "")
	dropItem:SetRightBadge(4)
	weaponItemMenu:AddItem(dropItem)

	weaponMenu.SubMenu.OnItemSelect = function(sender, item, index)
		_menuPool:CloseAllMenus(true)
		weaponItemMenu:Visible(true)

		for i = 1, #Config.Weapons, 1 do
			local weaponHash = GetHashKey(Config.Weapons[i].name)

			if HasPedGotWeapon(plyPed, weaponHash, false) and Config.Weapons[i].name ~= 'WEAPON_UNARMED' then
				local ammo 		= GetAmmoInPedWeapon(plyPed, weaponHash)
				local label	    = Config.Weapons[i].label .. ' [' .. ammo .. ']'
				local count	    = 1
				local value	    = Config.Weapons[i].name
				local ammo	    = ammo
				local usable	= false
				local rare	    = false
				local canRemove = true

				if item == wepItem[value] then
					weaponItemMenu.OnItemSelect = function(sender, item, index)
						if item == giveItem then
							local foundPlayers = false
							personalmenu.closestPlayer, personalmenu.closestDistance = ESX.Game.GetClosestPlayer()
							local sourceAmmo = GetAmmoInPedWeapon(plyPed, GetHashKey(value))

							if personalmenu.closestDistance ~= -1 and personalmenu.closestDistance <= 3 then
				 				foundPlayers = true
							end

							if foundPlayers == true then
								local closestPed = GetPlayerPed(personalmenu.closestPlayer)

								if not IsPedSittingInAnyVehicle(closestPed) then
									TriggerServerEvent('esx:giveInventoryItem', GetPlayerServerId(personalmenu.closestPlayer), 'item_weapon', value, sourceAmmo)
									_menuPool:CloseAllMenus()
								else
									ESX.ShowNotification("Impossible de donner " .. label .. " dans un véhicule")
								end
							else
								ESX.ShowNotification("Aucun citoyen à proximité")
							end
						elseif item == giveMunItem then
							local quantity = KeyboardInput("KORIOZ_BOX_AMMO_AMOUNT", "Montant de Munitions (8 Caractères Maximum):", "", 8)

							if quantity ~= nil then
								local post = true
								quantity = tonumber(quantity)

								if type(quantity) == 'number' then
									quantity = ESX.Math.Round(quantity)

									if quantity <= 0 then
										post = false
									end
								end

								local foundPlayers = false
								personalmenu.closestPlayer, personalmenu.closestDistance = ESX.Game.GetClosestPlayer()
								local pedAmmo = GetAmmoInPedWeapon(plyPed, GetHashKey(value))

								if personalmenu.closestDistance ~= -1 and personalmenu.closestDistance <= 3 then
				 					foundPlayers = true
								end

								if foundPlayers == true then
									local closestPed = GetPlayerPed(personalmenu.closestPlayer)

									if not IsPedSittingInAnyVehicle(closestPed) then
										if pedAmmo > 0 then
											if post == true then
												if quantity <= pedAmmo and quantity >= 0 then
													local finalAmmoSource = math.floor(pedAmmo - quantity)
													SetPedAmmo(plyPed, value, finalAmmoSource)
													TriggerServerEvent('KorioZ-PersonalMenu:Weapon_addAmmoToPedS', personalmenu.closestPlayer, value, quantity)

													ESX.ShowNotification("Vous avez donné x" .. quantity .. " munitions à " .. GetPlayerName(personalmenu.closestPlayer))
													_menuPool:CloseAllMenus()
												else
													ESX.ShowNotification("Vous ne possédez pas autant de munitions")
												end
											else
												ESX.ShowNotification("Montant Invalide")
											end
										else
											ESX.ShowNotification("Vous ne possédez pas de munitions")
										end
									else
										ESX.ShowNotification("Impossible de donner " .. label .. " dans un véhicule")
									end
								else
									ESX.ShowNotification("Aucun citoyen à proximité")
								end
							end
						elseif item == dropItem then
							if not IsPedSittingInAnyVehicle(closestPed) then
								TriggerServerEvent('esx:removeInventoryItem', 'item_weapon', value)
								_menuPool:CloseAllMenus()
							else
								ESX.ShowNotification("Impossible de jeter " .. label .. " dans un véhicule")
							end
						end
					end
				end
			end
		end
	end
end

function AddMenuVehicleMenu(menu)
	personalmenu.avantgaucheDoorOpen = false
	personalmenu.avantdroiteDoorOpen = false
	personalmenu.arrieregaucheDoorOpen = false
	personalmenu.arrieredroiteDoorOpen = false
	personalmenu.capotDoorOpen = false
	personalmenu.coffreDoorOpen = false
	personalmenu.porteListe = {
		"Avant Gauche",
		"Avant Droite",
		"Arrière Gauche",
		"Arrière Droite"
	}

	vehiclemenu = _menuPool:AddSubMenu(menu, "Gestion véhicule")

	local vehMotorItem = NativeUI.CreateItem("Allumer/Eteindre le Moteur", "")
	vehiclemenu.SubMenu:AddItem(vehMotorItem)
	local vehPorteListItem = NativeUI.CreateListItem("Ouvrir/Fermer Porte", personalmenu.porteListe, "1")
	vehiclemenu.SubMenu:AddItem(vehPorteListItem)
	local vehCapotItem = NativeUI.CreateItem("Ouvrir/Fermer le Capot", "")
	vehiclemenu.SubMenu:AddItem(vehCapotItem)
	local vehCoffreItem = NativeUI.CreateItem("Ouvrir/Fermer le Coffre", "")
	vehiclemenu.SubMenu:AddItem(vehCoffreItem)

	vehiclemenu.SubMenu.OnItemSelect = function(sender, item, index)
		if not IsPedSittingInAnyVehicle(plyPed) then
			ESX.ShowNotification("Vous n'êtes pas dans un véhicule")
		elseif IsPedSittingInAnyVehicle(plyPed) then
			if item == vehMotorItem then
				if GetIsVehicleEngineRunning(plyVehicle) then
					ESX.ShowNotification("Moteur coupé")
					SetVehicleEngineOn(plyVehicle, false, false, true)
					SetVehicleUndriveable(plyVehicle, true)
				elseif not GetIsVehicleEngineRunning(plyVehicle) then
					ESX.ShowNotification("Moteur allumé")
					SetVehicleEngineOn(plyVehicle, true, false, true)
					SetVehicleUndriveable(plyVehicle, false)
				end
			elseif item == vehCapotItem then
				if personalmenu.capotDoorOpen == false then
					personalmenu.capotDoorOpen = true
					SetVehicleDoorOpen(plyVehicle, 4, false, false)
				elseif personalmenu.capotDoorOpen == true then
					personalmenu.capotDoorOpen = false
					SetVehicleDoorShut(plyVehicle, 4, false, false)
				end
			elseif item == vehCoffreItem then
				if personalmenu.coffreDoorOpen == false then
					personalmenu.coffreDoorOpen = true
					SetVehicleDoorOpen(plyVehicle, 5, false, false)
				elseif personalmenu.coffreDoorOpen == true then
					personalmenu.coffreDoorOpen = false
					SetVehicleDoorShut(plyVehicle, 5, false, false)
				end
			end
		end
	end

	vehiclemenu.SubMenu.OnListSelect = function(sender, item, index)
		if not IsPedSittingInAnyVehicle(plyPed) then
			ESX.ShowNotification("Vous n'êtes pas dans un véhicule")
		elseif IsPedSittingInAnyVehicle(plyPed) then
			if item == vehPorteListItem then
				if index == 1 then
					if personalmenu.avantgaucheDoorOpen == false then
						personalmenu.avantgaucheDoorOpen = true
						SetVehicleDoorOpen(plyVehicle, 0, false, false)
					elseif personalmenu.avantgaucheDoorOpen == true then
						personalmenu.avantgaucheDoorOpen = false
						SetVehicleDoorShut(plyVehicle, 0, false, false)
					end
				elseif index == 2 then
					if personalmenu.avantdroiteDoorOpen == false then
						personalmenu.avantdroiteDoorOpen = true
						SetVehicleDoorOpen(plyVehicle, 1, false, false)
					elseif personalmenu.avantdroiteDoorOpen == true then
						personalmenu.avantdroiteDoorOpen = false
						SetVehicleDoorShut(plyVehicle, 1, false, false)
					end
				elseif index == 3 then
					if personalmenu.arrieregaucheDoorOpen == false then
						personalmenu.arrieregaucheDoorOpen = true
						SetVehicleDoorOpen(plyVehicle, 2, false, false)
					elseif personalmenu.arrieregaucheDoorOpen == true then
						personalmenu.arrieregaucheDoorOpen = false
						SetVehicleDoorShut(plyVehicle, 2, false, false)
					end
				elseif index == 4 then
					if personalmenu.arrieredroiteDoorOpen == false then
						personalmenu.arrieredroiteDoorOpen = true
						SetVehicleDoorOpen(plyVehicle, 3, false, false)
					elseif personalmenu.arrieredroiteDoorOpen == true then
						personalmenu.arrieredroiteDoorOpen = false
						SetVehicleDoorShut(plyVehicle, 3, false, false)
					end
				end
			end
		end
	end
end

function AddMenuBossMenu(menu)
	bossMenu = _menuPool:AddSubMenu(menu, "Gestion Entreprise: " .. ESX.PlayerData.job.label)

	if societymoney ~= nil then
		coffreItem = NativeUI.CreateItem("Coffre Entreprise:", "")
		coffreItem:RightLabel("$"..societymoney)
		bossMenu.SubMenu:AddItem(coffreItem)
	end

	local recruterItem = NativeUI.CreateItem("Recruter", "")
	bossMenu.SubMenu:AddItem(recruterItem)
	local virerItem = NativeUI.CreateItem("Virer", "")
	bossMenu.SubMenu:AddItem(virerItem)
	local promouvoirItem = NativeUI.CreateItem("Promouvoir", "")
	bossMenu.SubMenu:AddItem(promouvoirItem)
	local destituerItem = NativeUI.CreateItem("Destituer", "")
	bossMenu.SubMenu:AddItem(destituerItem)

	bossMenu.SubMenu.OnItemSelect = function(sender, item, index)
		if item == recruterItem then
			if ESX.PlayerData.job.grade_name == 'boss' then
				personalmenu.closestPlayer, personalmenu.closestDistance = ESX.Game.GetClosestPlayer()

				if personalmenu.closestPlayer == -1 or personalmenu.closestDistance > 3.0 then
					ESX.ShowNotification("Aucun joueur à proximité")
				else
					TriggerServerEvent('KorioZ-PersonalMenu:Boss_recruterplayer', GetPlayerServerId(personalmenu.closestPlayer), ESX.PlayerData.job.name, 0)
				end
			else
				ESX.ShowNotification("Vous n'avez pas les ~r~droits~w~.")
			end
		elseif item == virerItem then
			if ESX.PlayerData.job.grade_name == 'boss' then
				personalmenu.closestPlayer, personalmenu.closestDistance = ESX.Game.GetClosestPlayer()

				if personalmenu.closestPlayer == -1 or personalmenu.closestDistance > 3.0 then
					ESX.ShowNotification("Aucun joueur à proximité")
				else
					TriggerServerEvent('KorioZ-PersonalMenu:Boss_virerplayer', GetPlayerServerId(personalmenu.closestPlayer))
				end
			else
				ESX.ShowNotification("Vous n'avez pas les ~r~droits~w~.")
			end
		elseif item == promouvoirItem then
			if ESX.PlayerData.job.grade_name == 'boss' then
				personalmenu.closestPlayer, personalmenu.closestDistance = ESX.Game.GetClosestPlayer()

				if personalmenu.closestPlayer == -1 or personalmenu.closestDistance > 3.0 then
					ESX.ShowNotification("Aucun joueur à proximité")
				else
					TriggerServerEvent('KorioZ-PersonalMenu:Boss_promouvoirplayer', GetPlayerServerId(personalmenu.closestPlayer))
				end
			else
				ESX.ShowNotification("Vous n'avez pas les ~r~droits~w~.")
			end
		elseif item == destituerItem then
			if ESX.PlayerData.job.grade_name == 'boss' then
				personalmenu.closestPlayer, personalmenu.closestDistance = ESX.Game.GetClosestPlayer()

				if personalmenu.closestPlayer == -1 or personalmenu.closestDistance > 3.0 then
					ESX.ShowNotification("Aucun joueur à proximité")
				else
					TriggerServerEvent('KorioZ-PersonalMenu:Boss_destituerplayer', GetPlayerServerId(personalmenu.closestPlayer))
				end
			else
				ESX.ShowNotification("Vous n'avez pas les ~r~droits~w~.")
			end
		end
	end
end

function AddMenuBossMenu2(menu)
	bossMenu2 = _menuPool:AddSubMenu(menu, "Gestion Organisation: " .. ESX.PlayerData.job2.label)

	if societymoney2 ~= nil then
		coffre2Item = NativeUI.CreateItem("Coffre Organisation:", "")
		coffre2Item:RightLabel("$"..societymoney2)
		bossMenu2.SubMenu:AddItem(coffre2Item)
	end

	local recruter2Item = NativeUI.CreateItem("Recruter", "")
	bossMenu2.SubMenu:AddItem(recruter2Item)
	local virer2Item = NativeUI.CreateItem("Virer", "")
	bossMenu2.SubMenu:AddItem(virer2Item)
	local promouvoir2Item = NativeUI.CreateItem("Promouvoir", "")
	bossMenu2.SubMenu:AddItem(promouvoir2Item)
	local destituer2Item = NativeUI.CreateItem("Destituer", "")
	bossMenu2.SubMenu:AddItem(destituer2Item)

	bossMenu2.SubMenu.OnItemSelect = function(sender, item, index)
		if item == recruter2Item then
			if ESX.PlayerData.job2.grade_name == 'boss' then
				personalmenu.closestPlayer, personalmenu.closestDistance = ESX.Game.GetClosestPlayer()

				if personalmenu.closestPlayer == -1 or personalmenu.closestDistance > 3.0 then
					ESX.ShowNotification("Aucun joueur à proximité")
				else
					TriggerServerEvent('KorioZ-PersonalMenu:Boss_recruterplayer2', GetPlayerServerId(personalmenu.closestPlayer), ESX.PlayerData.job2.name, 0)
				end
			else
				ESX.ShowNotification("Vous n'avez pas les ~r~droits~w~.")
			end
		elseif item == virer2Item then
			if ESX.PlayerData.job2.grade_name == 'boss' then
				personalmenu.closestPlayer, personalmenu.closestDistance = ESX.Game.GetClosestPlayer()

				if personalmenu.closestPlayer == -1 or personalmenu.closestDistance > 3.0 then
					ESX.ShowNotification("Aucun joueur à proximité")
				else
					TriggerServerEvent('KorioZ-PersonalMenu:Boss_virerplayer2', GetPlayerServerId(personalmenu.closestPlayer))
				end
			else
				ESX.ShowNotification("Vous n'avez pas les ~r~droits~w~.")
			end
		elseif item == promouvoir2Item then
			if ESX.PlayerData.job2.grade_name == 'boss' then
				personalmenu.closestPlayer, personalmenu.closestDistance = ESX.Game.GetClosestPlayer()

				if personalmenu.closestPlayer == -1 or personalmenu.closestDistance > 3.0 then
					ESX.ShowNotification("Aucun joueur à proximité")
				else
					TriggerServerEvent('KorioZ-PersonalMenu:Boss_promouvoirplayer2', GetPlayerServerId(personalmenu.closestPlayer))
				end
			else
				ESX.ShowNotification("Vous n'avez pas les ~r~droits~w~.")
			end
		elseif item == destituer2Item then
			if ESX.PlayerData.job2.grade_name == 'boss' then
				personalmenu.closestPlayer, personalmenu.closestDistance = ESX.Game.GetClosestPlayer()

				if personalmenu.closestPlayer == -1 or personalmenu.closestDistance > 3.0 then
					ESX.ShowNotification("Aucun joueur à proximité")
				else
					TriggerServerEvent('KorioZ-PersonalMenu:Boss_destituerplayer2', GetPlayerServerId(personalmenu.closestPlayer))
				end
			else
				ESX.ShowNotification("Vous n'avez pas les ~r~droits~w~.")
			end
		end
	end
end

function AddMenuDemarcheVoixGPS(menu)
    personalmenu.gps = {
		"Aucun",
		"Poste de Police",
		"Garage Central",
        "Hôpital",
		"Concessionnaire",
        "Benny's Custom",
		"Pôle Emploie",
        "Auto école",
		"Téquila-la"
	}

	personalmenu.demarche = {
		"Normal",
		"Homme effiminer",
		"Bouffiasse",
		"Dépressif",
		"Dépressive",
		"Muscle",
		"Hipster",
		"Business",
		"Intimide",
		"Bourrer",
		"Malheureux",
		"Triste",
		"Choc",
		"Sombre",
		"Fatiguer",
		"Presser",
		"Frimeur",
		"Fier",
		"Petite course",
		"Pupute",
		"Impertinente",
		"Arrogante",
		"Blesser",
		"Trop manger",
		"Casual",
		"Determiner",
		"Peureux",
		"Trop Swag",
		"Travailleur",
		"Brute",
		"Rando",
		"Gangstère",
		"Gangster"
	}

	personalmenu.nivVoix = {
		"Chuchoter",
		"Normal",
		"Crier"
	}

	local gpsItem = NativeUI.CreateListItem("GPS", personalmenu.gps, actualGPSIndex)
	menu:AddItem(gpsItem)
	local demarcheItem = NativeUI.CreateListItem("Démarche", personalmenu.demarche, actualDemarcheIndex)
	menu:AddItem(demarcheItem)
	local voixItem = NativeUI.CreateListItem("Voix", personalmenu.nivVoix, actualVoixIndex)
	menu:AddItem(voixItem)

	menu.OnListSelect = function(sender, item, index)
		if item == gpsItem then
			actualGPS = item:IndexToItem(index)
			actualGPSIndex = index

			ESX.ShowNotification("GPS: ~b~" .. actualGPS)

			if actualGPS == "Aucun" then
				local plyCoords = GetEntityCoords(plyPed)
				SetNewWaypoint(plyCoords.x, plyCoords.y)
			elseif actualGPS == "Poste de Police" then
				SetNewWaypoint(425.130, -979.558)
			elseif actualGPS == "Hôpital" then
				SetNewWaypoint(-449.67, -340.83)
			elseif actualGPS == "Concessionnaire" then
				SetNewWaypoint(-33.88771, -1102.373)
			elseif actualGPS == "Garage Central" then
				SetNewWaypoint(215.066, -791.56)
			elseif actualGPS == "Benny's Custom" then
				SetNewWaypoint(-212.1378, -1325.277)
			elseif actualGPS == "Pôle Emploie" then
				SetNewWaypoint(-264.8365, -964.5458)
			elseif actualGPS == "Auto école" then
				SetNewWaypoint(-829.2257, -696.9993)
			elseif actualGPS == "Téquila-la" then
				SetNewWaypoint(-565.0996, 273.455139)
			elseif actualGPS == "Bahama Mamas" then
				SetNewWaypoint(-1391.06311, -590.34497)
			end
		elseif item == demarcheItem then
			TriggerEvent('skinchanger:getSkin', function(skin)
				actualDemarche = item:IndexToItem(index)
				actualDemarcheIndex = index

				ESX.ShowNotification("Démarche: ~b~" .. actualDemarche)

				if actualDemarche == "Normal" then
					if skin.sex == 0 then
						startAttitude("move_m@multiplayer", "move_m@multiplayer")
					elseif skin.sex == 1 then
						startAttitude("move_f@multiplayer", "move_f@multiplayer")
					end
				elseif actualDemarche == "Homme effiminer" then
					startAttitude("move_m@confident", "move_m@confident")
				elseif actualDemarche == "Bouffiasse" then
					startAttitude("move_f@heels@c","move_f@heels@c")
				elseif actualDemarche == "Dépressif" then
					startAttitude("move_m@depressed@a","move_m@depressed@a")
				elseif actualDemarche == "Dépressive" then
					startAttitude("move_f@depressed@a","move_f@depressed@a")
				elseif actualDemarche == "Muscle" then
					startAttitude("move_m@muscle@a","move_m@muscle@a")
				elseif actualDemarche == "Hipster" then
					startAttitude("move_m@hipster@a","move_m@hipster@a")
				elseif actualDemarche == "Business" then
					startAttitude("move_m@business@a","move_m@business@a")
				elseif actualDemarche == "Intimide" then
					startAttitude("move_m@hurry@a","move_m@hurry@a")
				elseif actualDemarche == "Bourrer" then
					startAttitude("move_m@hobo@a","move_m@hobo@a")
				elseif actualDemarche == "Malheureux" then
					startAttitude("move_m@sad@a","move_m@sad@a")
				elseif actualDemarche == "Triste" then
					startAttitude("move_m@leaf_blower","move_m@leaf_blower")
				elseif actualDemarche == "Choc" then
					startAttitude("move_m@shocked@a","move_m@shocked@a")
				elseif actualDemarche == "Sombre" then
					startAttitude("move_m@shadyped@a","move_m@shadyped@a")
				elseif actualDemarche == "Fatiguer" then
					startAttitude("move_m@buzzed","move_m@buzzed")
				elseif actualDemarche == "Presser" then
					startAttitude("move_m@hurry_butch@a","move_m@hurry_butch@a")
				elseif actualDemarche == "Frimeur" then
					startAttitude("move_m@money","move_m@money")
				elseif actualDemarche == "Fier" then
					startAttitude("move_m@posh@","move_m@posh@")
				elseif actualDemarche == "Petite course" then
					startAttitude("move_m@quick","move_m@quick")
				elseif actualDemarche == "Pupute" then
					startAttitude("move_f@maneater","move_f@maneater")
				elseif actualDemarche == "Impertinente" then
					startAttitude("move_f@sassy","move_f@sassy")
				elseif actualDemarche == "Arrogante" then
					startAttitude("move_f@arrogant@a","move_f@arrogant@a")
				elseif actualDemarche == "Blesser" then
					startAttitude("move_m@injured","move_m@injured")
				elseif actualDemarche == "Trop manger" then
					startAttitude("move_m@fat@a","move_m@fat@a")
				elseif actualDemarche == "Casual" then
					startAttitude("move_m@casual@a","move_m@casual@a")
				elseif actualDemarche == "Determiner" then
					startAttitude("move_m@brave@a","move_m@brave@a")
				elseif actualDemarche == "Peureux" then
					startAttitude("move_m@scared","move_m@scared")
				elseif actualDemarche == "Trop Swag" then
					startAttitude("move_m@swagger@b","move_m@swagger@b")
				elseif actualDemarche == "Travailleur" then
					startAttitude("move_m@tool_belt@a","move_m@tool_belt@a")
				elseif actualDemarche == "Brute" then
					startAttitude("move_m@tough_guy@","move_m@tough_guy@")
				elseif actualDemarche == "Rando" then
					startAttitude("move_m@hiking","move_m@hiking")
				elseif actualDemarche == "Gangstère" then
					startAttitude("move_m@gangster@ng","move_m@gangster@ng")
				elseif actualDemarche == "Gangster" then
					startAttitude("move_m@gangster@generic","move_m@gangster@generic")
				end
			end)
		elseif item == voixItem then
			actualVoix = item:IndexToItem(index)
			actualVoixIndex = index

			ESX.ShowNotification("Voix: ~b~" .. actualVoix)

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

function AddMenuAdminMenu(menu)
	adminMenu = _menuPool:AddSubMenu(menu, "Administration")

	ESX.TriggerServerCallback('KorioZ-PersonalMenu:Admin_getUsergroup', function(playerGroup)
		if playerGroup == 'mod' then
			local tptoPlrItem = NativeUI.CreateItem("TP sur joueur", "")
			adminMenu.SubMenu:AddItem(tptoPlrItem)
			local tptoMeItem = NativeUI.CreateItem("TP joueur sur moi", "")
			adminMenu.SubMenu:AddItem(tptoMeItem)
			local showXYZItem = NativeUI.CreateItem("Afficher/Cacher coordonnées", "")
			adminMenu.SubMenu:AddItem(showXYZItem)
			local showPlrNameItem = NativeUI.CreateItem("Afficher/Cacher noms des joueurs", "")
			adminMenu.SubMenu:AddItem(showPlrNameItem)

			adminMenu.SubMenu.OnItemSelect = function(sender, item, index)
				if item == tptoPlrItem then
					admin_tp_toplayer()
					_menuPool:CloseAllMenus()
				elseif item == tptoMeItem then
					admin_tp_playertome()
					_menuPool:CloseAllMenus()
				elseif item == showXYZItem then
					modo_showcoord()
				elseif item == showPlrNameItem then
					modo_showname()
				end
			end
		elseif playerGroup == 'admin' then
			local tptoPlrItem = NativeUI.CreateItem("TP sur joueur", "")
			adminMenu.SubMenu:AddItem(tptoPlrItem)
			local tptoMeItem = NativeUI.CreateItem("TP joueur sur moi", "")
			adminMenu.SubMenu:AddItem(tptoMeItem)
			local noclipItem = NativeUI.CreateItem("NoClip", "")
			adminMenu.SubMenu:AddItem(noclipItem)
			local repairVehItem = NativeUI.CreateItem("Réparer véhicule", "")
			adminMenu.SubMenu:AddItem(repairVehItem)
			local returnVehItem = NativeUI.CreateItem("Retourner le véhicule", "")
			adminMenu.SubMenu:AddItem(returnVehItem)
			local showXYZItem = NativeUI.CreateItem("Afficher/Cacher coordonnées", "")
			adminMenu.SubMenu:AddItem(showXYZItem)
			local showPlrNameItem = NativeUI.CreateItem("Afficher/Cacher noms des joueurs", "")
			adminMenu.SubMenu:AddItem(showPlrNameItem)
			local tptoWaypointItem = NativeUI.CreateItem("TP sur le marqueur", "")
			adminMenu.SubMenu:AddItem(tptoWaypointItem)
			local healPlrItem = NativeUI.CreateItem("Soigner la personne", "")
			adminMenu.SubMenu:AddItem(healPlrItem)

			adminMenu.SubMenu.OnItemSelect = function(sender, item, index)
				if item == tptoPlrItem then
					admin_tp_toplayer()
					_menuPool:CloseAllMenus()
				elseif item == tptoMeItem then
					admin_tp_playertome()
					_menuPool:CloseAllMenus()
				elseif item == noclipItem then
					admin_no_clip()
					_menuPool:CloseAllMenus()
				elseif item == repairVehItem then
					admin_vehicle_repair()
				elseif item == returnVehItem then
					admin_vehicle_flip()
				elseif item == showXYZItem then
					modo_showcoord()
				elseif item == showPlrNameItem then
					modo_showname()
				elseif item == tptoWaypointItem then
					admin_tp_marker()
				elseif item == healPlrItem then
					admin_heal_player()
					_menuPool:CloseAllMenus()
				end
			end
		elseif playerGroup == 'superadmin' or playerGroup == 'owner' then
			local tptoPlrItem = NativeUI.CreateItem("TP sur joueur", "")
			adminMenu.SubMenu:AddItem(tptoPlrItem)
			local tptoMeItem = NativeUI.CreateItem("TP joueur sur moi", "")
			adminMenu.SubMenu:AddItem(tptoMeItem)
			local tptoXYZItem = NativeUI.CreateItem("TP sur coordonées", "")
			adminMenu.SubMenu:AddItem(tptoXYZItem)
			local noclipItem = NativeUI.CreateItem("NoClip", "")
			adminMenu.SubMenu:AddItem(noclipItem)
			local godmodeItem = NativeUI.CreateItem("Mode invincible", "")
			adminMenu.SubMenu:AddItem(godmodeItem)
			local ghostmodeItem = NativeUI.CreateItem("Mode fantôme", "")
			adminMenu.SubMenu:AddItem(ghostmodeItem)
			local repairVehItem = NativeUI.CreateItem("Réparer véhicule", "")
			adminMenu.SubMenu:AddItem(repairVehItem)
			local spawnVehItem = NativeUI.CreateItem("Faire apparaître un véhicule", "")
			adminMenu.SubMenu:AddItem(spawnVehItem)
			local returnVehItem = NativeUI.CreateItem("Retourner le véhicule", "")
			adminMenu.SubMenu:AddItem(returnVehItem)
			local givecashItem = NativeUI.CreateItem("S'octroyer de l'argent", "")
			adminMenu.SubMenu:AddItem(givecashItem)
			local givebankItem = NativeUI.CreateItem("S'octroyer de l'argent (banque)", "")
			adminMenu.SubMenu:AddItem(givebankItem)
			local givedirtyItem = NativeUI.CreateItem("S'octroyer de l'argent sale", "")
			adminMenu.SubMenu:AddItem(givedirtyItem)
			local showXYZItem = NativeUI.CreateItem("Afficher/Cacher coordonnées", "")
			adminMenu.SubMenu:AddItem(showXYZItem)
			local showPlrNameItem = NativeUI.CreateItem("Afficher/Cacher noms des joueurs", "")
			adminMenu.SubMenu:AddItem(showPlrNameItem)
			local tptoWaypointItem = NativeUI.CreateItem("TP sur le marqueur", "")
			adminMenu.SubMenu:AddItem(tptoWaypointItem)
			local healPlrItem = NativeUI.CreateItem("Soigner la personne", "")
			adminMenu.SubMenu:AddItem(healPlrItem)
			local skinPlrItem = NativeUI.CreateItem("Changer l'apparence", "")
			adminMenu.SubMenu:AddItem(skinPlrItem)
			local saveSkinPlrItem = NativeUI.CreateItem("Sauvegarder l'apparence", "")
			adminMenu.SubMenu:AddItem(saveSkinPlrItem)

			adminMenu.SubMenu.OnItemSelect = function(sender, item, index)
				if item == tptoPlrItem then
					admin_tp_toplayer()
					_menuPool:CloseAllMenus()
				elseif item == tptoMeItem then
					admin_tp_playertome()
					_menuPool:CloseAllMenus()
				elseif item == tptoXYZItem then
					admin_tp_pos()
					_menuPool:CloseAllMenus()
				elseif item == noclipItem then
					admin_no_clip()
					_menuPool:CloseAllMenus()
				elseif item == godmodeItem then
					admin_godmode()
				elseif item == ghostmodeItem then
					admin_mode_fantome()
				elseif item == repairVehItem then
					admin_vehicle_repair()
				elseif item == spawnVehItem then
					admin_vehicle_spawn()
					_menuPool:CloseAllMenus()
				elseif item == returnVehItem then
					admin_vehicle_flip()
				elseif item == givecashItem then
					admin_give_money()
					_menuPool:CloseAllMenus()
				elseif item == givebankItem then
					admin_give_bank()
					_menuPool:CloseAllMenus()
				elseif item == givedirtyItem then
					admin_give_dirty()
					_menuPool:CloseAllMenus()
				elseif item == showXYZItem then
					modo_showcoord()
				elseif item == showPlrNameItem then
					modo_showname()
				elseif item == tptoWaypointItem then
					admin_tp_marker()
				elseif item == healPlrItem then
					admin_heal_player()
					_menuPool:CloseAllMenus()
				elseif item == skinPlrItem then
					changer_skin()
				elseif item == saveSkinPlrItem then
					save_skin()
				end
			end
		end
	end)
end

Citizen.CreateThread(function()
	while true do
		while _menuPool:IsAnyMenuOpen() do
			Citizen.Wait(0)

			if not _menuPool:IsAnyMenuOpen() then
				mainMenu:Clear()
				itemMenu:Clear()
				weaponItemMenu:Clear()

				_menuPool:Clear()
				_menuPool:Remove()

				personalmenu = {}

				invItem = {}
				wepItem = {}
				billItem = {}

				collectgarbage()
			end
		end

		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	mainMenu = NativeUI.CreateMenu(Config.servername, "Menu d'interaction")
	itemMenu = NativeUI.CreateMenu(Config.servername, "Inventaire: action")
	weaponItemMenu = NativeUI.CreateMenu(Config.servername, "Armes: action")
	_menuPool:Add(mainMenu)
	_menuPool:Add(itemMenu)
	_menuPool:Add(weaponItemMenu)

	while true do
		if _menuPool then
			_menuPool:ProcessMenus()
		end

		plyPed = PlayerPedId()
		plyVehicle = GetVehiclePedIsIn(plyPed, false)

		if IsControlJustReleased(0, Config.Menu.clavier) and GetLastInputMethod(2) and not isDead then
			if mainMenu:Visible() then
				mainMenu:Visible(false)
			elseif not mainMenu:Visible() then
				ESX.PlayerData = ESX.GetPlayerData()
				GeneratePersonalMenu()
				mainMenu:Visible(true)
			end
		end

		if IsControlJustReleased(0, Config.stopAnim.clavier) and GetLastInputMethod(2) and not isDead then
			ClearPedTasks(plyPed)
		end

		if IsControlPressed(1, Config.TPMarker.clavier1) and IsControlJustReleased(1, Config.TPMarker.clavier2) and GetLastInputMethod(2) and not isDead then
			admin_tp_marker()
		end

		if showcoord then
			local playerPos = GetEntityCoords(plyPed)
			local playerHeading = GetEntityHeading(plyPed)
			Text("~r~X~s~: " .. playerPos.x .. " ~b~Y~s~: " .. playerPos.y .. " ~g~Z~s~: " .. playerPos.z .. " ~y~Angle~s~: " .. playerHeading)
		end

		if noclip then
			local x, y, z = getPosition()
			local dx, dy, dz = getCamDirection()
			local speed = Config.noclip_speed

			SetEntityVelocity(plyPed, 0.0001, 0.0001, 0.0001)

			if IsControlPressed(0, 32) then
				x = x + speed * dx
				y = y + speed * dy
				z = z + speed * dz
			end

			if IsControlPressed(0, 269) then
				x = x - speed * dx
				y = y - speed * dy
				z = z - speed * dz
			end

			SetEntityCoordsNoOffset(plyPed, x, y, z, true, true, true)
		end

		if showname then
			for id = 0, 255 do
				if NetworkIsPlayerActive(id) and GetPlayerPed(id) ~= plyPed then
					ped = GetPlayerPed(id)
					blip = GetBlipFromEntity(ped)
					headId = Citizen.InvokeNative(0xBFEFE3321A3F5015, ped, (GetPlayerServerId(id) .. ' - ' .. GetPlayerName(id)), false, false, "", false)
				end
			end
		else
			for id = 0, 255 do
				if NetworkIsPlayerActive(id) and GetPlayerPed(id) ~= plyPed then
					ped = GetPlayerPed(id)
					blip = GetBlipFromEntity(ped)
					headId = Citizen.InvokeNative(0xBFEFE3321A3F5015, ped, (' '), false, false, "", false )
				end
			end
		end
		
		Citizen.Wait(0)
	end
end)

function GeneratePersonalMenu()
	_menuPool = NativeUI.CreatePool()

	mainMenu = NativeUI.CreateMenu(Config.servername, "Menu d'interaction")
	itemMenu = NativeUI.CreateMenu(Config.servername, "Inventaire: action")
	weaponItemMenu = NativeUI.CreateMenu(Config.servername, "Armes: action")
	_menuPool:Add(mainMenu)
	_menuPool:Add(itemMenu)
	_menuPool:Add(weaponItemMenu)
	
	AddMenuInventoryMenu(mainMenu)
	AddMenuWeaponMenu(mainMenu)
	AddMenuWalletMenu(mainMenu)
	AddMenuClothesMenu(mainMenu)
	AddMenuAccessoryMenu(mainMenu)
	AddMenuAnimationMenu(mainMenu)

	if IsPedSittingInAnyVehicle(plyPed) then
		if (GetPedInVehicleSeat(plyVehicle, -1) == plyPed) then
			AddMenuVehicleMenu(mainMenu)
		end
	end

	if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' then
		AddMenuBossMenu(mainMenu)
	end

	if Config.doublejob then
		if ESX.PlayerData.job2 ~= nil and ESX.PlayerData.job2.grade_name == 'boss' then
			AddMenuBossMenu2(mainMenu)
		end
	end

	AddMenuFacturesMenu(mainMenu)
	AddMenuDemarcheVoixGPS(mainMenu)

	if playergroup == 'mod' or playergroup == 'admin' or playergroup == 'superadmin' or playergroup == 'owner' then
		AddMenuAdminMenu(mainMenu)
	end

	_menuPool:RefreshIndex()
end
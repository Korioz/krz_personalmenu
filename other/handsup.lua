local handsup = false

RegisterNetEvent('KZ:getSurrenderStatusPlayer')
AddEventHandler('KZ:getSurrenderStatusPlayer', function(event, source)
	if handsup then
		TriggerServerEvent('KZ:reSendSurrenderStatus', event, source, true)
	else
		TriggerServerEvent('KZ:reSendSurrenderStatus', event, source, false)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		local plyPed = PlayerPedId()

		if (IsControlJustPressed(1, Config.handsUP.clavier) or IsDisabledControlJustPressed(1, Config.handsUP.clavier)) then
			if DoesEntityExist(plyPed) and not IsEntityDead(plyPed) then
				if not IsPedInAnyVehicle(plyPed, false) and not IsPedSwimming(plyPed) and not IsPedShooting(plyPed) and not IsPedClimbing(plyPed) and not IsPedCuffed(plyPed) and not IsPedDiving(plyPed) and not IsPedFalling(plyPed) and not IsPedJumpingOutOfVehicle(plyPed) and not IsPedUsingAnyScenario(plyPed) and not IsPedInParachuteFreeFall(plyPed) then
					RequestAnimDict('random@mugging3')

					while not HasAnimDictLoaded('random@mugging3') do
						Citizen.Wait(100)
					end

					if not handsup then
						handsup = true
						TaskPlayAnim(plyPed, 'random@mugging3', 'handsup_standing_base', 8.0, -8, -1, 49, 0, 0, 0, 0)
					elseif handsup then
						handsup = false
						ClearPedSecondaryTask(plyPed)
					end
				end
			end
		end
	end
end)
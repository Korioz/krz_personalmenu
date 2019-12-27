---LoadingPrompt
---@param loadingText string
---@param spinnerType number
---@return void
---@public
function LoadingPrompt(loadingText, spinnerType)
	if BusyspinnerIsOn() then
		BusyspinnerOff()
	end

	if (loadingText == nil) then
		BeginTextCommandBusyspinnerOn(nil)
	else
		BeginTextCommandBusyspinnerOn("STRING")
		AddTextComponentSubstringPlayerName(loadingText)
	end

	EndTextCommandBusyspinnerOn(spinnerType)
end

---LoadingPromptHide
---@return void
---@public
function LoadingPromptHide()
	if BusyspinnerIsOn() then
		BusyspinnerOff()
	end
end
---@type table
local SettingsButton = {
	Rectangle = { Y = 0, Width = 431, Height = 38 },
	Text = { X = 8, Y = 3, Scale = 0.33 },
	LeftBadge = { Y = -2, Width = 40, Height = 40 },
	RightBadge = { X = 385, Y = -2, Width = 40, Height = 40 },
	RightText = { X = 420, Y = 4, Scale = 0.35 },
	SelectedSprite = { Dictionary = "commonmenu", Texture = "gradient_nav", Y = 0, Width = 431, Height = 38 }
}

---Button
---@param Label string
---@param Description string
---@param Enabled boolean
---@param Callback function
---@param Submenu table
---@return nil
---@public
function RageUI.Button(Label, Description, Style, Enabled, Callback, Submenu)
	---@type table
	local CurrentMenu = RageUI.CurrentMenu

	if CurrentMenu ~= nil then
		if CurrentMenu() then
			---@type number
			local Option = RageUI.Options + 1

			if CurrentMenu.Pagination.Minimum <= Option and CurrentMenu.Pagination.Maximum >= Option then
				---@type boolean
				local Selected = CurrentMenu.Index == Option
				RageUI.ItemsSafeZone(CurrentMenu)

				local LeftBadgeOffset = ((Style?.LeftBadge == RageUI.BadgeStyle.None or tonumber(Style?.LeftBadge) == nil) and 0 or 27)
				local RightBadgeOffset = ((Style?.RightBadge == RageUI.BadgeStyle.None or tonumber(Style?.RightBadge) == nil) and 0 or 32)
				local Hovered = false

				if Style?.Color?.BackgroundColor ~= nil then
					RenderRectangle(CurrentMenu.X, CurrentMenu.Y + SettingsButton.SelectedSprite.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, SettingsButton.SelectedSprite.Width + CurrentMenu.WidthOffset, SettingsButton.SelectedSprite.Height, Style.Color.BackgroundColor[1],Style.Color.BackgroundColor[2],Style.Color.BackgroundColor[3]) 
				end

				---@type boolean
				if CurrentMenu.EnableMouse == true then
					Hovered = RageUI.ItemsMouseBounds(CurrentMenu, Selected, Option, SettingsButton)
				end

				if Selected then
					if Style?.Color then
						if Style.Color.HightLightColor then
							RenderRectangle(CurrentMenu.X, CurrentMenu.Y + SettingsButton.SelectedSprite.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, SettingsButton.SelectedSprite.Width + CurrentMenu.WidthOffset, SettingsButton.SelectedSprite.Height, Style.Color.HightLightColor[1],Style.Color.HightLightColor[2],Style.Color.HightLightColor[3]) 
						else
							RenderSprite(SettingsButton.SelectedSprite.Dictionary, SettingsButton.SelectedSprite.Texture, CurrentMenu.X, CurrentMenu.Y + SettingsButton.SelectedSprite.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, SettingsButton.SelectedSprite.Width + CurrentMenu.WidthOffset, SettingsButton.SelectedSprite.Height)
						end
					else
						RenderSprite(SettingsButton.SelectedSprite.Dictionary, SettingsButton.SelectedSprite.Texture, CurrentMenu.X, CurrentMenu.Y + SettingsButton.SelectedSprite.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, SettingsButton.SelectedSprite.Width + CurrentMenu.WidthOffset, SettingsButton.SelectedSprite.Height)
					end
				end

				if type(Style) == 'table' then
					if Style.LeftBadge ~= nil then
						if Style.LeftBadge ~= RageUI.BadgeStyle.None and tonumber(Style.LeftBadge) ~= nil then
							RenderSprite(RageUI.GetBadgeDictionary(Style.LeftBadge, Selected), RageUI.GetBadgeTexture(Style.LeftBadge, Selected), CurrentMenu.X, CurrentMenu.Y + SettingsButton.LeftBadge.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, SettingsButton.LeftBadge.Width, SettingsButton.LeftBadge.Height, RageUI.GetBadgeColour(Style.LeftBadge, Selected))
						end
					end

					if Style.RightBadge ~= nil then
						if Style.RightBadge ~= RageUI.BadgeStyle.None and tonumber(Style.RightBadge) ~= nil then
							RenderSprite(RageUI.GetBadgeDictionary(Style.RightBadge, Selected), RageUI.GetBadgeTexture(Style.RightBadge, Selected), CurrentMenu.X + SettingsButton.RightBadge.X + CurrentMenu.WidthOffset, CurrentMenu.Y + SettingsButton.RightBadge.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, SettingsButton.RightBadge.Width, SettingsButton.RightBadge.Height, 0, RageUI.GetBadgeColour(Style.RightBadge, Selected))
						end
					end
				end

				if (Enabled) then
					if Selected then
						if Style?.RightLabel ~= nil and Style.RightLabel ~= "" then
							RenderText(Style.RightLabel, CurrentMenu.X + SettingsButton.RightText.X - RightBadgeOffset + CurrentMenu.WidthOffset, CurrentMenu.Y + SettingsButton.RightText.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, 0, SettingsButton.RightText.Scale, 0, 0, 0, 255, 2)
						end

						RenderText(Label, CurrentMenu.X + SettingsButton.Text.X + LeftBadgeOffset, CurrentMenu.Y + SettingsButton.Text.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, 0, SettingsButton.Text.Scale, 0, 0, 0, 255)
					else
						if Style?.RightLabel ~= nil and Style.RightLabel ~= "" then
							RenderText(Style.RightLabel, CurrentMenu.X + SettingsButton.RightText.X - RightBadgeOffset + CurrentMenu.WidthOffset, CurrentMenu.Y + SettingsButton.RightText.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, 0, SettingsButton.RightText.Scale, 245, 245, 245, 255, 2)
						end

						RenderText(Label, CurrentMenu.X + SettingsButton.Text.X + LeftBadgeOffset, CurrentMenu.Y + SettingsButton.Text.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, 0, SettingsButton.Text.Scale, 245, 245, 245, 255)
					end
				else
					RenderText(Label, CurrentMenu.X + SettingsButton.Text.X + LeftBadgeOffset, CurrentMenu.Y + SettingsButton.Text.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, 0, SettingsButton.Text.Scale, 163, 159, 148, 255)
				end

				RageUI.ItemOffset = RageUI.ItemOffset + SettingsButton.Rectangle.Height
				RageUI.ItemsDescription(CurrentMenu, Description, Selected)

				if (Enabled) then
					if Callback then
						Callback(Hovered, Selected, ((CurrentMenu.Controls.Select.Active or (Hovered and CurrentMenu.Controls.Click.Active)) and Selected))
					end
				end

				if Selected and (CurrentMenu.Controls.Select.Active or (Hovered and CurrentMenu.Controls.Click.Active)) then
					local Audio = RageUI.Settings.Audio

					if (Enabled) then
						RageUI.PlaySound(Audio[Audio.Use].Select.audioName, Audio[Audio.Use].Select.audioRef)

						if Submenu and Submenu() then
							RageUI.NextMenu = Submenu
						end
					else
						RageUI.PlaySound(Audio[Audio.Use].Error.audioName, Audio[Audio.Use].Error.audioRef)
					end
				end
			end

			RageUI.Options = RageUI.Options + 1
		end
	end
end
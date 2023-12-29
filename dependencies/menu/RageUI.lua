RageUI = {}

---PlaySound
---@param Library string
---@param Sound string
---@param IsLooped boolean
---@return void
---@public
function PlaySound(Library, Sound, IsLooped, Audio)
	if not IsLooped then
		PlaySoundFrontend(-1, Sound, Library, true)
	else
		if not Audio.Id then
			Citizen.CreateThread(function()
				Audio.Id = GetSoundId()
				PlaySoundFrontend(Audio.Id, Sound, Library, true)
				Citizen.Wait(0.01)

				StopSound(Audio.Id)
				ReleaseSoundId(Audio.Id)
				Audio.Id = nil
			end)
		end
	end
end

---RenderRectangle
---@param X number
---@param Y number
---@param Width number
---@param Height number
---@param R number
---@param G number
---@param B number
---@param A number
---@return void
---@public
function RenderRectangle(X, Y, Width, Height, R, G, B, A)
	local X, Y, Width, Height = (tonumber(X) or 0) / 1920, (tonumber(Y) or 0) / 1080, (tonumber(Width) or 0) / 1920, (tonumber(Height) or 0) / 1080
	DrawRect(X + Width * 0.5, Y + Height * 0.5, Width, Height, tonumber(R) or 255, tonumber(G) or 255, tonumber(B) or 255, tonumber(A) or 255)
end

---RenderSprite
---@param TextureDictionary string
---@param TextureName string
---@param X number
---@param Y number
---@param Width number
---@param Height number
---@param Heading number
---@param R number
---@param G number
---@param B number
---@param A number
---@return void
---@public
function RenderSprite(TextureDictionary, TextureName, X, Y, Width, Height, Heading, R, G, B, A)
	---@type number
	local X, Y, Width, Height = (tonumber(X) or 0) / 1920, (tonumber(Y) or 0) / 1080, (tonumber(Width) or 0) / 1920, (tonumber(Height) or 0) / 1080

	if not HasStreamedTextureDictLoaded(TextureDictionary) then
		RequestStreamedTextureDict(TextureDictionary, true)
	end

	DrawSprite(TextureDictionary, TextureName, X + Width * 0.5, Y + Height * 0.5, Width, Height, Heading or 0, tonumber(R) or 255, tonumber(G) or 255, tonumber(B) or 255, tonumber(A) or 255)
end

---MeasureStringWidth
---@param str string
---@param font number
---@param scale number
---@return number
---@public
function MeasureStringWidth(str, font, scale)
	BeginTextCommandWidth("CELL_EMAIL_BCON")
	AddTextComponentSubstringPlayerName(str)
	SetTextFont(font or 0)
	SetTextScale(1.0, scale or 0)
	return EndTextCommandGetWidth(true) * 1920
end

---GetCharacterCount
---@param Str string
---@return number
---@public
function GetCharacterCount(Str)
	---@type number
	local Chars = 0

	for Char in Str:gmatch("[%z\1-\127\194-\244][\128-\191]*") do
		Chars = Chars + 1
	end

	return Chars
end

---AddText
---@param Text string
---@return void
---@public
function AddText(Text)
	---@type number
	local Characters = GetCharacterCount(Text)

	if Characters < 100 then
		AddTextComponentSubstringPlayerName(Text)
	else
		---@type number
		local StringsNeeded = (Characters % 99 == 0) and Characters / 99 or (Characters / 99) + 1

		for Index = 0, StringsNeeded do
			AddTextComponentSubstringPlayerName(Text:sub(Index * 99, (Index * 99) + 99))
		end
	end
end

---GetLineCount
---@param Text string
---@param X number
---@param Y number
---@param Font number
---@param Scale number
---@param R number
---@param G number
---@param B number
---@param A number
---@param Alignment string
---@param DropShadow boolean
---@param Outline boolean
---@param WordWrap number
---@return function
---@public
function GetLineCount(Text, X, Y, Font, Scale, R, G, B, A, Alignment, DropShadow, Outline, WordWrap)
	---@type table
	local Text, X, Y = tostring(Text), (tonumber(X) or 0) / 1920, (tonumber(Y) or 0) / 1080

	SetTextFont(Font or 0)
	SetTextScale(1.0, Scale or 0)
	SetTextColour(tonumber(R) or 255, tonumber(G) or 255, tonumber(B) or 255, tonumber(A) or 255)

	if DropShadow then
		SetTextDropShadow()
	end

	if Outline then
		SetTextOutline()
	end

	if Alignment ~= nil then
		if Alignment == 1 or Alignment == "Center" or Alignment == "Centre" then
			SetTextCentre(true)
		elseif Alignment == 2 or Alignment == "Right" then
			SetTextRightJustify(true)
		end
	end

	if tonumber(WordWrap) and tonumber(WordWrap) ~= 0 then
		if Alignment == 1 or Alignment == "Center" or Alignment == "Centre" then
			SetTextWrap(X - ((WordWrap / 1920) / 2), X + ((WordWrap / 1920) / 2))
		elseif Alignment == 2 or Alignment == "Right" then
			SetTextWrap(0, X)
		else
			SetTextWrap(X, X + (WordWrap / 1920))
		end
	else
		if Alignment == 2 or Alignment == "Right" then
			SetTextWrap(0, X)
		end
	end

	BeginTextCommandLineCount("CELL_EMAIL_BCON")
	AddText(Text)
	return EndTextCommandGetLineCount(X, Y)
end

---RenderText
---@param Text string
---@param X number
---@param Y number
---@param Font number
---@param Scale number
---@param R number
---@param G number
---@param B number
---@param A number
---@param Alignment string
---@param DropShadow boolean
---@param Outline boolean
---@param WordWrap number
---@return void
---@public
function RenderText(Text, X, Y, Font, Scale, R, G, B, A, Alignment, DropShadow, Outline, WordWrap)
	---@type table
	local Text, X, Y = tostring(Text), (tonumber(X) or 0) / 1920, (tonumber(Y) or 0) / 1080

	SetTextFont(Font or 0)
	SetTextScale(1.0, Scale or 0)
	SetTextColour(tonumber(R) or 255, tonumber(G) or 255, tonumber(B) or 255, tonumber(A) or 255)

	if DropShadow then
		SetTextDropShadow()
	end

	if Outline then
		SetTextOutline()
	end

	if Alignment ~= nil then
		if Alignment == 1 or Alignment == "Center" or Alignment == "Centre" then
			SetTextCentre(true)
		elseif Alignment == 2 or Alignment == "Right" then
			SetTextRightJustify(true)
		end
	end

	if tonumber(WordWrap) and tonumber(WordWrap) ~= 0 then
		if Alignment == 1 or Alignment == "Center" or Alignment == "Centre" then
			SetTextWrap(X - ((WordWrap / 1920) / 2), X + ((WordWrap / 1920) / 2))
		elseif Alignment == 2 or Alignment == "Right" then
			SetTextWrap(0, X)
		else
			SetTextWrap(X, X + (WordWrap / 1920))
		end
	else
		if Alignment == 2 or Alignment == "Right" then
			SetTextWrap(0, X)
		end
	end

	BeginTextCommandDisplayText("CELL_EMAIL_BCON")
	AddText(Text)
	EndTextCommandDisplayText(X, Y)
end

---round
---@param num number
---@param numDecimalPlaces number
---@return number
---@public
function math.round(num, numDecimalPlaces)
	return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

---starts
---@param String string
---@param Start number
---@return number
---@public
function string.starts(String, Start)
	return string.sub(String, 1, string.len(Start)) == Start
end

---@type table
RageUI.Menus = setmetatable({}, RageUI.Menus)

---@type table
---@return boolean
RageUI.Menus.__call = function()
	return true
end

---@type table
RageUI.Menus.__index = RageUI.Menus

---@type table
RageUI.CurrentMenu = nil

---@type table
RageUI.NextMenu = nil

---@type number
RageUI.Options = 0

---@type number
RageUI.ItemOffset = 0

---@type number
RageUI.StatisticPanelCount = 0

---@type table
RageUI.Settings = {
	Debug = false,
	Controls = {
		Up = {
			Enabled = true,
			Active = false,
			Pressed = false,
			Keys = {
				{ 0, 172 },
				{ 1, 172 },
				{ 2, 172 },
				{ 0, 241 },
				{ 1, 241 },
				{ 2, 241 }
			}
		},
		Down = {
			Enabled = true,
			Active = false,
			Pressed = false,
			Keys = {
				{ 0, 173 },
				{ 1, 173 },
				{ 2, 173 },
				{ 0, 242 },
				{ 1, 242 },
				{ 2, 242 }
			}
		},
		Left = {
			Enabled = true,
			Active = false,
			Pressed = false,
			Keys = {
				{ 0, 174 },
				{ 1, 174 },
				{ 2, 174 }
			}
		},
		Right = {
			Enabled = true,
			Pressed = false,
			Active = false,
			Keys = {
				{ 0, 175 },
				{ 1, 175 },
				{ 2, 175 }
			}
		},
		SliderLeft = {
			Enabled = true,
			Active = false,
			Pressed = false,
			Keys = {
				{ 0, 174 },
				{ 1, 174 },
				{ 2, 174 }
			}
		},
		SliderRight = {
			Enabled = true,
			Pressed = false,
			Active = false,
			Keys = {
				{ 0, 175 },
				{ 1, 175 },
				{ 2, 175 }
			}
		},
		Select = {
			Enabled = true,
			Pressed = false,
			Active = false,
			Keys = {
				{ 0, 201 },
				{ 1, 201 },
				{ 2, 201 }
			}
		},
		Back = {
			Enabled = true,
			Active = false,
			Pressed = false,
			Keys = {
				{ 0, 177 },
				{ 1, 177 },
				{ 2, 177 },
				{ 0, 199 },
				{ 1, 199 },
				{ 2, 199 }
			}
		},
		Click = {
			Enabled = true,
			Active = false,
			Pressed = false,
			Keys = {
				{ 0, 24 }
			}
		},
		Enabled = {
			Controller = {
				{ 0, 2 }, -- Look Up and Down
				{ 0, 1 }, -- Look Left and Right
				{ 0, 25 }, -- Aim
				{ 0, 24 } -- Attack
			},
			Keyboard = {
				{ 0, 201 }, -- Select
				{ 0, 195 }, -- X axis
				{ 0, 196 }, -- Y axis
				{ 0, 187 }, -- Down
				{ 0, 188 }, -- Up
				{ 0, 189 }, -- Left
				{ 0, 190 }, -- Right
				{ 0, 202 }, -- Back
				{ 0, 217 }, -- Select
				{ 0, 242 }, -- Scroll down
				{ 0, 241 }, -- Scroll up
				{ 0, 239 }, -- Cursor X
				{ 0, 240 }, -- Cursor Y
				{ 0, 31 }, -- Move Up and Down
				{ 0, 30 }, -- Move Left and Right
				{ 0, 21 }, -- Sprint
				{ 0, 22 }, -- Jump
				{ 0, 23 }, -- Enter
				{ 0, 75 }, -- Exit Vehicle
				{ 0, 71 }, -- Accelerate Vehicle
				{ 0, 72 }, -- Vehicle Brake
				{ 0, 59 }, -- Move Vehicle Left and Right
				{ 0, 89 }, -- Fly Yaw Left
				{ 0, 9 }, -- Fly Left and Right
				{ 0, 8 }, -- Fly Up and Down
				{ 0, 90 }, -- Fly Yaw Right
				{ 0, 76 }, -- Vehicle Handbrake
			}
		}
	},
	Audio = {
		Id = nil,
		Use = "RageUI",
		RageUI = {
			UpDown = {
				audioName = "HUD_FREEMODE_SOUNDSET",
				audioRef = "NAV_UP_DOWN",
			},
			LeftRight = {
				audioName = "HUD_FRONTEND_DEFAULT_SOUNDSET",
				audioRef = "NAV_LEFT_RIGHT",
			},
			Select = {
				audioName = "HUD_FRONTEND_DEFAULT_SOUNDSET",
				audioRef = "SELECT",
			},
			Back = {
				audioName = "HUD_FRONTEND_DEFAULT_SOUNDSET",
				audioRef = "BACK",
			},
			Error = {
				audioName = "HUD_FRONTEND_DEFAULT_SOUNDSET",
				audioRef = "ERROR",
			},
			Slider = {
				audioName = "HUD_FRONTEND_DEFAULT_SOUNDSET",
				audioRef = "CONTINUOUS_SLIDER",
				Id = nil
			}
		},
		NativeUI = {
			UpDown = {
				audioName = "HUD_FRONTEND_DEFAULT_SOUNDSET",
				audioRef = "NAV_UP_DOWN",
			},
			LeftRight = {
				audioName = "HUD_FRONTEND_DEFAULT_SOUNDSET",
				audioRef = "NAV_LEFT_RIGHT",
			},
			Select = {
				audioName = "HUD_FRONTEND_DEFAULT_SOUNDSET",
				audioRef = "SELECT",
			},
			Back = {
				audioName = "HUD_FRONTEND_DEFAULT_SOUNDSET",
				audioRef = "BACK",
			},
			Error = {
				audioName = "HUD_FRONTEND_DEFAULT_SOUNDSET",
				audioRef = "ERROR",
			},
			Slider = {
				audioName = "HUD_FRONTEND_DEFAULT_SOUNDSET",
				audioRef = "CONTINUOUS_SLIDER",
				Id = nil
			}
		}
	},
	Items = {
		Title = {
			Background = { Width = 431, Height = 97 },
			Text = { X = 215, Y = 20, Scale = 1.15 }
		},
		Subtitle = {
			Background = { Width = 431, Height = 37 },
			Text = { X = 8, Y = 3, Scale = 0.35 },
			PreText = { X = 425, Y = 3, Scale = 0.35 }
		},
		Background = { Dictionary = "commonmenu", Texture = "gradient_bgd", Y = 0, Width = 431 },
		Navigation = {
			Rectangle = { Width = 431, Height = 18 },
			Offset = 5,
			Arrows = { Dictionary = "commonmenu", Texture = "shop_arrows_upanddown", X = 190, Y = -6, Width = 50, Height = 50 }
		},
		Description = {
			Bar = { Y = 4, Width = 431, Height = 4 },
			Background = { Dictionary = "commonmenu", Texture = "gradient_bgd", Y = 4, Width = 431, Height = 30 },
			Text = { X = 8, Y = 10, Scale = 0.35 }
		}
	},
	Panels = {
		Grid = {
			Background = { Dictionary = "commonmenu", Texture = "gradient_bgd", Y = 4, Width = 431, Height = 275 },
			Grid = { Dictionary = "pause_menu_pages_char_mom_dad", Texture = "nose_grid", X = 115.5, Y = 47.5, Width = 200, Height = 200 },
			Circle = { Dictionary = "mpinventory", Texture = "in_world_circle", X = 115.5, Y = 47.5, Width = 20, Height = 20 },
			Text = {
				Top = { X = 215.5, Y = 15, Scale = 0.35 },
				Bottom = { X = 215.5, Y = 250, Scale = 0.35 },
				Left = { X = 57.75, Y = 130, Scale = 0.35 },
				Right = { X = 373.25, Y = 130, Scale = 0.35 }
			}
		},
		Percentage = {
			Background = { Dictionary = "commonmenu", Texture = "gradient_bgd", Y = 4, Width = 431, Height = 76 },
			Bar = { X = 9, Y = 50, Width = 413, Height = 10 },
			Text = {
				Left = { X = 25, Y = 15, Scale = 0.35 },
				Middle = { X = 215.5, Y = 15, Scale = 0.35 },
				Right = { X = 398, Y = 15, Scale = 0.35 }
			}
		}
	}
}

---Visible
---@param Menu function
---@param Value boolean
---@return table
---@public
function RageUI.Visible(Menu, Value)
	if Menu ~= nil then
		if Menu() then
			if type(Value) == "boolean" then
				if Value then
					if RageUI.CurrentMenu ~= nil then
						RageUI.CurrentMenu.Open = not Value
					end

					Menu:UpdateInstructionalButtons(Value)
					RageUI.CurrentMenu = Menu
					RageUI.Options = 0
					RageUI.ItemOffset = 0
					Menu.Open = Value
				else
					Menu.Open = Value
					RageUI.CurrentMenu = nil
					RageUI.Options = 0
					RageUI.ItemOffset = 0
				end
			else
				return Menu.Open
			end
		end
	end
end

---CloseAll
---@return void
---@public
function RageUI.CloseAll()
	PlaySound(RageUI.Settings.Audio.Library, RageUI.Settings.Audio.Back)
	RageUI.Visible(RageUI.CurrentMenu, false)
	RageUI.CurrentMenu = nil
	RageUI.NextMenu = nil
	RageUI.Options = 0
	RageUI.ItemOffset = 0
end

---PlaySound
---@param Library string
---@param Sound string
---@param IsLooped boolean
---@return void
---@public
function RageUI.PlaySound(Library, Sound, IsLooped)
	local audioId

	if not IsLooped then
		PlaySoundFrontend(-1, Sound, Library, true)
	else
		if not audioId then
			Citizen.CreateThread(function()
				audioId = GetSoundId()
				PlaySoundFrontend(audioId, Sound, Library, true)
				Citizen.Wait(0)

				StopSound(audioId)
				ReleaseSoundId(audioId)
				audioId = nil
			end)
		end
	end
end

---Banner
---@return void
---@public
---@param Enabled boolean
function RageUI.Banner(Enabled)
	if type(Enabled) == "boolean" then
		if Enabled == true then
			if RageUI.CurrentMenu ~= nil then
				if RageUI.CurrentMenu() then
					RageUI.ItemsSafeZone(RageUI.CurrentMenu)

					if RageUI.CurrentMenu.Sprite then
						RenderSprite(RageUI.CurrentMenu.Sprite.Dictionary, RageUI.CurrentMenu.Sprite.Texture, RageUI.CurrentMenu.X, RageUI.CurrentMenu.Y, RageUI.Settings.Items.Title.Background.Width + RageUI.CurrentMenu.WidthOffset, RageUI.Settings.Items.Title.Background.Height, 0, 255, 255, 255, 255)
					else
						RenderRectangle(RageUI.CurrentMenu.X, RageUI.CurrentMenu.Y, RageUI.Settings.Items.Title.Background.Width + RageUI.CurrentMenu.WidthOffset, RageUI.Settings.Items.Title.Background.Height, RageUI.CurrentMenu.Rectangle.R, RageUI.CurrentMenu.Rectangle.G, RageUI.CurrentMenu.Rectangle.B, RageUI.CurrentMenu.Rectangle.A)
					end

					RenderText(RageUI.CurrentMenu.Title, RageUI.CurrentMenu.X + RageUI.Settings.Items.Title.Text.X + (RageUI.CurrentMenu.WidthOffset / 2), RageUI.CurrentMenu.Y + RageUI.Settings.Items.Title.Text.Y, 1, RageUI.Settings.Items.Title.Text.Scale, 255, 255, 255, 255, 1)
					RageUI.ItemOffset = RageUI.ItemOffset + RageUI.Settings.Items.Title.Background.Height
				end
			end
		end
	else
		error("Enabled is not boolean")
	end
end

---Subtitle
---@return void
---@public
function RageUI.Subtitle()
	if RageUI.CurrentMenu ~= nil then
		if RageUI.CurrentMenu() then
			RageUI.ItemsSafeZone(RageUI.CurrentMenu)

			if RageUI.CurrentMenu.Subtitle ~= "" then
				RenderRectangle(RageUI.CurrentMenu.X, RageUI.CurrentMenu.Y + RageUI.ItemOffset, RageUI.Settings.Items.Subtitle.Background.Width + RageUI.CurrentMenu.WidthOffset, RageUI.Settings.Items.Subtitle.Background.Height + RageUI.CurrentMenu.SubtitleHeight, 0, 0, 0, 255)
				RenderText(RageUI.CurrentMenu.Subtitle, RageUI.CurrentMenu.X + RageUI.Settings.Items.Subtitle.Text.X, RageUI.CurrentMenu.Y + RageUI.Settings.Items.Subtitle.Text.Y + RageUI.ItemOffset, 0, RageUI.Settings.Items.Subtitle.Text.Scale, 245, 245, 245, 255, nil, false, false, RageUI.Settings.Items.Subtitle.Background.Width + RageUI.CurrentMenu.WidthOffset)

				if RageUI.CurrentMenu.Index > RageUI.CurrentMenu.Options or RageUI.CurrentMenu.Index < 0 then
						RageUI.CurrentMenu.Index = 1
				end

				if RageUI.CurrentMenu.PageCounter == nil then
					RenderText(RageUI.CurrentMenu.PageCounterColour .. RageUI.CurrentMenu.Index .. " / " .. RageUI.CurrentMenu.Options, RageUI.CurrentMenu.X + RageUI.Settings.Items.Subtitle.PreText.X + RageUI.CurrentMenu.WidthOffset, RageUI.CurrentMenu.Y + RageUI.Settings.Items.Subtitle.PreText.Y + RageUI.ItemOffset, 0, RageUI.Settings.Items.Subtitle.PreText.Scale, 245, 245, 245, 255, 2)
				else
					RenderText(RageUI.CurrentMenu.PageCounter, RageUI.CurrentMenu.X + RageUI.Settings.Items.Subtitle.PreText.X + RageUI.CurrentMenu.WidthOffset, RageUI.CurrentMenu.Y + RageUI.Settings.Items.Subtitle.PreText.Y + RageUI.ItemOffset, 0, RageUI.Settings.Items.Subtitle.PreText.Scale, 245, 245, 245, 255, 2)
				end

				RageUI.ItemOffset = RageUI.ItemOffset + RageUI.Settings.Items.Subtitle.Background.Height
			end
		end
	end
end

---Background
---@return void
---@public
function RageUI.Background()
	if RageUI.CurrentMenu ~= nil then
		if RageUI.CurrentMenu() then
			RageUI.ItemsSafeZone(RageUI.CurrentMenu)
			SetScriptGfxDrawOrder(0)
			RenderSprite(RageUI.Settings.Items.Background.Dictionary, RageUI.Settings.Items.Background.Texture, RageUI.CurrentMenu.X, RageUI.CurrentMenu.Y + RageUI.Settings.Items.Background.Y + RageUI.CurrentMenu.SubtitleHeight, RageUI.Settings.Items.Background.Width + RageUI.CurrentMenu.WidthOffset, RageUI.ItemOffset, 0, 0, 0, 255)
			SetScriptGfxDrawOrder(1)
		end
	end
end

---Description
---@return void
---@public
function RageUI.Description()
	if RageUI.CurrentMenu ~= nil and RageUI.CurrentMenu.Description ~= nil and RageUI.CurrentMenu.Description ~= "" then
		if RageUI.CurrentMenu() then
			RageUI.ItemsSafeZone(RageUI.CurrentMenu)
			RenderRectangle(RageUI.CurrentMenu.X, RageUI.CurrentMenu.Y + RageUI.Settings.Items.Description.Bar.Y + RageUI.CurrentMenu.SubtitleHeight + RageUI.ItemOffset, RageUI.Settings.Items.Description.Bar.Width + RageUI.CurrentMenu.WidthOffset, RageUI.Settings.Items.Description.Bar.Height, 0, 0, 0, 255)
			RenderSprite(RageUI.Settings.Items.Description.Background.Dictionary, RageUI.Settings.Items.Description.Background.Texture, RageUI.CurrentMenu.X, RageUI.CurrentMenu.Y + RageUI.Settings.Items.Description.Background.Y + RageUI.CurrentMenu.SubtitleHeight + RageUI.ItemOffset, RageUI.Settings.Items.Description.Background.Width + RageUI.CurrentMenu.WidthOffset, RageUI.CurrentMenu.DescriptionHeight, 0, 0, 0, 255)
			RenderText(RageUI.CurrentMenu.Description, RageUI.CurrentMenu.X + RageUI.Settings.Items.Description.Text.X, RageUI.CurrentMenu.Y + RageUI.Settings.Items.Description.Text.Y + RageUI.CurrentMenu.SubtitleHeight + RageUI.ItemOffset, 0, RageUI.Settings.Items.Description.Text.Scale, 255, 255, 255, 255, nil, false, false, RageUI.Settings.Items.Description.Background.Width + RageUI.CurrentMenu.WidthOffset)
			RageUI.ItemOffset = RageUI.ItemOffset + RageUI.CurrentMenu.DescriptionHeight + RageUI.Settings.Items.Description.Bar.Y
		end
	end
end

---Header
---@return void
---@public
function RageUI.Header(EnableBanner)
	RageUI.Banner(EnableBanner)
	RageUI.Subtitle()
end

---Render
---@param instructionalButton boolean
---@return void
---@public
function RageUI.Render(instructionalButton)
	if RageUI.CurrentMenu ~= nil then
		if RageUI.CurrentMenu() then
			if RageUI.Settings.Debug then
				up = nil

				if RageUI.CurrentMenu.Controls.Up.Pressed then
					up = "~g~True~s~"
				else
					up = "~r~False~s~"
				end

				down = nil

				if RageUI.CurrentMenu.Controls.Down.Pressed then
					down = "~g~True~s~"
				else
					down = "~r~False~s~"
				end

				left = nil

				if RageUI.CurrentMenu.Controls.Left.Pressed then
					left = "~g~True~s~"
				else
					left = "~r~False~s~"
				end

				right = nil

				if RageUI.CurrentMenu.Controls.Right.Pressed then
					right = "~g~True~s~"
				else
					right = "~r~False~s~"
				end

				text = "~r~Debug\n~s~Options max : " .. RageUI.Options .. "\n" .. "Current index : " .. RageUI.CurrentMenu.Index .. "\nTitle : " .. RageUI.CurrentMenu.Title .. "\n~s~Subtitle : " .. RageUI.CurrentMenu.Subtitle .. "\n~s~Up pressed : " .. up .. "\nDown pressed : " .. down .. "\nRight pressed : " .. right .. "\nLeft pressed : " .. left
				RenderSprite(RageUI.Settings.Items.Description.Background.Dictionary, RageUI.Settings.Items.Description.Background.Texture, RageUI.CurrentMenu.X, RageUI.CurrentMenu.Y + RageUI.Settings.Items.Description.Background.Y + RageUI.CurrentMenu.SubtitleHeight + RageUI.ItemOffset, RageUI.Settings.Items.Description.Background.Width + RageUI.CurrentMenu.WidthOffset, 250, 0, 0, 0, 255)
				RenderText(text, RageUI.CurrentMenu.X + RageUI.Settings.Items.Description.Text.X, RageUI.CurrentMenu.Y + RageUI.Settings.Items.Description.Text.Y + RageUI.CurrentMenu.SubtitleHeight + RageUI.ItemOffset, 0, RageUI.Settings.Items.Description.Text.Scale, 255, 255, 255, 255, nil, false, false, RageUI.Settings.Items.Description.Background.Width + RageUI.CurrentMenu.WidthOffset)
			end

			if RageUI.CurrentMenu.Safezone then
				ResetScriptGfxAlign()
			end

			if instructionalButton then
				DrawScaleformMovieFullscreen(RageUI.CurrentMenu.InstructionalScaleform, 255, 255, 255, 255, 0)
			end

			RageUI.CurrentMenu.Options = RageUI.Options
			RageUI.CurrentMenu.SafeZoneSize = nil
			RageUI.Controls()
			RageUI.Options = 0
			RageUI.StatisticPanelCount = 0
			RageUI.ItemOffset = 0

			if RageUI.CurrentMenu.Controls.Back.Enabled and RageUI.CurrentMenu.Closable then
				if RageUI.CurrentMenu.Controls.Back.Pressed then
					RageUI.CurrentMenu.Controls.Back.Pressed = false
					RageUI.GoBack()
				end
			end

			if RageUI.NextMenu ~= nil then
				if RageUI.NextMenu() then
					RageUI.Visible(RageUI.CurrentMenu, false)
					RageUI.Visible(RageUI.NextMenu, true)
					RageUI.CurrentMenu.Controls.Select.Active = false
				end
			end
		end
	end
end

---DrawContent
---@param items function
---@param panels function
function RageUI.DrawContent(settings, items, panels)
	if (settings.header ~= nil) then
		RageUI.Header(settings.header)
	else
		RageUI.Header(true)
	end

	if (items ~= nil) then
		items()
	end

	RageUI.Background()
	RageUI.Navigation()
	RageUI.Description()

	if (panels ~= nil) then
		panels()
	end

	if (settings.instructionalButton ~= nil) then
		RageUI.Render(settings.instructionalButton)
	else
		RageUI.Render(true)
	end
end

---ItemsDescription
---@param CurrentMenu table
---@param Description string
---@param Selected boolean
---@return void
---@public
function RageUI.ItemsDescription(CurrentMenu, Description, Selected)
	---@type table
	local SettingsDescription = RageUI.Settings.Items.Description

	if Selected and CurrentMenu.Description ~= Description then
		CurrentMenu.Description = Description or nil

		---@type number
		local DescriptionLineCount = GetLineCount(CurrentMenu.Description, CurrentMenu.X + SettingsDescription.Text.X, CurrentMenu.Y + SettingsDescription.Text.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, 0, SettingsDescription.Text.Scale, 255, 255, 255, 255, nil, false, false, SettingsDescription.Background.Width + CurrentMenu.WidthOffset)

		if DescriptionLineCount > 1 then
			CurrentMenu.DescriptionHeight = SettingsDescription.Background.Height * DescriptionLineCount
		else
			CurrentMenu.DescriptionHeight = SettingsDescription.Background.Height + 7
		end
	end
end

---MouseBounds
---@param CurrentMenu table
---@param Selected boolean
---@param Option number
---@param SettingsButton table
---@return boolean
---@public
function RageUI.ItemsMouseBounds(CurrentMenu, Selected, Option, SettingsButton)
	---@type boolean
	local Hovered = false
	Hovered = RageUI.IsMouseInBounds(CurrentMenu.X + CurrentMenu.SafeZoneSize.X, CurrentMenu.Y + SettingsButton.Rectangle.Y + CurrentMenu.SafeZoneSize.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, SettingsButton.Rectangle.Width + CurrentMenu.WidthOffset, SettingsButton.Rectangle.Height)

	if Hovered and not Selected then
		RenderRectangle(CurrentMenu.X, CurrentMenu.Y + SettingsButton.Rectangle.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, SettingsButton.Rectangle.Width + CurrentMenu.WidthOffset, SettingsButton.Rectangle.Height, 255, 255, 255, 20)

		if CurrentMenu.Controls.Click.Active then
			CurrentMenu.Index = Option
			local Audio = RageUI.Settings.Audio
			RageUI.PlaySound(Audio[Audio.Use].Error.audioName, Audio[Audio.Use].Error.audioRef)
		end
	end

	return Hovered
end

---ItemsSafeZone
---@param CurrentMenu table
---@return void
---@public
function RageUI.ItemsSafeZone(CurrentMenu)
	if CurrentMenu.Safezone then
		CurrentMenu.SafeZoneSize = RageUI.GetSafeZoneBounds()
		SetScriptGfxAlign(76, 84)
		SetScriptGfxAlignParams(0, 0, 0, 0)
	end
end

---CreateWhile
---@param wait number
---@param closure function
---@param beforeWait boolean
---@return void
---@public
function RageUI.CreateWhile(wait, closure, beforeWait)
	Citizen.CreateThread(function()
		while true do
			if (beforeWait or beforeWait == nil) then
				Citizen.Wait(wait or 0.1)
				closure()
			else
				closure()
				Citizen.Wait(wait or 0.1)
			end
		end
	end)
end
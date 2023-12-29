---IsMouseInBounds
---@param X number
---@param Y number
---@param Width number
---@param Height number
---@return number
---@public
function RageUI.IsMouseInBounds(X, Y, Width, Height)
    local MX, MY = math.round(GetControlNormal(0, 239) * 1920) / 1920, math.round(GetControlNormal(0, 240) * 1080) / 1080
    X, Y = X / 1920, Y / 1080
    Width, Height = Width / 1920, Height / 1080

    return (MX >= X and MX <= X + Width) and (MY > Y and MY < Y + Height)
end

---GetSafeZoneBounds
---@return table
---@public
function RageUI.GetSafeZoneBounds()
    local SafeSize = GetSafeZoneSize()
    SafeSize = math.round(SafeSize, 2)
    SafeSize = (SafeSize * 100) - 90
    SafeSize = 10 - SafeSize
    local W, H = 1920, 1080

    return { X = math.round(SafeSize * ((W / H) * 5.4)), Y = math.round(SafeSize * 5.4) }
end

---GoBack
---@return void
---@public
function RageUI.GoBack()
    if RageUI.CurrentMenu ~= nil then
        local Audio = RageUI.Settings.Audio
        RageUI.PlaySound(Audio[Audio.Use].Back.audioName, Audio[Audio.Use].Back.audioRef)

        if RageUI.CurrentMenu.Closed ~= nil then
            RageUI.CurrentMenu.Closed()
        end

        if RageUI.CurrentMenu.Parent ~= nil then
            if RageUI.CurrentMenu.Parent() then
                RageUI.NextMenu = RageUI.CurrentMenu.Parent
            else
                RageUI.NextMenu = nil
                RageUI.Visible(RageUI.CurrentMenu, false)
            end
        else
            RageUI.NextMenu = nil
            RageUI.Visible(RageUI.CurrentMenu, false)
        end
    end
end

---GoUp
---@param Options number
---@return void
---@public
function RageUI.GoUp(Options)
    if RageUI.CurrentMenu ~= nil then
        Options = RageUI.CurrentMenu.Options

        if RageUI.CurrentMenu() then
            if (Options ~= 0) then
                if Options > RageUI.CurrentMenu.Pagination.Total then
                    if RageUI.CurrentMenu.Index <= RageUI.CurrentMenu.Pagination.Minimum then
                        if RageUI.CurrentMenu.Index == 1 then
                            RageUI.CurrentMenu.Pagination.Minimum = Options - (RageUI.CurrentMenu.Pagination.Total - 1)
                            RageUI.CurrentMenu.Pagination.Maximum = Options
                            RageUI.CurrentMenu.Index = Options
                        else
                            RageUI.CurrentMenu.Pagination.Minimum = RageUI.CurrentMenu.Pagination.Minimum - 1
                            RageUI.CurrentMenu.Pagination.Maximum = RageUI.CurrentMenu.Pagination.Maximum - 1
                            RageUI.CurrentMenu.Index = RageUI.CurrentMenu.Index - 1
                        end
                    else
                        RageUI.CurrentMenu.Index = RageUI.CurrentMenu.Index - 1
                    end
                else
                    if RageUI.CurrentMenu.Index == 1 then
                        RageUI.CurrentMenu.Pagination.Minimum = Options - (RageUI.CurrentMenu.Pagination.Total - 1)
                        RageUI.CurrentMenu.Pagination.Maximum = Options
                        RageUI.CurrentMenu.Index = Options
                    else
                        RageUI.CurrentMenu.Index = RageUI.CurrentMenu.Index - 1
                    end
                end

                local Audio = RageUI.Settings.Audio
                RageUI.PlaySound(Audio[Audio.Use].UpDown.audioName, Audio[Audio.Use].UpDown.audioRef)
            else
                local Audio = RageUI.Settings.Audio
                RageUI.PlaySound(Audio[Audio.Use].Error.audioName, Audio[Audio.Use].Error.audioRef)
            end
        end
    end
end

---GoDown
---@param Options number
---@return void
---@public
function RageUI.GoDown(Options)
    if RageUI.CurrentMenu ~= nil then
        Options = RageUI.CurrentMenu.Options

        if RageUI.CurrentMenu() then
            if (Options ~= 0) then
                if Options > RageUI.CurrentMenu.Pagination.Total then
                    if RageUI.CurrentMenu.Index >= RageUI.CurrentMenu.Pagination.Maximum then
                        if RageUI.CurrentMenu.Index == Options then
                            RageUI.CurrentMenu.Pagination.Minimum = 1
                            RageUI.CurrentMenu.Pagination.Maximum = RageUI.CurrentMenu.Pagination.Total
                            RageUI.CurrentMenu.Index = 1
                        else
                            RageUI.CurrentMenu.Pagination.Maximum = RageUI.CurrentMenu.Pagination.Maximum + 1
                            RageUI.CurrentMenu.Pagination.Minimum = RageUI.CurrentMenu.Pagination.Maximum - (RageUI.CurrentMenu.Pagination.Total - 1)
                            RageUI.CurrentMenu.Index = RageUI.CurrentMenu.Index + 1
                        end
                    else
                        RageUI.CurrentMenu.Index = RageUI.CurrentMenu.Index + 1
                    end
                else
                    if RageUI.CurrentMenu.Index == Options then
                        RageUI.CurrentMenu.Pagination.Minimum = 1
                        RageUI.CurrentMenu.Pagination.Maximum = RageUI.CurrentMenu.Pagination.Total
                        RageUI.CurrentMenu.Index = 1
                    else
                        RageUI.CurrentMenu.Index = RageUI.CurrentMenu.Index + 1
                    end
                end

                local Audio = RageUI.Settings.Audio
                RageUI.PlaySound(Audio[Audio.Use].UpDown.audioName, Audio[Audio.Use].UpDown.audioRef)
            else
                local Audio = RageUI.Settings.Audio
                RageUI.PlaySound(Audio[Audio.Use].Error.audioName, Audio[Audio.Use].Error.audioRef)
            end
        end
    end
end

function RageUI.GoLeft(Controls)
    if Controls.Left.Enabled then
        if not Controls.Left.Pressed then
            for Index = 1, #Controls.Left.Keys do
                if IsDisabledControlJustPressed(Controls.Left.Keys[Index][1], Controls.Left.Keys[Index][2]) then
                    CreateThread(function()
                        Controls.Left.Pressed = true
                        Controls.Left.Active = true
                        Wait(0)

                        Controls.Left.Active = false
                        Wait(175)

                        while Controls.Left.Enabled and IsDisabledControlPressed(Controls.Left.Keys[Index][1], Controls.Left.Keys[Index][2]) do
                            Controls.Left.Active = true
                            Wait(0)

                            Controls.Left.Active = false
                            Wait(125)
                        end

                        Controls.Left.Pressed = false
                    end)

                    break
                end
            end
        end
    end
end

function RageUI.GoRight(Controls)
    if Controls.Right.Enabled then
        if not Controls.Right.Pressed then
            for Index = 1, #Controls.Right.Keys do
                if IsDisabledControlJustPressed(Controls.Right.Keys[Index][1], Controls.Right.Keys[Index][2]) then
                    CreateThread(function()
                        Controls.Right.Pressed = true
                        Controls.Right.Active = true
                        Wait(0)

                        Controls.Right.Active = false
                        Wait(175)

                        while Controls.Right.Enabled and IsDisabledControlPressed(Controls.Right.Keys[Index][1], Controls.Right.Keys[Index][2]) do
                            Controls.Right.Active = true
                            Wait(0)

                            Controls.Right.Active = false
                            Wait(125)
                        end

                        Controls.Right.Pressed = false
                    end)

                    break
                end
            end
        end
    end
end

function RageUI.GoSliderLeft(Controls)
    if Controls.SliderLeft.Enabled then
        if not Controls.SliderLeft.Pressed then
            for Index = 1, #Controls.SliderLeft.Keys do
                if IsDisabledControlJustPressed(Controls.SliderLeft.Keys[Index][1], Controls.SliderLeft.Keys[Index][2]) then
                    CreateThread(function()
                        Controls.SliderLeft.Pressed = true
                        Controls.SliderLeft.Active = true
                        Wait(0)

                        Controls.SliderLeft.Active = false

                        while Controls.SliderLeft.Enabled and IsDisabledControlPressed(Controls.SliderLeft.Keys[Index][1], Controls.SliderLeft.Keys[Index][2]) do
                            Controls.SliderLeft.Active = true
                            Wait(0)

                            Controls.SliderLeft.Active = false
                        end

                        Controls.SliderLeft.Pressed = false
                    end)

                    break
                end
            end
        end
    end
end

function RageUI.GoSliderRight(Controls)
    if Controls.SliderRight.Enabled then
        if not Controls.SliderRight.Pressed then
            for Index = 1, #Controls.SliderRight.Keys do
                if IsDisabledControlJustPressed(Controls.SliderRight.Keys[Index][1], Controls.SliderRight.Keys[Index][2]) then
                    CreateThread(function()
                        Controls.SliderRight.Pressed = true
                        Controls.SliderRight.Active = true
                        Wait(0)

                        Controls.SliderRight.Active = false

                        while Controls.SliderRight.Enabled and IsDisabledControlPressed(Controls.SliderRight.Keys[Index][1], Controls.SliderRight.Keys[Index][2]) do
                            Controls.SliderRight.Active = true
                            Wait(0)

                            Controls.SliderRight.Active = false
                        end

                        Controls.SliderRight.Pressed = false
                    end)

                    break
                end
            end
        end
    end
end

---Controls
---@return void
---@public
function RageUI.Controls()
    if RageUI.CurrentMenu ~= nil then
        if RageUI.CurrentMenu() then
            if RageUI.CurrentMenu.Open then
                local Controls = RageUI.CurrentMenu.Controls

                ---@type number
                local Options = RageUI.CurrentMenu.Options
                RageUI.Options = RageUI.CurrentMenu.Options

                if RageUI.CurrentMenu.EnableMouse then
                    DisableAllControlActions(2)
                end

                if not IsUsingKeyboard(2) then
                    for Index = 1, #Controls.Enabled.Controller do
                        EnableControlAction(Controls.Enabled.Controller[Index][1], Controls.Enabled.Controller[Index][2], true)
                    end
                else
                    for Index = 1, #Controls.Enabled.Keyboard do
                        EnableControlAction(Controls.Enabled.Keyboard[Index][1], Controls.Enabled.Keyboard[Index][2], true)
                    end
                end

                if Controls.Up.Enabled then
                    if not Controls.Up.Pressed then
                        for Index = 1, #Controls.Up.Keys do
                            if IsDisabledControlJustPressed(Controls.Up.Keys[Index][1], Controls.Up.Keys[Index][2]) then
                                CreateThread(function()
                                    Controls.Up.Pressed = true
                                    Wait(0)

                                    RageUI.GoUp(Options)
                                    Wait(175)

                                    while Controls.Up.Enabled and IsDisabledControlPressed(Controls.Up.Keys[Index][1], Controls.Up.Keys[Index][2]) do
                                        RageUI.GoUp(Options)
                                        Wait(100)
                                    end

                                    Controls.Up.Pressed = false
                                end)

                                break
                            end
                        end
                    end
                end

                if Controls.Down.Enabled then
                    if not Controls.Down.Pressed then
                        for Index = 1, #Controls.Down.Keys do
                            if IsDisabledControlJustPressed(Controls.Down.Keys[Index][1], Controls.Down.Keys[Index][2]) then
                                CreateThread(function()
                                    Controls.Down.Pressed = true
                                    Wait(0)

                                    RageUI.GoDown(Options)
                                    Wait(175)

                                    while Controls.Down.Enabled and IsDisabledControlPressed(Controls.Down.Keys[Index][1], Controls.Down.Keys[Index][2]) do
                                        RageUI.GoDown(Options)
                                        Wait(100)
                                    end

                                    Controls.Down.Pressed = false
                                end)

                                break
                            end
                        end
                    end
                end

                RageUI.GoLeft(Controls) --- Default Left navigation
                RageUI.GoRight(Controls) --- Default Right navigation

                RageUI.GoSliderLeft(Controls)
                RageUI.GoSliderRight(Controls)

                if Controls.Select.Enabled then
                    if not Controls.Select.Pressed then
                        for Index = 1, #Controls.Select.Keys do
                            if IsDisabledControlJustPressed(Controls.Select.Keys[Index][1], Controls.Select.Keys[Index][2]) then
                                CreateThread(function()
                                    Controls.Select.Pressed = true
                                    Controls.Select.Active = true
                                    Wait(0)

                                    Controls.Select.Active = false
                                    Controls.Select.Pressed = false
                                end)

                                break
                            end
                        end
                    end
                end

                if Controls.Click.Enabled then
                    if not Controls.Click.Pressed then
                        for Index = 1, #Controls.Click.Keys do
                            if IsDisabledControlJustPressed(Controls.Click.Keys[Index][1], Controls.Click.Keys[Index][2]) then
                                CreateThread(function()
                                    Controls.Click.Pressed = true
                                    Controls.Click.Active = true
                                    Wait(0)

                                    Controls.Click.Active = false
                                    Controls.Click.Pressed = false
                                end)

                                break
                            end
                        end
                    end
                end

                if Controls.Back.Enabled then
                    if not Controls.Back.Pressed then
                        for Index = 1, #Controls.Back.Keys do
                            if IsDisabledControlJustPressed(Controls.Back.Keys[Index][1], Controls.Back.Keys[Index][2]) then
                                Controls.Back.Pressed = true
                                Wait(10)
                                break
                            end
                        end
                    end
                end
            end
        end
    end
end

---Navigation
---@return void
---@public
function RageUI.Navigation()
    if RageUI.CurrentMenu ~= nil then
        if RageUI.CurrentMenu() then
            if RageUI.CurrentMenu.EnableMouse then
                ShowCursorThisFrame()
            end

            if RageUI.Options > RageUI.CurrentMenu.Pagination.Total then
                ---@type boolean
                local UpHovered = false

                ---@type boolean
                local DownHovered = false

                if RageUI.CurrentMenu.Safezone then
                    RageUI.CurrentMenu.SafeZoneSize = RageUI.GetSafeZoneBounds()
                    SetScriptGfxAlign(76, 84)
                    SetScriptGfxAlignParams(0, 0, 0, 0)
                end

                UpHovered = RageUI.IsMouseInBounds(RageUI.CurrentMenu.X + RageUI.CurrentMenu.SafeZoneSize.X, RageUI.CurrentMenu.Y + RageUI.CurrentMenu.SafeZoneSize.Y + RageUI.CurrentMenu.SubtitleHeight + RageUI.ItemOffset, RageUI.Settings.Items.Navigation.Rectangle.Width + RageUI.CurrentMenu.WidthOffset, RageUI.Settings.Items.Navigation.Rectangle.Height)
                DownHovered = RageUI.IsMouseInBounds(RageUI.CurrentMenu.X + RageUI.CurrentMenu.SafeZoneSize.X, RageUI.CurrentMenu.Y + RageUI.Settings.Items.Navigation.Rectangle.Height + RageUI.CurrentMenu.SafeZoneSize.Y + RageUI.CurrentMenu.SubtitleHeight + RageUI.ItemOffset, RageUI.Settings.Items.Navigation.Rectangle.Width + RageUI.CurrentMenu.WidthOffset, RageUI.Settings.Items.Navigation.Rectangle.Height)

                if RageUI.CurrentMenu.EnableMouse then
                    if RageUI.CurrentMenu.Controls.Click.Active then
                        if UpHovered then
                            RageUI.GoUp(RageUI.Options)
                        elseif DownHovered then
                            RageUI.GoDown(RageUI.Options)
                        end
                    end

                    if UpHovered then
                        RenderRectangle(RageUI.CurrentMenu.X, RageUI.CurrentMenu.Y + RageUI.CurrentMenu.SubtitleHeight + RageUI.ItemOffset, RageUI.Settings.Items.Navigation.Rectangle.Width + RageUI.CurrentMenu.WidthOffset, RageUI.Settings.Items.Navigation.Rectangle.Height, 30, 30, 30, 255)
                    else
                        RenderRectangle(RageUI.CurrentMenu.X, RageUI.CurrentMenu.Y + RageUI.CurrentMenu.SubtitleHeight + RageUI.ItemOffset, RageUI.Settings.Items.Navigation.Rectangle.Width + RageUI.CurrentMenu.WidthOffset, RageUI.Settings.Items.Navigation.Rectangle.Height, 0, 0, 0, 200)
                    end

                    if DownHovered then
                        RenderRectangle(RageUI.CurrentMenu.X, RageUI.CurrentMenu.Y + RageUI.Settings.Items.Navigation.Rectangle.Height + RageUI.CurrentMenu.SubtitleHeight + RageUI.ItemOffset, RageUI.Settings.Items.Navigation.Rectangle.Width + RageUI.CurrentMenu.WidthOffset, RageUI.Settings.Items.Navigation.Rectangle.Height, 30, 30, 30, 255)
                    else
                        RenderRectangle(RageUI.CurrentMenu.X, RageUI.CurrentMenu.Y + RageUI.Settings.Items.Navigation.Rectangle.Height + RageUI.CurrentMenu.SubtitleHeight + RageUI.ItemOffset, RageUI.Settings.Items.Navigation.Rectangle.Width + RageUI.CurrentMenu.WidthOffset, RageUI.Settings.Items.Navigation.Rectangle.Height, 0, 0, 0, 200)
                    end
                else
                    RenderRectangle(RageUI.CurrentMenu.X, RageUI.CurrentMenu.Y + RageUI.CurrentMenu.SubtitleHeight + RageUI.ItemOffset, RageUI.Settings.Items.Navigation.Rectangle.Width + RageUI.CurrentMenu.WidthOffset, RageUI.Settings.Items.Navigation.Rectangle.Height, 0, 0, 0, 200)
                    RenderRectangle(RageUI.CurrentMenu.X, RageUI.CurrentMenu.Y + RageUI.Settings.Items.Navigation.Rectangle.Height + RageUI.CurrentMenu.SubtitleHeight + RageUI.ItemOffset, RageUI.Settings.Items.Navigation.Rectangle.Width + RageUI.CurrentMenu.WidthOffset, RageUI.Settings.Items.Navigation.Rectangle.Height, 0, 0, 0, 200)
                end

                RenderSprite(RageUI.Settings.Items.Navigation.Arrows.Dictionary, RageUI.Settings.Items.Navigation.Arrows.Texture, RageUI.CurrentMenu.X + RageUI.Settings.Items.Navigation.Arrows.X + (RageUI.CurrentMenu.WidthOffset / 2), RageUI.CurrentMenu.Y + RageUI.Settings.Items.Navigation.Arrows.Y + RageUI.CurrentMenu.SubtitleHeight + RageUI.ItemOffset, RageUI.Settings.Items.Navigation.Arrows.Width, RageUI.Settings.Items.Navigation.Arrows.Height)
                RageUI.ItemOffset = RageUI.ItemOffset + (RageUI.Settings.Items.Navigation.Rectangle.Height * 2)
            end
        end
    end
end

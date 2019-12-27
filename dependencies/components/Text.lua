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
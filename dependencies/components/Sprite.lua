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
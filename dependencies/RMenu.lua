---@type table
RageUI = {}

---@type table
RMenu = setmetatable({}, RMenu)

---Add
---@param Type string
---@param Name string
---@param Menu table
---@return void
---@public
function RMenu.Add(Type, Name, Menu, Restriction)
	if RMenu[Type] == nil then
		RMenu[Type] = {}
	end

	table.insert(RMenu[Type], {
		Name = Name,
		Menu = Menu,
		Restriction = Restriction
	})
end

---Get
---@param Type string
---@param Name string
---@return table
---@public
function RMenu.Get(Type, Name)
	if RMenu[Type] ~= nil then
		for i = 1, #RMenu[Type], 1 do
			if RMenu[Type][i].Name == Name then
				return RMenu[Type][i].Menu
			end
		end
	end
end

---Delete
---@param Type string
---@param Name string
---@return void
---@public
function RMenu.Delete(Type, Name)
	if RMenu[Type] ~= nil then
		for i = 1, #RMenu[Type], 1 do
			if RMenu[Type][i].Name == Name then
				table.remove(RMenu[Type], i)
			end
		end
	end
end

---Settings
---@param Type string
---@param Name string
---@param Settings string
---@param Value any
---@return void
---@public
function RMenu.Settings(Type, Name, Settings, Value)
	for i = 1, #RMenu[Type], 1 do
		if RMenu[Type][i].Name == Name then
			if Value ~= nil then
				RMenu[Type][i][Settings] = Value
			else
				return RMenu[Type][i][Settings]
			end
		end
	end
end
---@type table
RageUI = {}

---@type table
RMenu = setmetatable({}, RMenu)

---@type table
local TotalMenus = {}

---Add
---@param Type string
---@param Name string
---@param Menu table
---@return void
---@public
function RMenu.Add(Type, Name, Menu, ItemType)
	if RMenu[Type] == nil then
		RMenu[Type] = {}
	end

	table.insert(RMenu[Type], {
		Name = Name,
		Menu = Menu
	})

	table.insert(TotalMenus, Menu)
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

---GetType
---@param Type string
---@return table
---@public
function RMenu.GetType(Type)
	if RMenu[Type] ~= nil then
		return RMenu[Type]
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

---DeleteType
---@param Type string
---@return void
---@public
function RMenu.DeleteType(Type)
	if RMenu[Type] ~= nil then
		RMenu[Type] = nil
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
			RMenu[Type][i][Settings] = Value
		end
	end
end
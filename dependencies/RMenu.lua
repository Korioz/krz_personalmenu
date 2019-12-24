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
function RMenu.Add(Type, Name, Menu)
	if RMenu[Type] ~= nil then
		RMenu[Type][Name] = {
			Menu = Menu
		}
	else
		RMenu[Type] = {}
		RMenu[Type][Name] = {
			Menu = Menu
		}
	end

	table.insert(TotalMenus, Menu)
end

---Get
---@param Type string
---@param Name string
---@return table
---@public
function RMenu:Get(Type, Name)
	if self[Type] ~= nil and self[Type][Name] ~= nil then
		return self[Type][Name].Menu
	end
end

---Settings
---@param Type string
---@param Name string
---@param Settings string
---@param Value any
---@return void
---@public
function RMenu:Settings(Type, Name, Settings, Value)
	self[Type][Name][Settings] = Value
end


---Delete
---@param Type string
---@param Name string
---@return void
---@public
function RMenu:Delete(Type, Name)
	self[Type][Name] = nil
end

---DeleteType
---@param Type string
---@return void
---@public
function RMenu:DeleteType(Type)
	self[Type] = nil
end
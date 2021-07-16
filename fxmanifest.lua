fx_version 'cerulean'
game 'gta5'

lua54 'yes'

author 'Korioz'
description 'PersonalMenu for FiveM developed on top of ESX and RageUI'
version '2.1'

dependency 'es_extended'

shared_scripts {
	'@es_extended/locale.lua',
	'locales/*.lua',
	'config.lua',
	'init.lua'
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server/main.lua'
}

client_scripts {
	"dependencies/RMenu.lua",

	"dependencies/components/*.lua",

	"dependencies/menu/RageUI.lua",
	"dependencies/menu/Menu.lua",
	"dependencies/menu/MenuController.lua",

	"dependencies/menu/elements/*.lua",
	"dependencies/menu/items/*.lua",

	'client/main.lua',
	'client/other.lua'
}

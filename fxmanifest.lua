fx_version 'cerulean'
game 'gta5'

lua54 'yes'

author 'Korioz'
description 'Roleplay personal menu supporting ESX'
version '2.3'

dependency 'es_extended'

shared_scripts {
    'locale.lua',
    'locales/*.lua',
    'config.lua',
    'init.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server/main.lua'
}

client_scripts {
    "dependencies/menu/RageUI.lua",
    "dependencies/menu/Menu.lua",
    "dependencies/menu/MenuController.lua",

    "dependencies/menu/elements/*.lua",
    "dependencies/menu/items/*.lua",

    'client/utils.lua',
    'client/main.lua',
    'client/showName.lua',
    'client/other.lua'
}

resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

author 'Korioz'
description 'KORIOZ-PersonalMenu'
version '1.0'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server/main.lua',
}

client_scripts {
    "dependencies/Wrapper/Utility.lua",

    "dependencies/UIElements/UIVisual.lua",
    "dependencies/UIElements/UIResRectangle.lua",
    "dependencies/UIElements/UIResText.lua",
    "dependencies/UIElements/Sprite.lua",
}

client_scripts {
    "dependencies/UIMenu/elements/Badge.lua",
    "dependencies/UIMenu/elements/Colours.lua",
    "dependencies/UIMenu/elements/ColoursPanel.lua",
    "dependencies/UIMenu/elements/StringMeasurer.lua",

    "dependencies/UIMenu/items/UIMenuItem.lua",
    "dependencies/UIMenu/items/UIMenuCheckboxItem.lua",
    "dependencies/UIMenu/items/UIMenuListItem.lua",
    "dependencies/UIMenu/items/UIMenuSliderItem.lua",
    "dependencies/UIMenu/items/UIMenuSliderHeritageItem.lua",
    "dependencies/UIMenu/items/UIMenuColouredItem.lua",

    "dependencies/UIMenu/items/UIMenuProgressItem.lua",
    "dependencies/UIMenu/items/UIMenuSliderProgressItem.lua",

    "dependencies/UIMenu/windows/UIMenuHeritageWindow.lua",

    "dependencies/UIMenu/panels/UIMenuGridPanel.lua",
    "dependencies/UIMenu/panels/UIMenuHorizontalOneLineGridPanel.lua",
    "dependencies/UIMenu/panels/UIMenuVerticalOneLineGridPanel.lua",
    "dependencies/UIMenu/panels/UIMenuColourPanel.lua",
    "dependencies/UIMenu/panels/UIMenuPercentagePanel.lua",
    "dependencies/UIMenu/panels/UIMenuStatisticsPanel.lua",

    "dependencies/UIMenu/UIMenu.lua",
    "dependencies/UIMenu/MenuPool.lua",
}

client_scripts {
    "dependencies/UITimerBar/UITimerBarPool.lua",

    "dependencies/UITimerBar/items/UITimerBarItem.lua",
    "dependencies/UITimerBar/items/UITimerBarProgressItem.lua",
    "dependencies/UITimerBar/items/UITimerBarProgressWithIconItem.lua",
}

client_scripts {
    "dependencies/UIProgressBar/UIProgressBarPool.lua",
    "dependencies/UIProgressBar/items/UIProgressBarItem.lua",
}

client_scripts {
    "dependencies/NativeUI.lua",
}

client_scripts {
	'@es_extended/locale.lua',
	'locales/fr.lua',
	'config.lua',
	'config.weapons.lua',
	'client/main.lua',
	'someshit/handsup.lua',
	'someshit/pointing.lua',
	'someshit/crouch.lua',
}
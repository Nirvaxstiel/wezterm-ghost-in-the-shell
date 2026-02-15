local Config = require('config')
local wezterm = require('wezterm')
local command_palette = require('config.command-palette')

require('utils.backdrops')
-- :set_focus('#000000')
-- :set_images_dir(require('wezterm').home_dir .. '/Pictures/Wallpapers/')
    :set_images()
    :random()

require('events.left-status').setup()
require('events.right-status').setup({ date_format = '%a %H:%M:%S' })
require('events.tab-title').setup({ hide_active_tab_unseen = false, unseen_icon = 'numbered_box' })
require('events.new-tab-button').setup()
require('events.gui-startup').setup()

-- Augment command palette with custom commands
wezterm.on('augment-command-palette', function(_window, _pane)
    return command_palette.items
end)

return Config:init()
    :append(require('config.appearance'))
    :append(require('config.bindings'))
    :append(require('config.domains'))
    :append(require('config.fonts'))
    :append(require('config.general'))
    :append(require('config.launch')).options

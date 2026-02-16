local Config = require('config')
local wezterm = require('wezterm')
local Features = require('config.features')
local command_palette = require('config.command-palette')

-- ============================================
-- LOAD USER CONFIGURATION
-- ============================================

-- Try to load user config, fall back to defaults
local user_config_exists = pcall(function()
    local user_config = require('config.user')
    user_config:apply()
end)

-- Log if user config doesn't exist (only for first time setup)
if not user_config_exists then
    wezterm.log_info('No user config found at config/user.lua. Using defaults.')
    wezterm.log_info('Copy config/user.lua.example to config/user.lua to customize.')
end

-- ============================================
-- SETUP ALL PLUGINS
-- ============================================

-- Let plugins handle their own feature checks
-- Single guard clause in each setup is enough

-- Backdrops
require('utils.backdrops')
    -- :set_focus('#000000')
    -- :set_images_dir(require('wezterm').home_dir .. '/Pictures/Wallpapers/')
    :set_images()
    :random()

-- Events
require('events.left-status').setup()

-- Get user opts for right-status
local user_opts = {}
pcall(function()
    local user_config = require('config.user')
    user_opts = user_config.custom or {}
end)

require('events.right-status').setup({
    date_format = user_opts.date_format or '%a %H:%M:%S',
    show_workspace = Features.is_enabled('workspace-display'),
    show_cwd = Features.is_enabled('cwd-display'),
    cwd_use_git_root = user_opts.cwd_use_git_root or true,
})

require('events.tab-title').setup({
    hide_active_tab_unseen = user_opts.hide_active_tab_unseen or false,
    unseen_icon = user_opts.unseen_icon or 'circle',
})

require('events.new-tab-button').setup()
require('events.gui-startup').setup()

-- Example: Add custom path aliases for CWD display
-- local CwdUtil = require('utils.cwd')
-- CwdUtil.add_alias('/Users/kei/projects', '📁 projects')
-- CwdUtil.add_alias('/Users/kei/.config', '⚙️ config')
-- CwdUtil.add_alias('/var/log', '📋 logs')

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

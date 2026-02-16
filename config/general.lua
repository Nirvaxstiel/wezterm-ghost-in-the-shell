local wezterm = require('wezterm')
local Features = require('config.features')

-- ============================================
-- USER CONFIG OVERRIDES
-- ============================================

local user_opts = {}
pcall(function()
    local user_config = require('config.user')
    user_opts = user_config.custom or {}
end)

-- ============================================
-- BUILD CONFIG
-- ============================================

local config = {
    -- behaviours
    exit_behavior = 'CloseOnCleanExit', -- if the shell program exited with a successful status
    exit_behavior_messaging = 'Verbose',
    status_update_interval = 1000,
    audible_bell = 'Disabled',
}

-- Auto-reload config (if enabled)
if Features.is_enabled('auto-reload') then
    config.automatically_reload_config = true
end

-- Scrollback buffer (if enabled)
if Features.is_enabled('scrollback') then
    config.scrollback_lines = user_opts.scrollback_lines or 20000
end

-- Hyperlinks (if enabled)
if Features.is_enabled('hyperlinks') then
    config.hyperlink_rules = {
        -- Matches: a URL in parens: (URL)
        {
            regex = '\\((\\w+://\\S+)\\)',
            format = '$1',
            highlight = 1,
        },
        -- Matches: a URL in brackets: [URL]
        {
            regex = '\\[(\\w+://\\S+)\\]',
            format = '$1',
            highlight = 1,
        },
        -- Matches: a URL in curly braces: {URL}
        {
            regex = '\\{(\\w+://\\S+)\\)',
            format = '$1',
            highlight = 1,
        },
        -- Matches: a URL in angle brackets: <URL>
        {
            regex = '<(\\w+://\\S+)>',
            format = '$1',
            highlight = 1,
        },
        -- Then handle URLs not wrapped in brackets
        {
            regex = '\\b\\w+://\\S+[)/a-zA-Z0-9-]+',
            format = '$0',
        },
        -- implicit mailto link
        {
            regex = '\\b\\w+@[\\w-]+(\\.[\\w-]+)+\\b',
            format = 'mailto:$0',
        },
    }
end

-- Window close confirmation (if enabled)
if Features.is_enabled('exit-confirmation') then
    config.window_close_confirmation = 'NeverPrompt'
end

return config

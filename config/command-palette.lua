local wezterm = require('wezterm')
local act = wezterm.action
local backdrops = require('utils.backdrops')

local M = {}

---@type wezterm.CommandPaletteItem[]
M.items = {
    -- Miscellaneous/Useful
    { brief = 'Activate Copy Mode', action = act.ActivateCopyMode },
    { brief = 'Toggle Fullscreen',  action = act.ToggleFullScreen },
    { brief = 'Show Debug Overlay', action = act.ShowDebugOverlay },
    { brief = 'Search Text',        action = act.Search({ CaseInSensitiveString = '' }) },
    {
        brief = 'Open URL Under Cursor',
        action = wezterm.action.QuickSelectArgs({
            label = 'open url',
            patterns = {
                '\\((https?://\\S+)\\)',
                '\\[(https?://\\S+)\\]',
                '\\{(https?://\\S+)\\}',
                '<(https?://\\S+)>',
                '\\bhttps?://\\S+[)/a-zA-Z0-9-]+'
            },
            action = wezterm.action_callback(function(window, pane)
                local url = window:get_selection_text_for_pane(pane)
                wezterm.log_info('opening: ' .. url)
                wezterm.open_with(url)
            end),
        }),
    },

    -- Tabs: Spawn+Close
    { brief = 'Spawn Tab (Default)',    action = act.SpawnTab('DefaultDomain') },
    { brief = 'Spawn Tab (WSL Ubuntu)', action = act.SpawnTab({ DomainName = 'wsl:ubuntu-fish' }) },
    { brief = 'Close Current Tab',      action = act.CloseCurrentTab({ confirm = true }) },

    -- Tabs: Navigation
    { brief = 'Next Tab',               action = act.ActivateTabRelative(1) },
    { brief = 'Previous Tab',           action = act.ActivateTabRelative(-1) },
    { brief = 'Move Tab Left',          action = act.MoveTabRelative(-1) },
    { brief = 'Move Tab Right',         action = act.MoveTabRelative(1) },

    -- Tabs: Toggle/Title
    { brief = 'Toggle Tab Bar',         action = act.EmitEvent('tabs.toggle-tab-bar') },
    { brief = 'Rename Current Tab',     action = act.EmitEvent('tabs.manual-update-tab-title') },
    { brief = 'Undo Rename Tab',        action = act.EmitEvent('tabs.reset-tab-title') },

    -- Windows
    { brief = 'Spawn Window',           action = act.SpawnWindow },
    { brief = 'Maximize Window',        action = wezterm.action_callback(function(window, _pane) window:maximize() end) },
    {
        brief = 'Increase Window Size',
        action = wezterm.action_callback(function(window, _pane)
            local dimensions = window:get_dimensions()
            if not dimensions.is_full_screen then
                window:set_inner_size(dimensions.pixel_width + 50, dimensions.pixel_height + 50)
            end
        end)
    },
    {
        brief = 'Decrease Window Size',
        action = wezterm.action_callback(function(window, _pane)
            local dimensions = window:get_dimensions()
            if not dimensions.is_full_screen then
                window:set_inner_size(dimensions.pixel_width - 50, dimensions.pixel_height - 50)
            end
        end)
    },

    -- Panes: Split
    { brief = 'Split Vertical',               action = act.SplitVertical({ domain = 'CurrentPaneDomain' }) },
    { brief = 'Split Horizontal',             action = act.SplitHorizontal({ domain = 'CurrentPaneDomain' }) },

    -- Panes: Zoom+Close
    { brief = 'Toggle Pane Zoom',             action = act.TogglePaneZoomState },
    { brief = 'Close Current Pane',           action = act.CloseCurrentPane({ confirm = true }) },

    -- Panes: Navigation
    { brief = 'Move to Pane Up',              action = act.ActivatePaneDirection('Up') },
    { brief = 'Move to Pane Down',            action = act.ActivatePaneDirection('Down') },
    { brief = 'Move to Pane Left',            action = act.ActivatePaneDirection('Left') },
    { brief = 'Move to Pane Right',           action = act.ActivatePaneDirection('Right') },
    { brief = 'Swap with Active Pane',        action = act.PaneSelect({ alphabet = '1234567890', mode = 'SwapWithActiveKeepFocus' }) },

    -- Panes: Scroll
    { brief = 'Scroll Up 5 Lines',            action = act.ScrollByLine(-5) },
    { brief = 'Scroll Down 5 Lines',          action = act.ScrollByLine(5) },
    { brief = 'Scroll Page Up',               action = act.ScrollByPage(-0.75) },
    { brief = 'Scroll Page Down',             action = act.ScrollByPage(0.75) },

    -- Background Images
    { brief = 'Select Random Background',     action = wezterm.action_callback(function(window, _pane) backdrops:random(window) end) },
    { brief = 'Cycle to Next Background',     action = wezterm.action_callback(function(window, _pane) backdrops:cycle_forward(window) end) },
    { brief = 'Cycle to Previous Background', action = wezterm.action_callback(function(window, _pane) backdrops:cycle_back(window) end) },
    { brief = 'Toggle Background Focus Mode', action = wezterm.action_callback(function(window, _pane) backdrops:toggle_focus(window) end) },
    { brief = 'Use Transparent Mode (Disable Images)', action = wezterm.action_callback(function(window, _pane) backdrops:enable_transparent(window) end) },
    {
        brief = 'Fuzzy Select Background',
        action = act.InputSelector({
            title = 'Select Background',
            choices = backdrops:choices(),
            fuzzy = true,
            fuzzy_description = 'Select Background: ',
            action = wezterm.action_callback(function(window, _pane, idx)
                if not idx then return end
                backdrops:set_img(window, tonumber(idx))
            end),
        }),
    },

    -- Key Tables (resize operations)
    { brief = 'Resize Font (Key Table)', action = act.ActivateKeyTable({ name = 'resize_font', one_shot = false, timeout_milliseconds = 1000 }) },
    { brief = 'Resize Pane (Key Table)', action = act.ActivateKeyTable({ name = 'resize_pane', one_shot = false, timeout_milliseconds = 1000 }) },

    -- Font Size (direct)
    { brief = 'Increase Font Size',      action = act.IncreaseFontSize },
    { brief = 'Decrease Font Size',      action = act.DecreaseFontSize },
    { brief = 'Reset Font Size',         action = act.ResetFontSize },
}

return M

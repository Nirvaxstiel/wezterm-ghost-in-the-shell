local wezterm = require('wezterm')
local mux = wezterm.mux
local Features = require('config.features')

local M = {}

local STATE_FILE = wezterm.config_dir .. '/window_state.json'
local last_state = nil

local function read_state()
    local f = io.open(STATE_FILE, 'r')
    if not f then return {} end
    local content = f:read('*all')
    f:close()
    local ok, s = pcall(wezterm.json_parse, content)
    return (ok and s) or {}
end

local function save_state(window)
    if not window then return end
    local dims = window:get_dimensions()
    local gui = window:gui_window()
    local pos = (gui and gui.get_position and gui:get_position()) or { x = 0, y = 0 }
    local screens = wezterm.gui.screens()
    local active = screens and screens.active
    local state = {
        pixel_width = dims and dims.pixel_width or 1200,
        pixel_height = dims and dims.pixel_height or 800,
        x = pos and pos.x or 0,
        y = pos and pos.y or 0,
        screen = active and active.name or 'main',
        saved_at = os.time(),
    }
    -- Only write when changed (stops lag from redundant disk I/O)
    local prev = last_state or read_state()
    if prev.pixel_width == state.pixel_width and prev.pixel_height == state.pixel_height
        and prev.x == state.x and prev.y == state.y and prev.screen == state.screen then
        return
    end
    last_state = state
    local f = io.open(STATE_FILE, 'w')
    if f then
        f:write(wezterm.json_encode(state) or '{}')
        f:close()
    else
        wezterm.log_error('Failed to write window state file: ' .. STATE_FILE)
    end
end

local function load_state()
    local f = io.open(STATE_FILE, 'r')
    if not f then return nil end
    local content = f:read('*all')
    f:close()
    local ok, s = pcall(wezterm.json_parse, content)
    return (ok and s) or nil
end

M.setup = function()
    if not Features.is_enabled('window-state') then return end
    -- window-resized fires only when dimensions actually change; eliminates lag
    wezterm.on('window-resized', function(window, pane)
        if window:is_focused() then
            save_state(window)
        end
    end)
    -- Also catch initial focus in case resize event hasn't fired
    wezterm.on('window-focus-changed', function(window, pane)
        if window:is_focused() then
            save_state(window)
        end
    end)
end

function M.setup_startup()
    if not Features.is_enabled('window-state') then return false end
    return load_state() or false
end

return M

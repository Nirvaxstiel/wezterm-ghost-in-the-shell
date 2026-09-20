local wezterm = require('wezterm')
local Features = require('config.features')

local M = {}

local STATE_FILE = wezterm.config_dir .. '/window_state.json'
local last_state = nil
local restoring = false

local function read_state()
    local f = io.open(STATE_FILE, 'r')
    if not f then
        return nil
    end
    local content = f:read('*all')
    f:close()
    local ok, state = pcall(wezterm.json_parse, content)
    if not ok or type(state) ~= 'table' then
        return nil
    end
    return state
end

local function save_state(window)
    if restoring then
        return
    end
    local dims = window:get_dimensions()
    if dims.is_full_screen then
        return
    end
    local state = {
        pixel_width = dims.pixel_width,
        pixel_height = dims.pixel_height,
    }
    local prev = last_state or read_state() or {}
    if prev.pixel_width == state.pixel_width and prev.pixel_height == state.pixel_height then
        return
    end
    last_state = state
    local f = io.open(STATE_FILE, 'w')
    if not f then
        wezterm.log_error('Failed to write window state file: ' .. STATE_FILE)
        return
    end
    f:write(wezterm.json_encode(state) or '{}')
    f:close()
end

local function on_window_event(window)
    if window:is_focused() then
        save_state(window)
    end
end

M.setup = function()
    if not Features.is_enabled('window-state') then
        return
    end
    wezterm.on('window-resized', function(window, _pane)
        on_window_event(window)
    end)
    wezterm.on('window-focus-changed', function(window, _pane)
        on_window_event(window)
    end)
end

function M.setup_startup()
    if not Features.is_enabled('window-state') then
        return false
    end
    return read_state() or false
end

function M.restore_size(gui, state)
    if not (state.pixel_width and state.pixel_height) then
        return
    end
    restoring = true
    last_state = state
    wezterm.time.call_after(0.3, function()
        gui:set_inner_size(state.pixel_width, state.pixel_height)
        restoring = false
    end)
end

return M

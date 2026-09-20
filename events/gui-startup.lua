local wezterm = require('wezterm')
local mux = wezterm.mux
local Features = require('config.features')
local window_state = require('utils.window-state')

local M = {}

M.setup = function()
    if not Features.is_enabled('gui-startup') and not Features.is_enabled('window-state') then
        return
    end

    wezterm.on('gui-startup', function(cmd)
        if Features.is_enabled('window-state') then
            local state = window_state.setup_startup()
            local opts = cmd or {}
            if state then
                opts.width = math.floor((state.pixel_width or 1200) / 9)
                opts.height = math.floor((state.pixel_height or 800) / 18)
            end
            local _, _, window = mux.spawn_window(opts)
            local gui = window and window:gui_window()
            if state and gui then
                window_state.restore_size(gui, state)
            end
            return
        end

        if Features.is_enabled('gui-startup') then
            local _, _, window = mux.spawn_window(cmd or {})
            window:gui_window():maximize()
        end
    end)
end

return M

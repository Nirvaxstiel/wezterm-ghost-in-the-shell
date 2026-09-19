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
        -- When window-state is enabled, restore from saved state instead of maximizing
        if Features.is_enabled('window-state') then
            local state = window_state.setup_startup()
            local opts = cmd or {}
            if state then
                opts.width = math.floor((state.pixel_width or 1200) / 9)
                opts.height = math.floor((state.pixel_height or 800) / 18)
            end
            local _, _, window = mux.spawn_window(opts)
            if state and window then
                local gui = window:gui_window()
                if gui then
                    if state.pixel_width then
                        gui:set_inner_size(state.pixel_width, state.pixel_height)
                    end
                    if state.x and state.y then
                        gui:set_position(state.x, state.y)
                    end
                end
            end
            return
        end

        -- Default maximize behavior when window-state is off
        if Features.is_enabled('gui-startup') then
            local _, _, window = mux.spawn_window(cmd or {})
            window:gui_window():maximize()
        end
    end)
end

return M

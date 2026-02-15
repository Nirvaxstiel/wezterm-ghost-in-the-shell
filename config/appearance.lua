local gpu_adapters = require('utils.gpu-adapter')
local backdrops = require('utils.backdrops')
local colors = require('colors.custom')
local platform = require('utils.platform')

local background_opts = backdrops:initial_options(false, true)

local config = {
    max_fps = 120,
    front_end = 'OpenGL',
    webgpu_power_preference = 'HighPerformance',
    webgpu_preferred_adapter = gpu_adapters:pick_best(),
    underline_thickness = '1.5pt',

    animation_fps = 120,
    cursor_blink_ease_in = 'Constant',
    cursor_blink_ease_out = 'Constant',
    default_cursor_style = 'BlinkingBlock',
    cursor_blink_rate = 650,

    colors = colors,

    enable_scroll_bar = true,

    enable_tab_bar = true,
    hide_tab_bar_if_only_one_tab = false,
    use_fancy_tab_bar = false,
    tab_max_width = 25,
    show_tab_index_in_tab_bar = false,
    switch_to_last_active_tab_when_closing_tab = true,

    command_palette_fg_color = colors.foreground,
    command_palette_bg_color = colors.background,
    command_palette_font_size = 12,
    command_palette_rows = 25,

    window_padding = {
        left = 0,
        right = 0,
        top = 10,
        bottom = 7.5,
    },
    adjust_window_size_when_changing_font_size = false,
    window_close_confirmation = 'NeverPrompt',
    window_frame = {
        active_titlebar_bg = colors.background,
    },
    inactive_pane_hsb = {
        saturation = 1,
        brightness = 1,
    },

    visual_bell = {
        fade_in_function = 'EaseIn',
        fade_in_duration_ms = 250,
        fade_out_function = 'EaseOut',
        fade_out_duration_ms = 250,
        target = 'CursorColor',
    },

    window_decorations = "INTEGRATED_BUTTONS|RESIZE"
}

if background_opts ~= nil then
    config.background = background_opts

    if platform.is_win then
        config.win32_system_backdrop = 'Acrylic'
    elseif platform.is_mac then
        config.macos_window_background_blur = 20
    elseif platform.is_linux then
        -- Linux: kde_window_background_blur only works on KDE Wayland
        -- For other compositors (Hyprland, Sway, etc.), configure blur externally:
        --   - Hyprland: use windowrulev2 with blur in hyprland.conf
        --   - Sway/X11: use picom with blur enabled
        --   - Other: compositor-specific blur settings
        config.kde_window_background_blur = true
    end
end

return config

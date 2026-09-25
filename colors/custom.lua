local theme = require('colors.theme')

local r = theme.roles

local colors = {
    foreground = r.text,
    background = r.bg0,

    cursor_bg = r.cyan,
    cursor_border = r.cyan,
    cursor_fg = r.bg0,

    selection_bg = r.selectionBg,
    selection_fg = r.selectionFg,

    indexed = {
        [16] = r.warning,
        [17] = r.info,
    },

    scrollbar_thumb = r.bg3,
    split = r.border,
    visual_bell = r.alert,
    compose_cursor = r.alert,

    quick_select_label_bg = { Color = r.hotpink },
    quick_select_label_fg = { Color = r.bg0 },
    quick_select_match_bg = { Color = r.cyan },
    quick_select_match_fg = { Color = r.bg0 },

    copy_mode_active_highlight_bg = { Color = r.crimson },
    copy_mode_active_highlight_fg = { Color = r.white },
    copy_mode_inactive_highlight_bg = { Color = r.bg3 },
    copy_mode_inactive_highlight_fg = { Color = r.text },

    tab_bar = {
        background = r.tabBarBg,
        active_tab = {
            bg_color = r.tabBgActive,
            fg_color = r.tabFgActive,
        },
        inactive_tab = {
            bg_color = r.bg1,
            fg_color = r.tabFgDefault,
        },
        inactive_tab_hover = {
            bg_color = r.tabBgHover,
            fg_color = r.tabFgHover,
        },
        new_tab = {
            bg_color = r.bg1,
            fg_color = r.tabFgDefault,
        },
        new_tab_hover = {
            bg_color = r.tabBgHover,
            fg_color = r.tabFgHover,
            italic = true,
        },
    },
}

for key, value in pairs(theme.wezterm) do
    colors[key] = value
end

return colors

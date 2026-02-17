-- Ghost in the Shell color palette
-- Separate from colorscheme to avoid WezTerm validation errors

local gits = {
    bg0 = '#0a0e14',
    bg1 = '#0d1117',
    bg2 = '#13171f',
    bg3 = '#1a2332',
    bg5 = '#2d3640',

    text = '#b3e5fc',
    textMuted = '#4a5f6d',
    textMuted2 = '#6b8e9e',

    cyan = '#26c6da',
    green = '#00ff9f',
    teal = '#00d4aa',
    red = '#ff0066',
    orange = '#ffa726',

    crimson = '#dc143c',
    hotpink = '#ff1493',
    magenta = '#ff00ff',
    blood = '#8a0303',
    rose = '#ff69b4',

    black = '#0a0e14',
    white = '#b3e5fc',
    crust = '#070a0d',

    tabBgDefault = '#2d3640',
    tabBgHover = '#4a5f6d',
    tabBgActive = '#ff0066',
    tabFgDefault = '#b3e5fc',
    tabFgHover = '#ff69b4',
    tabFgActive = '#0a0e14',

    statusDate = '#26c6da',
    statusBattery = '#dc143c',
    statusSeparator = '#ff1493',

    iconTerminal = '#00d4aa',
    iconWsl = '#dc143c',
    iconSsh = '#ff1493',
    iconUnix = '#00d4aa',

    keyIndicatorBg = '#dc143c',
    keyIndicatorFg = '#ffffff',

    -- Program icon colors
    iconLang = '#00ff9f',        -- Green for languages
    iconTool = '#26c6da',         -- Cyan for tools
    iconDevOps = '#ffa726',       -- Orange for DevOps
    iconEditor = '#ff69b4',       -- Pink for editors
    iconSystem = '#8ecae6',       -- Light blue for system tools
    iconDefault = '#4a5f6d',     -- Gray for unknown programs,

    alert = '#dc143c',
    warning = '#ff1493',
    success = '#00ff9f',
    info = '#26c6da',

    -- selectionBg = '#1a2332',
    selectionBg = 'rgba(220, 20, 60, 0.7)',
    selectionFg = '#1a2332',

    border = '#1a2332',
    borderActive = '#ff1493',
}

return gits

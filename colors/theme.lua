local wezterm = require('wezterm')
local Features = require('config.features')
local REGISTERED = require('themes.registry')

local DEFAULT_ID = Features.CUSTOM_DEFAULTS.theme

local REQUIRED_ROLES = {
    'alert',
    'bg0',
    'bg1',
    'bg3',
    'border',
    'crimson',
    'cyan',
    'green',
    'hotpink',
    'iconDefault',
    'iconDevOps',
    'iconEditor',
    'iconLang',
    'iconSsh',
    'iconSystem',
    'iconTerminal',
    'iconTool',
    'iconUnix',
    'iconWsl',
    'info',
    'keyIndicatorBg',
    'keyIndicatorFg',
    'orange',
    'red',
    'selectionBg',
    'selectionFg',
    'statusBattery',
    'statusDate',
    'statusSeparator',
    'success',
    'tabBarBg',
    'tabBgActive',
    'tabBgDefault',
    'tabBgHover',
    'tabFgActive',
    'tabFgDefault',
    'tabFgHover',
    'teal',
    'text',
    'warning',
    'white',
}

local REQUIRED_WEZTERM_LISTS = { 'ansi', 'brights' }

local function validate(theme)
    if type(theme) ~= 'table' then
        return 'theme file must return a table'
    end
    if type(theme.label) ~= 'string' then
        return 'label must be a string'
    end
    if type(theme.roles) ~= 'table' then
        return 'roles must be a table'
    end

    local invalid_roles = {}
    for _, role in ipairs(REQUIRED_ROLES) do
        if type(theme.roles[role]) ~= 'string' then
            table.insert(invalid_roles, role)
        end
    end
    if #invalid_roles > 0 then
        return 'roles missing or not a string: ' .. table.concat(invalid_roles, ', ')
    end

    theme.wezterm = theme.wezterm or {}
    for _, key in ipairs(REQUIRED_WEZTERM_LISTS) do
        local list = theme.wezterm[key]
        if type(list) ~= 'table' or #list ~= 8 then
            return 'wezterm.' .. key .. ' must be a list of 8 colors'
        end
    end

    theme.config = theme.config or {}
    return nil
end

local function load_themes()
    local themes = {}
    for _, id in ipairs(REGISTERED) do
        local ok, theme = pcall(require, 'themes.' .. id)
        if not ok then
            wezterm.log_error('theme ' .. id .. ' failed to load: ' .. tostring(theme))
        else
            local err = validate(theme)
            if err then
                wezterm.log_error('theme ' .. id .. ' is invalid: ' .. err)
            else
                theme.id = id
                themes[id] = theme
            end
        end
    end
    return themes
end

local THEMES = load_themes()

local M = {}

function M.resolve(id)
    if type(id) ~= 'string' then
        return nil, 'theme id must be a string, got ' .. type(id)
    end
    local theme = THEMES[id]
    if not theme then
        return nil, 'unknown theme: ' .. id
    end
    return theme, nil
end

function M.list()
    local themes = {}
    for _, id in ipairs(REGISTERED) do
        if THEMES[id] then
            table.insert(themes, THEMES[id])
        end
    end
    return themes
end

function M.choices()
    local choices = {}
    for _, theme in ipairs(M.list()) do
        local marker = theme.id == M.name and '✓ ' or '  '
        table.insert(choices, { id = theme.id, label = marker .. theme.label })
    end
    return choices
end

function M.select(id)
    local theme, err = M.resolve(id)
    if not theme then
        return false, err
    end
    if theme.id == Features.get_custom_settings().theme then
        return true
    end
    return Features.set_custom_setting('theme', theme.id)
end

function M.cycle(delta)
    local themes = M.list()
    local index = 1
    for i, theme in ipairs(themes) do
        if theme.id == M.name then
            index = i
        end
    end
    return M.select(themes[((index - 1 + delta) % #themes) + 1].id)
end

local function active_theme()
    local theme = M.resolve(Features.get_custom_settings().theme)
    if theme then
        return theme
    end

    local fallback = THEMES[DEFAULT_ID]
    if not fallback then
        error('no usable theme: ' .. DEFAULT_ID .. ' is missing from themes/registry.lua')
    end

    wezterm.log_warn('theme fallback: ' .. DEFAULT_ID .. ' in use')
    return fallback
end

local ACTIVE = active_theme()

M.name = ACTIVE.id
M.label = ACTIVE.label
M.roles = ACTIVE.roles
M.wezterm = ACTIVE.wezterm
M.config = ACTIVE.config

return M

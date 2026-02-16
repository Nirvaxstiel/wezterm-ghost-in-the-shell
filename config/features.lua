-- Central Feature Registry
-- Single source of truth for all toggleable features

local wezterm = require('wezterm')

---@class Feature
---@field name string
---@field description string
---@field enabled boolean
---@field dependencies string[]
---@field setup function|nil

---@class FeatureRegistry
---@field registry table<string, Feature>
local Features = {
    registry = {},
}

---Register a feature in the registry
---@param name string Feature identifier
---@param feature Feature Feature definition
function Features.register(name, feature)
    feature.name = name
    feature.enabled = feature.enabled ~= false  -- Default true
    feature.dependencies = feature.dependencies or {}
    Features.registry[name] = feature
end

---Get feature from registry
---@param name string Feature identifier
---@return Feature|nil
function Features.get(name)
    return Features.registry[name]
end

---Set feature enabled state
---@param name string Feature identifier
---@param enabled boolean Enabled state
---@return boolean success
function Features.set_enabled(name, enabled)
    local feature = Features.registry[name]
    if not feature then
        wezterm.log_warn('Feature not found: ' .. name)
        return false
    end
    feature.enabled = enabled
    return true
end

---Check if feature is enabled
---@param name string Feature identifier
---@return boolean
function Features.is_enabled(name)
    local feature = Features.registry[name]
    if not feature then
        wezterm.log_warn('Feature not found: ' .. name)
        return false
    end

    -- Check dependencies
    for _, dep in ipairs(feature.dependencies) do
        if not Features.is_enabled(dep) then
            wezterm.log_warn('Feature ' .. name .. ' disabled: dependency ' .. dep .. ' not enabled')
            return false
        end
    end

    return feature.enabled
end

---Get all features
---@return table<string, Feature>
function Features.get_all()
    return Features.registry
end

---List all features with their enabled state
---@return table
function Features.list()
    local list = {}
    for name, feature in pairs(Features.registry) do
        table.insert(list, {
            name = name,
            description = feature.description,
            enabled = feature.enabled,
            dependencies = feature.dependencies,
        })
    end
    return list
end

-- ============================================
-- REGISTER ALL FEATURES
-- ============================================

-- UI Components
Features.register('left-status', {
    description = 'Left status bar (key table indicator)',
    enabled = true,
})

Features.register('right-status', {
    description = 'Right status bar (workspace, cwd, battery, date)',
    enabled = true,
})

Features.register('workspace-display', {
    description = 'Show workspace name in right status',
    enabled = true,
    dependencies = { 'right-status' },
})

Features.register('cwd-display', {
    description = 'Show current directory in right status',
    enabled = true,
    dependencies = { 'right-status' },
})

Features.register('battery-display', {
    description = 'Show battery status in right status',
    enabled = true,
    dependencies = { 'right-status' },
})

Features.register('date-display', {
    description = 'Show date/time in right status',
    enabled = true,
    dependencies = { 'right-status' },
})

Features.register('tab-bar', {
    description = 'Tab bar at top',
    enabled = true,
})

Features.register('new-tab-button', {
    description = 'New tab button on right of tab bar',
    enabled = true,
})

Features.register('gui-startup', {
    description = 'Maximize window on startup',
    enabled = true,
})

-- Visual Effects
Features.register('backdrops', {
    description = 'Background images with blur effects',
    enabled = true,
})

Features.register('background-blur', {
    description = 'Background blur effects (platform-specific)',
    enabled = true,
    dependencies = { 'backdrops' },
})

Features.register('animations', {
    description = 'UI animations (cursor blink, etc.)',
    enabled = true,
})

Features.register('cursor-blink', {
    description = 'Cursor blinking',
    enabled = true,
    dependencies = { 'animations' },
})

Features.register('visual-bell', {
    description = 'Visual bell effect',
    enabled = true,
})

Features.register('scroll-bar', {
    description = 'Scroll bar on right',
    enabled = true,
})

-- Functionality
Features.register('scrollback', {
    description = 'Scrollback buffer (default: 20000 lines)',
    enabled = true,
})

Features.register('hyperlinks', {
    description = 'Clickable hyperlinks in terminal',
    enabled = true,
})

Features.register('command-palette', {
    description = 'Command palette (F2)',
    enabled = true,
})

Features.register('auto-reload', {
    description = 'Auto-reload config on file change',
    enabled = true,
})

Features.register('exit-confirmation', {
    description = 'Window close confirmation',
    enabled = true,
})

-- Tab Features
Features.register('tab-index', {
    description = 'Show tab index numbers',
    enabled = false,
})

Features.register('tab-title', {
    description = 'Custom tab titles with process icons',
    enabled = true,
})

Features.register('last-active-tab', {
    description = 'Switch to last active tab when closing tab',
    enabled = true,
})

return Features

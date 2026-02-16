# Feature Toggle System - Implementation Summary

## Overview

Your WezTerm config now has a **centralized feature toggle system** that allows you to:
- **Config-based**: Toggle features permanently by editing `config/user.lua`
- **Runtime**: Toggle features instantly with keybindings (existing system)

## What Was Refactored

### ✅ Phase 1: Foundation (Complete)
- ✅ Created `config/features.lua` - Central feature registry
- ✅ Created `config/user.lua.example` - Example user config
- ✅ Created `config/user.lua` - Your custom config (gitignored)
- ✅ Updated `wezterm.lua` - Loads user config and applies feature settings

### ✅ Phase 2: Core Config Refactored (Complete)
- ✅ `config/general.lua` - Scrollback, hyperlinks, auto-reload, exit-confirmation
- ✅ `config/appearance.lua` - Animations, cursor-blink, visual-bell, scroll-bar, backdrops, tab-bar

### ✅ Phase 3: Events Refactored (Complete)
- ✅ `events/gui-startup.lua` - Window maximization on startup
- ✅ `events/left-status.lua` - Key table indicator
- ✅ `events/right-status.lua` - Workspace, CWD, battery, date displays
- ✅ `events/tab-title.lua` - Custom tab titles with process icons
- ✅ `events/new-tab-button.lua` - New tab button with launch menu

## Available Features

### UI Components
- `left-status` - Left status bar (key table indicator)
- `right-status` - Right status bar (workspace, cwd, battery, date)
- `workspace-display` - Show workspace name in right status
- `cwd-display` - Show current directory in right status
- `battery-display` - Show battery status in right status
- `date-display` - Show date/time in right status
- `tab-bar` - Tab bar at top
- `new-tab-button` - New tab button on right of tab bar
- `gui-startup` - Maximize window on startup

### Visual Effects
- `backdrops` - Background images with blur effects
- `background-blur` - Background blur effects (platform-specific)
- `animations` - UI animations (cursor blink, etc.)
- `cursor-blink` - Cursor blinking
- `visual-bell` - Visual bell effect
- `scroll-bar` - Scroll bar on right

### Functionality
- `scrollback` - Scrollback buffer (default: 20000 lines)
- `hyperlinks` - Clickable hyperlinks in terminal
- `command-palette` - Command palette (F2)
- `auto-reload` - Auto-reload config on file change
- `exit-confirmation` - Window close confirmation

### Tab Features
- `tab-index` - Show tab index numbers
- `tab-title` - Custom tab titles with process icons
- `last-active-tab` - Switch to last active tab when closing tab

## How to Use

### Config-Based Toggles (Permanent)

Edit `config/user.lua`:

```lua
return {
    features = {
        -- Turn off workspace display
        ['workspace-display'] = false,

        -- Turn off battery display
        ['battery-display'] = false,

        -- Turn off animations
        ['animations'] = false,
    },

    custom = {
        -- Custom values
        scrollback_lines = 50000,
        date_format = '%Y-%m-%d %H:%M',
    },

    apply = function(self)
        for name, enabled in pairs(self.features) do
            Features.set_enabled(name, enabled)
        end
    end,
}
```

Then **reload WezTerm** (or it auto-reloads if `auto-reload` is enabled).

### Runtime Toggles (Instant)

You already have some runtime toggles:
- `Super+b` - Toggle background focus mode
- `Super+n` - Enable transparent mode
- `Super+9` - Toggle tab bar
- `Super+/` - Select random background
- `Super+,` - Cycle background back
- `Super+.` - Cycle background forward

These work instantly without reloading config.

## Feature Dependencies

Some features depend on others:
- `workspace-display` depends on `right-status`
- `cwd-display` depends on `right-status`
- `battery-display` depends on `right-status`
- `date-display` depends on `right-status`
- `background-blur` depends on `backdrops`
- `cursor-blink` depends on `animations`

If you disable a parent feature, all its children will also be disabled.

## Next Steps

### Phase 4: Bindings & Command Palette (Optional)

Refactor `config/bindings.lua` and `config/command-palette.lua` to:
- Filter keybindings based on enabled features
- Filter command palette items based on enabled features

Example: If `backdrops` is disabled, remove backdrop keybindings from `keys` table.

### Phase 5: Runtime Toggle System (Optional)

Add keybindings to toggle any feature at runtime:
- `LEADER + f` - Toggle feature selector
- Add to command palette: "Toggle Feature" action

## Testing

1. Test that config still works with all features enabled (default)
2. Test that turning off individual features works
3. Test that dependencies are respected (e.g., disable `right-status` → `workspace-display` also off)
4. Test that user config is properly gitignored

## Troubleshooting

**Config doesn't load:**
- Check that `config/user.lua` exists
- Check for syntax errors in `config/user.lua`
- Check WezTerm logs: `F12` to open debug overlay

**Feature doesn't disable:**
- Check that feature name is correct in `config/user.lua`
- Check that dependencies are met
- Check WezTerm logs for warnings

**Changes don't apply:**
- Reload WezTerm or wait for auto-reload
- Check `auto-reload` feature is enabled

## File Structure

```
config/
├── features.lua           ← Central registry (new)
├── user.lua              ← Your config (gitignored, new)
├── user.lua.example      ← Example config (new)
├── general.lua           ← Refactored (feature-aware)
├── appearance.lua        ← Refactored (feature-aware)
├── bindings.lua          ← TODO: refactor
├── command-palette.lua   ← TODO: refactor
├── init.lua             ← No changes needed
├── domains.lua          ← No changes needed
├── fonts.lua            ← No changes needed
├── launch.lua           ← No changes needed

events/
├── left-status.lua      ← Refactored (feature-aware)
├── right-status.lua     ← Refactored (feature-aware)
├── tab-title.lua       ← Refactored (feature-aware)
├── new-tab-button.lua  ← Refactored (feature-aware)
└── gui-startup.lua     ← Refactored (feature-aware)
```

## Summary

✅ **Done**: Central feature registry with all core features
✅ **Done**: Config-based toggles via `config/user.lua`
✅ **Done**: Runtime toggles (existing system)
✅ **Done**: Refactored all core config files
✅ **Done**: Refactored all event files

🔄 **Optional**: Refactor bindings and command palette
🔄 **Optional**: Add runtime feature toggle keybindings

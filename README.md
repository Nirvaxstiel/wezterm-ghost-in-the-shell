<h2 align="center">My WezTerm Config</h2>

<p align="center">
  <img alt="Theme" src="https://img.shields.io/badge/Theme-Ghost_in_the_Shell-ff1493?style=for-the-badge&logo=terminal">
</p>

---

### Screenshots

<p align="center">
  <img alt="demo" src="./.github/screenshots/image.gif">
  <img alt="demo" src="./.github/screenshots/screenshot.png">
</p>

---

### Theme: Ghost in the Shell

Custom color palette inspired by **Ghost in the Shell** and **Blade Runner**:

| Color | Hex | Usage |
|-------|-----|-------|
| Background | `#0a0e14` | Main terminal bg |
| Text | `#b3e5fc` | Primary text (cyan-tinted) |
| Cyan | `#26c6da` | Holographic UI |
| Green | `#00ff9f` | Matrix/success |
| Crimson | `#dc143c` | Active tabs, alerts |
| Hotpink | `#ff1493` | Warnings, highlights |
| Teal | `#00d4aa` | Icons |

See: [colors/custom.lua](./colors/custom.lua)

---

### What's Different from Original

- **Theme**: Ghost in the Shell instead of Catppuccin
- **Transparency**: Platform-aware backdrop blur/transparency
- **Colors**: Crimson/hotpink accents throughout
- **Background Modes**: Three modes - Images, Transparent, Focus
- **Command Palette**: F2 (was F2 in original too, but now with custom actions)

---

### Background Modes

This config supports three background modes that can be toggled at runtime:

| Mode | Description | Hotkey |
|------|-------------|--------|
| **Images** | Background images from `backdrops/` folder | `Super+,` / `Super+.` / `Super+/` |
| **Transparent** | Semi-transparent solid color (no images) | `Super+n` |
| **Focus** | Solid color, no image (max readability) | `Super+b` |

**Platform-specific blur:**
- Windows: Acrylic effect
- macOS: Background blur
- Linux (KDE Wayland): `kde_window_background_blur`
- Linux (other compositors): Configure blur in compositor (Hyprland, picom, etc.)

---

### Command Palette (F2)

Custom actions available via command palette:

| Action | Description |
|--------|-------------|
| Select Random Background | Pick random image |
| Cycle to Next Background | Next image |
| Cycle to Previous Background | Previous image |
| Toggle Background Focus Mode | Toggle focus mode |
| Use Transparent Mode (Disable Images) | Enable transparent mode |
| Fuzzy Select Background | Search and select image |

---

### Quick Fix: Nushell on Windows

If using Nushell on Windows, add to your Nushell config to prevent scrolling:
```nu
$env.config.shell_integration.osc133 = false
```

---

### Troubleshooting: Git Bash on Windows

If Git Bash fails to launch with exit code 1, check the path in `config/launch.lua`. Common Git Bash installation paths:

- `C:\Program Files\Git\bin\bash.exe`
- `C:\Program Files\Git\usr\bin\bash.exe`
- `C:\Program Files\Git\cmd\bash.exe` (if in PATH)

If using Scoop's Git, you may need to wrap it with cmd.exe:
```lua
args = {
    'cmd.exe', '/c',
    'set MSYS=pathtype=unix&& C:\\Users\\kevin\\scoop\\apps\\git\\current\\bin\\bash.exe -l'
},
```

---

### Key Bindings & Full Docs

Most key bindings are unchanged from the original.

**Full documentation:** [README.original.md](./README.original.md)

**Original repo:** [KevinSilvester/wezterm-config](https://github.com/KevinSilvester/wezterm-config)

---

### Credits

- Original: [KevinSilvester/wezterm-config](https://github.com/KevinSilvester/wezterm-config)
- Theme: Ghost in the Shell / Blade Runner (Wallace Corporation)

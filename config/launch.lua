local platform = require('utils.platform')
local wezterm = require("wezterm")

local function file_exists(path)
    local f = io.open(path, "r")
    if f then
        f:close()
        return true
    end
    return false
end


local home = wezterm.home_dir

local candidates = {
    "C:/Program Files/Git/bin/bash.exe",
    "C:/Program Files/Git/usr/bin/bash.exe",
    "C:/Program Files (x86)/Git/bin/bash.exe",
    home .. "/scoop/apps/git/current/bin/bash.exe",
}


local options = {
    default_prog = {},
    launch_menu = {},
}

if platform.is_win then
    options.default_prog = { 'nu' }
    options.launch_menu = {
        { label = 'PowerShell Core',    args = { 'pwsh', '-NoLogo' } },
        { label = 'PowerShell Desktop', args = { 'powershell' } },
        { label = 'Command Prompt',     args = { 'cmd' } },
        { label = 'Nushell',            args = { 'nu' } },
        { label = 'Msys2',              args = { 'ucrt64.cmd' } },
        { label = 'Git Bash',           args = { 'bash' }, },
    }
elseif platform.is_mac then
    options.default_prog = { '/opt/homebrew/bin/fish', '-l' }
    options.launch_menu = {
        { label = 'Bash',    args = { 'bash', '-l' } },
        { label = 'Fish',    args = { '/opt/homebrew/bin/fish', '-l' } },
        { label = 'Nushell', args = { '/opt/homebrew/bin/nu', '-l' } },
        { label = 'Zsh',     args = { 'zsh', '-l' } },
    }
elseif platform.is_linux then
    options.default_prog = { 'fish', '-l' }
    options.launch_menu = {
        { label = 'Bash', args = { 'bash', '-l' } },
        { label = 'Fish', args = { 'fish', '-l' } },
        { label = 'Zsh',  args = { 'zsh', '-l' } },
    }
end

return options

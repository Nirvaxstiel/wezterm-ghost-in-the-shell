local platform = require('utils.platform')

local options = {
    -- These three are the only domain types configured here. See
    -- https://wezterm.org/multiplexing.html
    ssh_domains = {},
    unix_domains = {},
    wsl_domains = {},
}

if platform.is_win then
    options.ssh_domains = {
        {
            name = 'ssh:wsl',
            remote_address = 'localhost',
            multiplexing = 'None',
            default_prog = { 'fish', '-l' },
            assume_shell = 'Posix',
        },
    }

    options.wsl_domains = {
        {
            name = 'wsl:ubuntu-fish',
            distribution = 'Ubuntu',
            default_prog = { 'fish', '-l' },
        },
        {
            name = 'wsl:ubuntu-bash',
            distribution = 'Ubuntu',
            default_prog = { 'bash', '-l' },
        },
    }
end

return options

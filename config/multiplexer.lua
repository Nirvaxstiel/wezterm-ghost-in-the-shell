local platform = require('utils.platform')

local mux = {}

if platform.is_win then
   -- WezTerm's mux agent publishes a Unix domain socket and points SSH_AUTH_SOCK
   -- at it. Windows OpenSSH uses named pipes, so forwarding breaks native ssh.
   mux.mux_enable_ssh_agent = false
end

return mux

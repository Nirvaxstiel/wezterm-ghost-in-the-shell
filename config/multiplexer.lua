local platform = require('utils.platform')

local mux = {}

if platform.is_win then
   -- Windows OpenSSH uses named pipes, not Unix sockets.
   -- WezTerm's mux agent creates a Unix domain socket and sets
   -- SSH_AUTH_SOCK to it, which breaks native Windows ssh.
   mux.mux_enable_ssh_agent = false
end

return mux

local platform = require('utils.platform')

local sockets = {}

if platform.is_win then
   -- SSH agent socket (Windows named pipe)
   -- Only needed if mux_enable_ssh_agent is true and you want to
   -- override the default. With mux_enable_ssh_agent = false,
   -- WezTerm leaves SSH_AUTH_SOCK alone and Windows OpenSSH
   -- talks to the named pipe directly.
   --
   -- sockets.default_ssh_auth_sock = '\\\\.\\pipe\\openssh-ssh-agent'

   --[[
   -- Future: Docker / Podman named pipe forwarding
   -- sockets.set_environment_variables = {
   --    DOCKER_HOST = 'npipe:////./pipe/docker_engine',
   -- }
   --]]
end

return sockets

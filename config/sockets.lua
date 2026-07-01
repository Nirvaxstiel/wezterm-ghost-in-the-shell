local sockets = {}

-- Windows: SSH agent uses named pipes, not Unix sockets.
-- With mux_enable_ssh_agent = false (set in config/multiplexer.lua),
-- WezTerm leaves SSH_AUTH_SOCK alone and Windows OpenSSH talks to
-- the named pipe directly. No socket config needed here.
--
-- Future: Docker / Podman named pipe forwarding
-- if platform.is_win then
--   sockets.set_environment_variables = {
--      DOCKER_HOST = 'npipe:////./pipe/docker_engine',
--   }
-- end

return sockets
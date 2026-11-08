local wezterm = require('wezterm')

local M = {}

---Path aliases - replace specific paths with custom text
---@type table<string, string>
local PATH_ALIASES = {
    -- ['~/.config'] = '⚙️ config',
    -- ['~/projects'] = '📁 projects',
}

---A directory is a repository root when it holds a `.git` directory or, for
---worktrees and submodules, a `.git` file that points at the real one.
---@param directory string
---@return boolean
local function is_git_root(directory)
    for _, marker in ipairs({ directory .. '/.git/HEAD', directory .. '/.git' }) do
        local handle = io.open(marker, 'r')
        if handle then
            handle:close()
            return true
        end
    end
    return false
end

---Find the name of the git repository root that contains `directory`.
---@param directory string
---@return string|nil
local function find_git_dir(directory)
    directory = directory:gsub('~', wezterm.home_dir)

    while directory do
        if is_git_root(directory) then
            return directory:match('([^/]+)$')
        elseif directory == '/' or directory == '' then
            break
        else
            directory = directory:match('(.+)/[^/]*')
        end
    end

    return nil
end

---Apply configured path aliases to a path string
---@param path string
---@return string
local function apply_path_aliases(path)
    for pattern, replacement in pairs(PATH_ALIASES) do
        path = path:gsub(pattern, replacement)
    end
    return path
end

---Shorten CWD path intelligently
---@param cwd string
---@param opts? { use_git_root?: boolean, show_full_path?: boolean }
---@return string
function M.get_cwd(cwd, opts)
    opts = opts or {}

    if not cwd or cwd == '' then
        return ''
    end

    local path = cwd:gsub('\\', '/')

    path = path:gsub('^' .. wezterm.home_dir:gsub('\\', '/'), '~')

    path = apply_path_aliases(path)

    if opts.use_git_root and path:match('^~/') then
        local git_root = find_git_dir(path)
        if git_root then
            return git_root
        end
    end

    if opts.show_full_path then
        return path
    end

    if path:match('^~/') then
        local filename = path:match('[^/]+$')
        local dirname = path:match('^~/(.*)/[^/]+$')

        if dirname and filename then
            local parts = {}
            for part in dirname:gmatch('[^/]+') do
                table.insert(parts, part)
            end

            if #parts > 2 then
                return '~/' .. parts[#parts - 1] .. '/' .. filename
            elseif #parts > 0 then
                return '~/' .. dirname .. '/' .. filename
            else
                return '~/' .. filename
            end
        end
        return '~/' .. (filename or path)
    else
        local parts = {}
        for part in path:gmatch('[^/]+') do
            table.insert(parts, part)
        end

        if #parts > 2 then
            return parts[#parts - 1] .. '/' .. parts[#parts]
        elseif #parts > 1 then
            return parts[#parts - 1] .. '/' .. parts[#parts]
        else
            return parts[1] or path
        end
    end
end

---Add a path alias
---@param pattern string
---@param replacement string
function M.add_alias(pattern, replacement)
    PATH_ALIASES[pattern] = replacement
end

---Remove a path alias
---@param pattern string
function M.remove_alias(pattern)
    PATH_ALIASES[pattern] = nil
end

return M

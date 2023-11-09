-- nvim/init.lua
-- Entry point for Neovim configuration through Lua.

-- Path to plugins managed by lazy.vim.
local nvim_plugins_path = vim.fn.stdpath("data") .. "/lazy"

local function install_plugin(name, alias)
  local _, _, owner, repo = name:find([[(.+)/(.+)]])
  local path = ("%s/%s"):format(nvim_plugins_path, alias or repo)

  if not vim.loop.fs_stat(path) then
    vim.notify(("Installing %s/%s..."):format(owner, repo), vim.log.levels.INFO)

    local command = {
      "git",
      "clone",
      "--filter=blob:none",
      "--single-branch",
      ("https://github.com/%s/%s.git"):format(owner, repo),
      path,
    }

    vim.fn.system(command)
  end

  vim.opt.runtimepath:prepend(path)
end

-- Bootstrap required plugins.
install_plugin("folke/lazy.nvim") -- plugin manager
install_plugin("rktjmp/hotpot.nvim") -- Fennel for neovim

-- Configure hotpot.nvim.
require("hotpot").setup({
  -- Resolve `(require :fennel)` to the fennel.lua provided by hotpot.nvim.
  provide_require_fennel = true,
})

-- Path added to Lua package load path by hotpot.nvim for resolving
-- `(require :module_name)` for Fennel modules.
local nvim_fennel_library_path = vim.fn.stdpath("config") .. "/fnl"

-- Generate plugins table for lazy.nvim.
local config_plugins_path = nvim_fennel_library_path .. "/config/plugins"
local plugins = {
  -- Hardcode hotpot.nvim plugin.
  { "rktjmp/hotpot.nvim" },
}
if vim.loop.fs_stat(config_plugins_path) then
  -- Load each plugin configuration as a Fennel module.
  -- Each module should return an array of spec tables, where the spec table
  -- is defined by the lazy.vim Plugin Spec:
  --   https://github.com/folke/lazy.nvim#-plugin-spec
  for file in vim.fs.dir(config_plugins_path) do
    file = file:match("^(.*)%.fnl$")
    table.insert(plugins, require("config.plugins." .. file))
  end
end

-- Load configuration.
require("config")

-- Configure lazy.nvim.
require("lazy").setup(plugins, { install = { missing = true }})

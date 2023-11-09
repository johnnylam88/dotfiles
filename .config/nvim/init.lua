-- nvim/init.lua
-- Entry point for Neovim configuration through Lua.

-- Path to plugins managed by lazy.vim.
local nvim_plugins_path = vim.fn.stdpath("data") .. "/lazy"

-- Bootstrap lazy.nvim plugin manager.
local lazy_path = nvim_plugins_path .. "/lazy.nvim"
if not vim.loop.fs_stat(lazy_path) then
  vim.notify("Bootstrapping lazy.nvim...", vim.log.levels.INFO)
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazy_path,
  })
end

-- Bootstrap hotpot.nvim to allow using Fennel on top of Lua.
local hotpot_path = nvim_plugins_path .. "/hotpot.nvim"
if not vim.loop.fs_stat(hotpot_path) then
  vim.notify("Bootstrapping hotpot.nvim...", vim.log.levels.INFO)
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--single-branch",
    "https://github.com/rktjmp/hotpot.nvim.git",
    hotpot_path,
  })
end

-- Add lazy.nvim and hotpot.nvim paths to runtimepath.
vim.opt.runtimepath:prepend({
  hotpot_path,
  lazy_path
})

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
  -- Load each plugin-specific lazy.nvim configuration as a Fennel module.
  -- Each module should return a table according to the lazy.vim Plugin Spec:
  --   https://github.com/folke/lazy.nvim#-plugin-spec
  for file in vim.fs.dir(config_plugins_path) do
    file = file:match("^(.*)%.fnl$")
    plugins[#plugins + 1] = require("config.plugins." .. file)
  end
end

-- Configure lazy.nvim.
require("lazy").setup(
  plugins,
  {
    install = { missing = true }, -- install missing plugins
  }
)

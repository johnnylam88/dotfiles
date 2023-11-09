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

-- Load hotpot.nvim.
require("hotpot").setup({
  -- Resolve `(require :fennel)` to the fennel.lua provided by hotpot.nvim.
  provide_require_fennel = true,
})

-- Plugin specs table for lazy.nvim.
local plugins = {
  -- Hardcode hotpot.nvim plugin.
  { "rktjmp/hotpot.nvim" },
}

-- Load configuration.
require("config").setup(plugins)

-- Load lazy.nvim.
require("lazy").setup(plugins, { install = { missing = true }})

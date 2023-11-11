-- nvim/init.lua
-- Entry point for Neovim configuration through Lua.

-- Path to plugins managed by lazy.vim.
local nvim_plugins_path = vim.fn.stdpath("data") .. "/lazy"

local function require_plugin(name, alias)
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
require_plugin("folke/lazy.nvim") -- plugin manager
require_plugin("rktjmp/hotpot.nvim") -- Fennel for neovim

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

local specs_path = vim.fn.stdpath("config") .. "/fnl/packages"
if vim.loop.fs_stat(specs_path) then
  -- Each Fennel file within the `packages` directory should return an array
  -- whose values follow the lazy.vim Plugin Spec:
  --   https://github.com/folke/lazy.nvim#-plugin-spec
  for file in vim.fs.dir(specs_path) do
    file = file:match("^(.*)%.fnl$")
    table.insert(plugins, require("packages." .. file))
  end
end

-- Load configuration.
require("config")

-- Load lazy.nvim.
require("lazy").setup(plugins, { install = { missing = true }})

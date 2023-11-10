(fn config []
  (let [treesitter-configs (require :nvim-treesitter.configs)]
    (treesitter-configs.setup
     {:ensure_installed [:bash
                         :clojure
                         :diff
                         :fennel
                         :gitcommit
                         :lua
                         :vim
                         :vimdoc]
      :highlight {:enable true}
      :indent {:enable true}})))

[{1 "nvim-treesitter/nvim-treesitter"
  :build ":TSUpdate"
  : config}]

(fn config []
  (let [lualine (require :lualine)]
    (lualine.setup
      {:options {:icons_enabled true
                 :theme :auto
                 :component_separators "|"
                 :section_separators ""}
       :sections {:lualine_x [(. (require :action-hints) :statusline)]}})))

(fn action-hints-config []
  (let [a-h (require :action-hints)]
    (a-h.setup {:use_virtual_text true})))

[{1 "nvim-lualine/lualine.nvim"
  : config
  :dependencies [{1 "roobert/action-hints.nvim"
                  :config action-hints-config}]}]

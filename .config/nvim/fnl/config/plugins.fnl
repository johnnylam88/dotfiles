(fn load-specs [?plugins]
  (let [plugins (or ?plugins {})
        path (.. (vim.fn.stdpath "config") "/fnl/config/specs")]
    (when (vim.loop.fs_stat path)
      ;; Each Fennel file within the `specs` directory should return an array
      ;; whose values follow the lazy.vim Plugin Spec:
      ;;   https://github.com/folke/lazy.nvim#-plugin-spec
      (each [file (vim.fs.dir path)]
        (let [basename (string.match file "^(.*)%.fnl$")]
          (table.insert plugins (require (.. :config.specs. basename))))))
    plugins))

(fn init [])

{: init
 :load load-specs}

(let [plugins (require :config.plugins)
      options (require :config.options)
      tui (require :config.tui)]
  (plugins.init)
  (options.init)
  (tui.init)

  (fn setup [plugins?]
    (plugins.load plugins?))

  {: setup})

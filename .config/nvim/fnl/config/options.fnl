(fn init []
  ;; Set <TAB> to be 2 spaces.
  (let [indent 2]
    (set vim.opt.tabstop indent)
    (set vim.opt.shiftwidth indent)
    (set vim.opt.softtabstop indent))

  ;; Expand tabs to spaces.
  (set vim.opt.expandtab true)

  ;; Don't "fix" existing files by adding a "missing" newline at the end of
  ;; the file if it's opened read/write.
  (set vim.opt.fixeol false)

  ;; Default update interval (4000ms) is too long for asynchronous updates.
  (set vim.opt.updatetime 100))

{: init}

;; Set <TAB> to be 2 spaces.
(set vim.opt.tabstop 2)
(set vim.opt.shiftwidth 2)
(set vim.opt.softtabstop 2)
(set vim.opt.expandtab true)

;; Don't "fix" existing files by adding a "missing" newline at the end of
;; the file if it's opened read/write.
(set vim.opt.fixeol false)

;; Default update interval (4000ms) is too long for asynchronous updates.
(set vim.opt.updatetime 100)

;; Terminal UI settings
(set vim.opt.termguicolors true) ; this should be $TERM-based
(vim.cmd "colorscheme selenized")
(set vim.opt.background :dark)

{}

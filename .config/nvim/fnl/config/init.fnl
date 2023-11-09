;; Set <TAB> to be 2 spaces.
(set vim.o.tabstop 2)

;; Don't "fix" existing files by adding a "missing" newline at the end of
;; the file if it's opened read/write.
(set vim.o.fixeol false)

;; Default update interval (4000ms) is too long for asynchronous updates.
(set vim.o.updatetime 100)

;; Terminal UI settings
(set vim.o.termguicolors true) ; this should be $TERM-based
(vim.cmd "colorscheme selenized")
(set vim.o.background :dark)

{}

;; Set the shell options for Bourne shell on Windows if the shell is from
;; Cygwin/MSYS2/Git for Windows.
(let [uname (vim.loop.os_uname)]
  (when (string.find uname.sysname :Windows)
    (let [shell (os.getenv :SHELL)]
      (when (string.find shell "sh%.exe$")
        (set vim.opt.shell "sh")
        (set vim.opt.shellcmdflag "-c")
        (set vim.opt.shellquote "")
        (set vim.opt.shellxquote "")))))

" Set <TAB> to be 4 spaces.
set tabstop=4

" Default updatetime (4000ms) is too slow for asynchronous updates.
set updatetime=100

" Don't 'fix' existing files by adding a newline at the end of the
" file if it is missing.
set nofixendofline

" True-color configuration
if (has("termguicolors"))
	" Explicitly set the t_8f and t_8b options in case we are using
	" a true-color terminal but $TERM is not "xterm".
	let &t_8f = "[38;2;%lu;%lu;%lum"
	let &t_8b = "[48;2;%lu;%lu;%lum"
	set termguicolors

	" Load selenized color scheme.
	colorscheme selenized
	set background=dark
endif

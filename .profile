# $HOME/.profile
#
# POSIX sh(1) reads this file by default if invoked as a login shell

if [ -f "${HOME}/.config/shell/profile" ]; then
	. "${HOME}/.config/shell/profile"
fi

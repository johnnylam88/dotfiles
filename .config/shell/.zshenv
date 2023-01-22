# ${ZDOTDIR}/.zshenv
#
# zsh(1) reads this file for every shell invocation.

if [ -f "${HOME}/.config/shell/profile" ]; then
	. "${HOME}/.config/shell/profile"
fi

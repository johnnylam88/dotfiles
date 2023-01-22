# $HOME/.zshenv
#
# zsh(1) reads this file for every shell invocation.

# Use the zsh configuration files within ${ZDOTDIR}.
ZDOTDIR="${HOME}/.config/shell"
if [ -f "${ZDOTDIR}/.zshenv" ]; then
	. "${ZDOTDIR}/.zshenv"
fi

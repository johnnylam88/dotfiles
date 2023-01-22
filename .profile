# $HOME/.profile -- called for each invocation of a login shell

[ -n "${HOME_PROFILE_SOURCED}" ] && return

HOME_PROFILE_SOURCED=yes

# Ensure that ${HOME}/.config/shell/shenv is called for each
# shell invocation, regardless of login or interactive status.
#
if [ -f "${HOME}/.config/shell/shenv" ]; then
	export ENV="${HOME}/.config/shell/shenv"
	if [ -n "${BASH_VERSION}" ]; then
		# Bash uses ${BASH_ENV} instead of ${ENV}, except if
		# it's invoked with the --posix option.
		export BASH_ENV=${ENV}
		. "${BASH_ENV}"
	elif [ -n "${YASH_VERSION}" ]; then
		. "${ENV}"
	fi
fi

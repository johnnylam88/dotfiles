# $HOME/.profile -- called for each invocation of a login shell

case X${HOME_PROFILE_SOURCED} in
X)
	HOME_PROFILE_SOURCED=yes

	# Ensure that ${HOME}/.config/shell/shenv is called for each
	# shell invocation, regardless of login or interactive status.
	#
	if [ -f "${HOME}/.config/shell/shenv" ]; then
		if [ -n "${BASH_VERSION}" ]; then
			export BASH_ENV="${HOME}/.config/shell/shenv"
			. "${BASH_ENV}"
		else
			export ENV="${HOME}/.config/shell/shenv"
		fi
	fi
	;;
esac

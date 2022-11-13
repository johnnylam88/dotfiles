# $HOME/.profile -- called for each invocation of a login shell

case X${HOME_PROFILE_SOURCED} in
X)
	HOME_PROFILE_SOURCED=yes

	# Ensure that ${HOME}/.shinit is called for each shell invocation,
	# regardless of login or interactive status.
	#
	if [ -f "${HOME}/.shinit" ]; then
		if [ -n "${BASH_VERSION}" ]; then
			export BASH_ENV="${HOME}/.shinit"
			. "${BASH_ENV}"
		else
			export ENV="${HOME}/.shinit"
		fi
	fi
	;;
esac

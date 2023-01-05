# shellcheck shell=sh
# steamship/modules/host.sh

# --------------------------------------------------------------------------
# | STEAMSHIP_HOST_SHOW | show hostname on local | show hostname on remote |
# |---------------------+------------------------+-------------------------|
# | false               | never                  | never                   |
# | always              | always                 | always                  |
# | true                | never                  | always                  |
# --------------------------------------------------------------------------

case " ${STEAMSHIP_MODULES_SOURCED} " in *" host "*) return ;; esac

# Dependencies
: "${STEAMSHIP_ROOT:="${HOME}/.config/shell/steamship"}"
# shellcheck disable=SC1091
. "${STEAMSHIP_ROOT}/modules/colors.sh"

steamship_host_init() {
	STEAMSHIP_HOST_SHOW='true'
	STEAMSHIP_HOST_SHOW_FULL='false'
	STEAMSHIP_HOST_PREFIX='at '
	STEAMSHIP_HOST_SUFFIX=${STEAMSHIP_SUFFIX_DEFAULT}
	STEAMSHIP_HOST_COLOR='BLUE'
	STEAMSHIP_HOST_COLOR_SSH='GREEN'
	STEAMSHIP_HOST_SYMBOL_SSH=''

	# Set a default ${HOST} to the hostname of the system.
	: "${HOST:=$(command hostname 2>/dev/null)}"
	: "${HOST:=$(command uname -n 2>/dev/null)}"
	# Set a default ${HOSTNAME} that matches ${HOST}.
	: "${HOSTNAME:=${HOST}}"
}

steamship_host() {
	ssh_host=
	if [ -n "${BASH_VERSION}" ]; then
		if [ "${STEAMSHIP_HOST_SHOW_FULL}" = "true" ]; then
			ssh_host='\H'
		else
			ssh_host='\h'
		fi
	elif [ "${STEAMSHIP_PROMPT_PARAM_EXPANSION}" = true ]; then
		if [ "${STEAMSHIP_HOST_SHOW_FULL}" = true ]; then
			# shellcheck disable=SC2016
			ssh_host=${HOSTNAME:+'${HOSTNAME}'}
			# shellcheck disable=SC2016
			ssh_host=${HOST:+'${HOST}'}
		else
			# shellcheck disable=SC2016
			ssh_host=${HOSTNAME:+'${HOSTNAME%%.*}'}
			# shellcheck disable=SC2016
			ssh_host=${HOST:+'${HOST%%.*}'}
		fi
	else
		if [ "${STEAMSHIP_HOST_SHOW_FULL}" = true ]; then
			ssh_host=${HOSTNAME}
			ssh_host=${HOST}
		else
			ssh_host=${HOSTNAME%%.*}
			ssh_host=${HOST%%.*}
		fi
	fi

	ssh_color=
	ssh_colorvar=
	ssh_symbol=
	if [ -n "${SSH_CONNECTION}" ]; then
		ssh_colorvar="STEAMSHIP_${STEAMSHIP_HOST_COLOR_SSH}"
		ssh_symbol=${STEAMSHIP_HOST_SYMBOL_SSH}
	else
		ssh_colorvar="STEAMSHIP_${STEAMSHIP_HOST_COLOR}"
	fi
	eval 'ssh_color=${'"${ssh_colorvar}"'}'

	ssh_status=
	if	[ "${STEAMSHIP_HOST_SHOW}" = always ] ||
		[ -n "${SSH_CONNECTION}" ]
	then
		ssh_status="${ssh_symbol}${ssh_host}"
	fi
	if [ -n "${ssh_status}" ]; then
		ssh_status="${ssh_color}${ssh_status}${STEAMSHIP_BASE_COLOR}"
		if [ "${1}" = '-p' ]; then
			ssh_status="${STEAMSHIP_HOST_PREFIX}${ssh_status}"
		fi
		ssh_status="${ssh_status}${STEAMSHIP_HOST_SUFFIX}"
	fi

	echo "${ssh_status}"
	unset ssh_host ssh_color ssh_colorvar ssh_symbol ssh_status
}

steamship_host_prompt() {
	[ "${STEAMSHIP_HOST_SHOW}" = always ] ||
	[ "${STEAMSHIP_HOST_SHOW}" = true ] || return

	# Append status to ${STEAMSHIP_PROMPT_PS1}.
	if [ -n "${STEAMSHIP_PROMPT_PS1}" ]; then
		STEAMSHIP_PROMPT_PS1="${STEAMSHIP_PROMPT_PS1}$(steamship_host -p)"
	else
		STEAMSHIP_PROMPT_PS1=$(steamship_host)
	fi
}

STEAMSHIP_MODULES_SOURCED="${STEAMSHIP_MODULES_SOURCED} host"

case " ${STEAMSHIP_DEBUG} " in
*" host "*)
	export STEAMSHIP_PROMPT_PARAM_EXPANSION=true
	steamship_host_init
	steamship_host -p
	steamship_host_prompt
	echo "${STEAMSHIP_PROMPT_PS1}"
	;;
esac

# steamship/host.sh

# --------------------------------------------------------------------------
# | STEAMSHIP_HOST_SHOW | show hostname on local | show hostname on remote |
# |---------------------+------------------------+-------------------------|
# | false               | never                  | never                   |
# | always              | always                 | always                  |
# | true                | never                  | always                  |
# --------------------------------------------------------------------------

: ${STEAMSHIP_HOST_SHOW:='true'}
: ${STEAMSHIP_HOST_SHOW_FULL:='false'}
: ${STEAMSHIP_HOST_PREFIX:='at '}
: ${STEAMSHIP_HOST_SUFFIX:=${STEAMSHIP_SUFFIX_DEFAULT}}
: ${STEAMSHIP_HOST_SYMBOL:=''}
: ${STEAMSHIP_HOST_COLOR:='BLUE'}
: ${STEAMSHIP_HOST_COLOR_SSH:='GREEN'}

steamship_host_init() {
	# Set a default ${HOST} to the hostname of the system.
	: ${HOST:=$(command hostname 2>/dev/null)}
	: ${HOST:=$(command uname -n 2>/dev/null)}
}

steamship_host() {
	[ "${STEAMSHIP_HOST_SHOW}" = "false" ] && return

	ssh_host=
	if [ -n "${BASH_VERSION}" ]; then
		if [ "${STEAMSHIP_HOST_SHOW_FULL}" != "true" ]; then
			: ${ssh_host:='\h'}
		else
			: ${ssh_host:='\H'}
		fi
	elif [ -n "${KSH_VERSION}${ZSH_VERSION}" ]; then
		if [ "${STEAMSHIP_HOST_SHOW_FULL}" != "true" ]; then
			: ${ssh_host:=${HOSTNAME:+'${HOSTNAME%%.*}'}}
			: ${ssh_host:=${HOST:+'${HOST%%.*}'}}
			: ${ssh_host:='${SYSTYPE%%.*}'}
		else
			: ${ssh_host:=${HOSTNAME:+'${HOSTNAME}'}}
			: ${ssh_host:=${HOST:+'${HOST}'}}
			: ${ssh_host:='${SYSTYPE}'}
		fi
	else
		if [ "${STEAMSHIP_HOST_SHOW_FULL}" != "true" ]; then
			: ${ssh_host:=${HOSTNAME%%.*}}
			: ${ssh_host:=${HOST%%.*}}
			: ${ssh_host:=${SYSTYPE%%.*}}
		else
			: ${ssh_host:=${HOSTNAME}}
			: ${ssh_host:=${HOST}}
			: ${ssh_host:=${SYSTYPE}}
		fi
	fi

	if [ -n "${SSH_CONNECTION}" ]; then
		ssh_colorvar="STEAMSHIP_${STEAMSHIP_HOST_COLOR_SSH}"
	else
		ssh_colorvar="STEAMSHIP_${STEAMSHIP_HOST_COLOR}"
	fi
	eval 'ssh_color=${'${ssh_colorvar}'}'
	unset ssh_colorvar

	ssh_status=
	if [ -n "${ssh_host}" ]; then
		if	[ "${STEAMSHIP_HOST_SHOW}" = "always" ] ||
			[ -n "${SSH_CONNECTION}" ]
		then
			if [ -n "${STEAMSHIP_HOST_SYMBOL}" ]; then
				ssh_status="${STEAMSHIP_HOST_SYMBOL} "
			fi
			ssh_status="${ssh_status}${ssh_host}"
		fi
	fi

	if [ -n "${ssh_status}" ]; then
		ssh_status="${ssh_color}${ssh_status}${STEAMSHIP_WHITE}"
		# Append status to ${STEAMSHIP_PROMPT}.
		if [ -n "${STEAMSHIP_PROMPT}" ]; then
			STEAMSHIP_PROMPT="${STEAMSHIP_PROMPT}${STEAMSHIP_HOST_PREFIX}"
		fi
		STEAMSHIP_PROMPT="${STEAMSHIP_PROMPT}${ssh_status}"
		STEAMSHIP_PROMPT="${STEAMSHIP_PROMPT}${STEAMSHIP_HOST_SUFFIX}"
	fi
	unset ssh_host ssh_status ssh_color
}

steamship_host_init

case " ${STEAMSHIP_DEBUG} " in
*" host "*)
	steamship_host
	echo "${STEAMSHIP_PROMPT}"
	;;
esac

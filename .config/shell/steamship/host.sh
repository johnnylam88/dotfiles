# steamship/host.sh

# --------------------------------------------------------------------------
# | STEAMSHIP_HOST_SHOW | show hostname on local | show hostname on remote |
# |---------------------+------------------------+-------------------------|
# | false               | never                  | never                   |
# | always              | always                 | always                  |
# | true                | never                  | always                  |
# --------------------------------------------------------------------------

: ${STEAMSHIP_HOST_SHOW:=true}
: ${STEAMSHIP_HOST_SHOW_FULL:=false}

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

	# Add the hostname if we're in an SSH session.
	ssh_prefix=
	ssh_status=
	if [ -n "${ssh_host}" ]; then
		if	[ "${STEAMSHIP_HOST_SHOW}" = "always" ] || \
			[ -n "${SSH_CONNECTION}" ]
		then
			ssh_prefix=" ${STEAMSHIP_WHITE}at${STEAMSHIP_NORMAL}"
			if [ -n "${SSH_CONNECTION}" ]; then
				ssh_status=" ${STEAMSHIP_GREEN}${ssh_host}${STEAMSHIP_NORMAL}"
			else
				ssh_status=" ${STEAMSHIP_BLUE}${ssh_host}${STEAMSHIP_NORMAL}"
			fi
		fi
	fi

	# Append status to ${STEAMSHIP_PROMPT}.
	if [ -n "${STEAMSHIP_PROMPT}" ]; then
		STEAMSHIP_PROMPT="${STEAMSHIP_PROMPT}${ssh_prefix}${ssh_status}"
	else
		STEAMSHIP_PROMPT="${ssh_status}"
	fi
	unset ssh_host ssh_prefix ssh_status
}

steamship_host_init

case " ${STEAMSHIP_DEBUG} " in
*" host "*)
	steamship_host
	echo "${STEAMSHIP_PROMPT}"
	;;
esac

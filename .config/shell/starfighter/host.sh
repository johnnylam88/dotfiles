# starfighter/host.sh

# ----------------------------------------------------------------------------
# | STARFIGHTER_HOST_SHOW | show hostname on local | show hostname on remote |
# |-----------------------+------------------------+-------------------------|
# | false                 | never                  | never                   |
# | always                | always                 | always                  |
# | true                  | never                  | always                  |
# ----------------------------------------------------------------------------

: ${STARFIGHTER_HOST_SHOW:=true}

starfighter_host() {
	[ "${STARFIGHTER_HOST_SHOW}" = "false" ] && return

	sfh_host=
	if [ -n "${BASH_VERSION}" ]; then
		: ${sfh_host:='\h'}
	elif [ -n "${KSH_VERSION}${ZSH_VERSION}" ]; then
		: ${sfh_host:=${HOSTNAME:+'${HOSTNAME}'}}
		: ${sfh_host:=${HOST:+'${HOST}'}}
		: ${sfh_host:='${SYSTYPE}'}
	else
		: ${sfh_host:=${HOSTNAME}}
		: ${sfh_host:=${HOST}}
		: ${sfh_host:=${SYSTYPE}}
	fi

	# Add the hostname if we're in an SSH session.
	sfh_prefix=
	sfh_status=
	if [ -n "${sfh_host}" ]; then
		if	[ "${STARFIGHTER_HOST_SHOW}" = "always" ] || \
			[ -n "${SSH_CONNECTION}" ]
		then
			sfh_prefix=" ${STARFIGHTER_WHITE}at${STARFIGHTER_NORMAL}"
			if [ -n "${SSH_CONNECTION}" ]; then
				sfh_status=" ${STARFIGHTER_GREEN}${sfh_host}${STARFIGHTER_NORMAL}"
			else
				sfh_status=" ${STARFIGHTER_BLUE}${sfh_host}${STARFIGHTER_NORMAL}"
			fi
		fi
	fi

	# Append status to ${STARFIGHTER_PROMPT}.
	if [ -n "${STARFIGHTER_PROMPT}" ]; then
		STARFIGHTER_PROMPT="${STARFIGHTER_PROMPT}${sfh_prefix}${sfh_status}"
	else
		STARFIGHTER_PROMPT="${sfh_status}"
	fi
	unset sfh_host sfh_prefix sfh_status
}

case " ${STARFIGHTER_DEBUG} " in
*" host "*)
	starfighter_host
	echo "${STARFIGHTER_PROMPT}"
	;;
esac

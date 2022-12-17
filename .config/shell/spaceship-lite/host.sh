# spaceship-lite-host.sh

# --------------------------------------------------------------------------
# | SPACESHIP_HOST_SHOW | show hostname on local | show hostname on remote |
# |---------------------+------------------------+-------------------------|
# | false               | never                  | never                   |
# | always              | always                 | always                  |
# | true                | never                  | always                  |
# --------------------------------------------------------------------------

: ${SPACESHIP_HOST_SHOW:=true}

spaceship_lite_prompt_host() {
	[ "${SPACESHIP_HOST_SHOW}" = "false" ] && return

	sslph_host=
	if [ -n "${BASH_VERSION}" ]; then
		: ${sslph_host:='\h'}
	elif [ -n "${KSH_VERSION}${ZSH_VERSION}" ]; then
		: ${sslph_host:=${HOSTNAME:+'${HOSTNAME}'}}
		: ${sslph_host:=${HOST:+'${HOST}'}}
		: ${sslph_host:='${SYSTYPE}'}
	else
		: ${sslph_host:=${HOSTNAME}}
		: ${sslph_host:=${HOST}}
		: ${sslph_host:=${SYSTYPE}}
	fi

	# Add the hostname if we're in an SSH session.
	sslph_prefix=
	sslph_status=
	if [ -n "${sslph_host}" ]; then
		if	[ "${SPACESHIP_HOST_SHOW}" = "always" ] || \
			[ -n "${SSH_CONNECTION}" ]
		then
			sslph_prefix=" ${SS_ESC_WHITE}at${SS_ESC_NORMAL}"
			if [ -n "${SSH_CONNECTION}" ]; then
				sslph_status=" ${SS_ESC_GREEN}${sslph_host}${SS_ESC_NORMAL}"
			else
				sslph_status=" ${SS_ESC_BLUE}${sslph_host}${SS_ESC_NORMAL}"
			fi
		fi
	fi

	# Append status to ${SPACESHIP_LITE_PROMPT}.
	if [ -n "${SPACESHIP_LITE_PROMPT}" ]; then
		SPACESHIP_LITE_PROMPT="${SPACESHIP_LITE_PROMPT}${sslph_prefix}${sslph_status}"
	else
		SPACESHIP_LITE_PROMPT="${sslph_status}"
	fi
	unset sslph_host sslph_prefix sslph_status
}

case " ${SPACESHIP_LITE_DEBUG} " in
*" host "*)
	spaceship_lite_prompt_host
	echo "${SPACESHIP_LITE_PROMPT}"
	;;
esac

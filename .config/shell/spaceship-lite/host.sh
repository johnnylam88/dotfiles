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

	if [ -n "${BASH_VERSION}" ]; then
		: ${sslph_host:='\h'}
	elif [ -n "${KSH_VERSION}${ZSH_VERSION}" ]; then
		: ${sslph_host:=${HOSTNAME:+'${HOSTNAME}'}}
		: ${sslph_host:=${HOST:+'${HOST}'}}
		: ${sslph_host:='${SYSTYPE}'}
	fi
	: ${sslph_host:=${HOSTNAME}}
	: ${sslph_host:=${HOST}}
	: ${sslph_host:=${SYSTYPE}}

	# Add the hostname if we're in an SSH session.
	sslph_prompt=
	if	[ "${SPACESHIP_HOST_SHOW}" = "always" ] || \
		[ -n "${SSH_CONNECTION}" ]
	then
		sslph_prompt="${sslph_prompt} ${SS_ESC_WHITE}at${SS_ESC_NORMAL}"
		if [ -n "${SSH_CONNECTION}" ]; then
			sslph_prompt="${sslph_prompt} ${SS_ESC_GREEN}${sslph_host}${SS_ESC_NORMAL}"
		else
			sslph_prompt="${sslph_prompt} ${SS_ESC_BLUE}${sslph_host}${SS_ESC_NORMAL}"
		fi
	fi
	echo "${sslph_prompt}"
	unset sslph_host sslph_prompt
}

SPACESHIP_LITE_PROMPT_HOST=$(spaceship_lite_prompt_host)

# spaceship-lite-host.sh

spaceship_lite_prompt_host() {
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
	if [ -n "${SSH_CONNECTION}" ]; then
		sslph_prompt="${sslph_prompt} ${SS_ESC_WHITE}at${SS_ESC_END}"
		sslph_prompt="${sslph_prompt} ${SS_ESC_GREEN}${sslph_host}${SS_ESC_END}"
	fi
	echo "${sslph_prompt}"
	unset sslph_host sslph_prompt
}

SPACESHIP_LITE_PROMPT_HOST=$(spaceship_lite_prompt_host)

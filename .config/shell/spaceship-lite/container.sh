# spaceship-lite-container.sh

: ${SPACESHIP_DOCKER_SHOW:=true}

spaceship_lite_prompt_container() {
	[ "${SPACESHIP_DOCKER_SHOW}" = false ] && return

	# Add container name if we're in a container.
	sslpc_name=
	sslpc_status=
	sslpc_prefix=
	if [ -f /run/.containerenv ]; then
		sslpc_name=$(. /run/.containerenv && command printf ${name})
		if [ -n "${sslpc_name}" ]; then
			sslpc_prefix=" ${SS_ESC_WHITE}on${SS_ESC_NORMAL}"
			sslpc_status=" ${SS_ESC_CYAN}⬢ (${sslpc_name})${SS_ESC_NORMAL}"
		fi
	fi

	# Append status to ${SPACESHIP_LITE_PROMPT}.
	if [ -n "${SPACESHIP_LITE_PROMPT}" ]; then
		SPACESHIP_LITE_PROMPT="${SPACESHIP_LITE_PROMPT}${sslpc_prefix}${sslpc_status}"
	else
		SPACESHIP_LITE_PROMPT="${sslpc_status}"
	fi
	unset sslpc_name sslpc_status sslpc_prefix
}

case " ${SPACESHIP_LITE_DEBUG} " in
*" container "*)
	spaceship_lite_prompt_container
	echo "${SPACESHIP_LITE_PROMPT}"
	;;
esac

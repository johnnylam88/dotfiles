# spaceship-lite-container.sh

spaceship_lite_prompt_container() {
	# Add container name if we're in a container.
	if [ -f /run/.containerenv ]; then
		sslpc_name=$(. /run/.containerenv && command printf ${name})
		sslpc_prompt=
		if [ -n "${sslpc_name}" ]; then
			sslpc_prompt="${sslpc_prompt} ${SS_ESC_WHITE}on${SS_ESC_NORMAL}"
			sslpc_prompt="${sslpc_prompt} ${SS_ESC_CYAN}⬢ (${sslpc_name})${SS_ESC_NORMAL}"
		fi
		echo "${sslpc_prompt}"
		unset sslpc_name sslpc_prompt
	fi
}

SPACESHIP_LITE_PROMPT_CONTAINER=$(spaceship_lite_prompt_container)

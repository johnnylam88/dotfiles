# spaceship-lite-dir.sh

spaceship_lite_prompt_dir() {
	if [ -n "${BASH_VERSION}" ]; then
		: ${sslpd_pwd:='\W'}
	elif [ -n "${KSH_VERSION}${ZSH_VERSION}" ]; then
		: ${sslpd_pwd:='${PWD##*/}'}
	fi
	: ${sslpd_pwd:=here}

	# Add the last component of the current directory.
	echo " ${SS_ESC_CYAN}${sslpd_pwd}${SS_ESC_END}"
	unset sslpd_pwd
}

SPACESHIP_LITE_PROMPT_DIR=$(spaceship_lite_prompt_dir)

# spaceship-lite-dir.sh

spaceship_lite_prompt_dir() {
	sslpd_pwd=
	if [ -n "${BASH_VERSION}" ]; then
		: ${sslpd_pwd:='\W'}
	elif [ -n "${KSH_VERSION}${ZSH_VERSION}" ]; then
		: ${sslpd_pwd:='${PWD##*/}'}
	fi

	# Add the last component of the current directory.
	sslpd_prefix=
	sslpd_status=
	if [ -n "${sslpd_pwd}" ]; then
		sslpd_prefix=" ${SS_ESC_WHITE}in${SS_ESC_NORMAL}"
		sslpd_status=" ${SS_ESC_CYAN}${sslpd_pwd}${SS_ESC_NORMAL}"
	fi

	# Append status to ${SPACESHIP_LITE_PROMPT}.
	if [ -n "${SPACESHIP_LITE_PROMPT}" ]; then
		SPACESHIP_LITE_PROMPT="${SPACESHIP_LITE_PROMPT}${sslpd_prefix}${sslpd_status}"
	else
		SPACESHIP_LITE_PROMPT="${sslpd_status}"
	fi
	unset sslpd_pwd sslpd_prefix sslpd_status
}

case " ${SPACESHIP_LITE_DEBUG} " in
*" dir "*)
	spaceship_lite_prompt_dir
	echo "${SPACESHIP_LITE_PROMPT}"
	;;
esac

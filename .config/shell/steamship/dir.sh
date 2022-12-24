# steamship/dir.sh

: ${STEAMSHIP_DIR_SHOW:=true}

steamship_dir() {
	[ "${STEAMSHIP_DIR_SHOW}" = false ] && return

	ssd_pwd=
	if [ -n "${BASH_VERSION}" ]; then
		: ${ssd_pwd:='\W'}
	elif [ -n "${KSH_VERSION}${ZSH_VERSION}" ]; then
		: ${ssd_pwd:='${PWD##*/}'}
	fi

	# Add the last component of the current directory.
	ssd_prefix=
	ssd_status=
	if [ -n "${ssd_pwd}" ]; then
		ssd_prefix=" ${STEAMSHIP_WHITE}in${STEAMSHIP_NORMAL}"
		ssd_status=" ${STEAMSHIP_CYAN}${ssd_pwd}${STEAMSHIP_NORMAL}"
	fi

	# Append status to ${STEAMSHIP_PROMPT}.
	if [ -n "${STEAMSHIP_PROMPT}" ]; then
		STEAMSHIP_PROMPT="${STEAMSHIP_PROMPT}${ssd_prefix}${ssd_status}"
	else
		STEAMSHIP_PROMPT="${ssd_status}"
	fi
	unset ssd_pwd ssd_prefix ssd_status
}

case " ${STEAMSHIP_DEBUG} " in
*" dir "*)
	steamship_dir
	echo "${STEAMSHIP_PROMPT}"
	;;
esac

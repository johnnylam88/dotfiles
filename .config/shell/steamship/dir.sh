# steamship/dir.sh

: ${STEAMSHIP_DIR_SHOW:='true'}
: ${STEAMSHIP_DIR_PREFIX:='in '}
: ${STEAMSHIP_DIR_SUFFIX:=${STEAMSHIP_SUFFIX_DEFAULT}}
: ${STEAMSHIP_DIR_SYMBOL:=''}
: ${STEAMSHIP_DIR_COLOR:='CYAN'}

steamship_dir() {
	ssd_pwd=
	if [ -n "${BASH_VERSION}" ]; then
		: ${ssd_pwd:='\W'}
	elif [ -n "${KSH_VERSION}${ZSH_VERSION}" ]; then
		: ${ssd_pwd:='${PWD##*/}'}
	fi

	ssd_colorvar="STEAMSHIP_${STEAMSHIP_DIR_COLOR}"
	eval 'ssd_color=${'${ssd_colorvar}'}'
	unset ssd_colorvar

	ssd_status=
	if [ -n "${ssd_pwd}" ]; then
		if [ -n "${STEAMSHIP_DIR_SYMBOL}" ]; then
			ssd_status="${STEAMSHIP_DIR_SYMBOL} "
		fi
		ssd_status="${ssd_status}${ssd_pwd}"
	fi
	if [ -n "${ssd_status}" ]; then
		ssd_status="${ssd_color}${ssd_status}${STEAMSHIP_WHITE}"
		if [ "${1}" = '-p' ]; then
			ssd_status="${STEAMSHIP_DIR_PREFIX}${ssd_status}"
		fi
		ssd_status="${ssd_status}${STEAMSHIP_DIR_SUFFIX}"
	fi
	echo "${ssd_status}"
	unset ssd_pwd ssd_status ssd_color
}

steamship_dir_prompt() {
	[ "${STEAMSHIP_DIR_SHOW}" = false ] && return

	# Append status to ${STEAMSHIP_PROMPT}.
	if [ -n "${STEAMSHIP_PROMPT}" ]; then
		STEAMSHIP_PROMPT="${STEAMSHIP_PROMPT}$(steamship_dir -p)"
	else
		STEAMSHIP_PROMPT=$(steamship_dir)
	fi
}

case " ${STEAMSHIP_DEBUG} " in
*" dir "*)
	echo "$(steamship_dir -p)"
	steamship_dir_prompt
	echo "${STEAMSHIP_PROMPT}"
	;;
esac

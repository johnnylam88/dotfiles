# steamship/dir.sh

: ${STEAMSHIP_DIR_SHOW:='true'}
: ${STEAMSHIP_DIR_PREFIX:='in '}
: ${STEAMSHIP_DIR_SUFFIX:=${STEAMSHIP_SUFFIX_DEFAULT}}
: ${STEAMSHIP_DIR_SYMBOL:=''}
: ${STEAMSHIP_DIR_COLOR:='CYAN'}

steamship_dir() {
	[ "${STEAMSHIP_DIR_SHOW}" = false ] && return

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

		# Append status to ${STEAMSHIP_PROMPT}.
		if [ -n "${STEAMSHIP_PROMPT}" ]; then
			STEAMSHIP_PROMPT="${STEAMSHIP_PROMPT}${STEAMSHIP_DIR_PREFIX}"
		fi
		STEAMSHIP_PROMPT="${STEAMSHIP_PROMPT}${ssd_status}"
		STEAMSHIP_PROMPT="${STEAMSHIP_PROMPT}${STEAMSHIP_DIR_SUFFIX}"
	fi
	unset ssd_pwd ssd_status ssd_color
}

case " ${STEAMSHIP_DEBUG} " in
*" dir "*)
	steamship_dir
	echo "${STEAMSHIP_PROMPT}"
	;;
esac

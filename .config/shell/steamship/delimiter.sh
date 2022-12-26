# steamship/delimiter.sh

: ${STEAMSHIP_DELIMITER_SHOW:='true'}
: ${STEAMSHIP_DELIMITER_PREFIX:=${STEAMSHIP_NEWLINE}}
: ${STEAMSHIP_DELIMITER_SUFFIX:=${STEAMSHIP_SUFFIX_DEFAULT}}
: ${STEAMSHIP_DELIMITER_SYMBOL:='❯'}
: ${STEAMSHIP_DELIMITER_COLOR:='YELLOW'}
: ${STEAMSHIP_DELIMITER_COLOR_ROOT:='RED'}

steamship_delimiter() {
	if	[ -n "${STEAMSHIP_DEBUG}" ] ||
		steamship_user_is_root
	then
		ssd_colorvar="STEAMSHIP_${STEAMSHIP_DELIMITER_COLOR_ROOT}"
	else
		ssd_colorvar="STEAMSHIP_${STEAMSHIP_DELIMITER_COLOR}"
	fi
	eval 'ssd_color=${'${ssd_colorvar}'}'
	unset ssd_colorvar

	ssd_status=
	if [ -n "${STEAMSHIP_DELIMITER_SYMBOL}" ]; then
		ssd_status="${ssd_color}${STEAMSHIP_DELIMITER_SYMBOL}${STEAMSHIP_WHITE}"
		if [ "${1}" = "-p" ]; then
			# Add prefix if requested with '-p'.
			ssd_status="${STEAMSHIP_DELIMITER_PREFIX}${ssd_status}"
		fi
		ssd_status="${ssd_status}${STEAMSHIP_DELIMITER_SUFFIX}"
	fi
	echo "${ssd_status}"
	unset ssd_status ssd_color
}

steamship_delimiter_prompt() {
	[ "${STEAMSHIP_DELIMITER_SHOW}" = "false" ] && return

	# Prepend status to ${STEAMSHIP_PROMPT}.
	STEAMSHIP_PROMPT="$(steamship_delimiter -p)${STEAMSHIP_PROMPT}"
}

case " ${STEAMSHIP_DEBUG} " in
*" delimiter "*)
	echo "$(steamship_delimiter -p)"
	steamship_delimiter_prompt
	echo "${STEAMSHIP_PROMPT}"
	;;
esac

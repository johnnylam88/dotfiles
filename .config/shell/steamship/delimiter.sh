# steamship/delimiter.sh

: ${STEAMSHIP_DELIMITER_SHOW:='true'}
: ${STEAMSHIP_DELIMITER_PREFIX:=${STEAMSHIP_NEWLINE}}
: ${STEAMSHIP_DELIMITER_SUFFIX:=${STEAMSHIP_SUFFIX_DEFAULT}}
: ${STEAMSHIP_DELIMITER_SYMBOL:='❯'}
: ${STEAMSHIP_DELIMITER_COLOR:='YELLOW'}
: ${STEAMSHIP_DELIMITER_COLOR_ROOT:='RED'}

steamship_delimiter() {
	[ "${STEAMSHIP_DELIMITER_SHOW}" = "false" ] && return

	if steamship_user_is_root; then
		ssd_colorvar="STEAMSHIP_${STEAMSHIP_DELIMITER_COLOR_ROOT}"
	else
		ssd_colorvar="STEAMSHIP_${STEAMSHIP_DELIMITER_COLOR}"
	fi
	eval 'ssd_color=${'${ssd_colorvar}'}'
	unset ssd_colorvar

	ssd_status=
	if	[ "${STEAMSHIP_DELIMITER_SHOW}" = "true" ] &&
		[ -n "${STEAMSHIP_DELIMITER_SYMBOL}" ]
	then
		ssd_status="${ssd_color}${STEAMSHIP_DELIMITER_SYMBOL}${STEAMSHIP_WHITE}"
		ssd_status="${ssd_status}${STEAMSHIP_DELIMITER_SUFFIX}"
	fi
	ssd_status="${STEAMSHIP_DELIMITER_PREFIX}${ssd_status}"

	# Prepend status to ${STEAMSHIP_PROMPT}.
	STEAMSHIP_PROMPT="${ssd_status}${STEAMSHIP_PROMPT}"
	unset ssd_status ssd_color
}

case " ${STEAMSHIP_DEBUG} " in
*" delimiter "*)
	steamship_delimiter
	echo "${STEAMSHIP_PROMPT}"
	;;
esac

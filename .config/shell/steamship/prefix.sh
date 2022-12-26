# steamship/prefix.sh

: ${STEAMSHIP_PREFIX_SHOW:=true}

steamship_prefix() {
	[ "${STEAMSHIP_PREFIX_SHOW}" = "false" ] && return

	ssp_status='❯'
	if steamship_user_is_root; then
		ssp_status="${STEAMSHIP_RED}${ssp_status}${STEAMSHIP_NORMAL}"
	else
		ssp_status="${STEAMSHIP_YELLOW}${ssp_status}${STEAMSHIP_NORMAL}"
	fi
	ssp_status="${STEAMSHIP_NEWLINE}${ssp_status}"

	# Prepend status to ${STEAMSHIP_PROMPT}.
	STEAMSHIP_PROMPT="${ssp_status}${STEAMSHIP_PROMPT}"
	unset ssp_status
}

case " ${STEAMSHIP_DEBUG} " in
*" prefix "*)
	steamship_prefix
	echo "${STEAMSHIP_PROMPT}"
	;;
esac

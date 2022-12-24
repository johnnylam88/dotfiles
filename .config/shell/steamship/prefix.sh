# starfighter/prefix.sh

: ${STARFIGHTER_PREFIX_SHOW:=true}

starfighter_prefix() {
	[ "${STARFIGHTER_PREFIX_SHOW}" = "false" ] && return

	sfp_status='❯'
	if starfighter_user_is_root; then
		sfp_status="${STARFIGHTER_RED}${sfp_status}${STARFIGHTER_NORMAL}"
	else
		sfp_status="${STARFIGHTER_YELLOW}${sfp_status}${STARFIGHTER_NORMAL}"
	fi
	sfp_status='
'"${sfp_status}"

	# Prepend status to ${STARFIGHTER_PROMPT}.
	STARFIGHTER_PROMPT="${sfp_status}${STARFIGHTER_PROMPT}"
	unset sfp_status
}

case " ${STARFIGHTER_DEBUG} " in
*" prefix "*)
	starfighter_prefix
	echo "${STARFIGHTER_PROMPT}"
	;;
esac

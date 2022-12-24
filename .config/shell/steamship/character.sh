# starfighter/character.sh

: ${STARFIGHTER_CHARACTER_SHOW:=true}

starfighter_character() {
	[ "${STARFIGHTER_CHARACTER_SHOW}" = "false" ] && return

	sfc_symbol=
	if [ -n "${BASH_VERSION}" ]; then
		: ${sfc_symbol:='\$'}
	elif starfighter_user_is_root; then
		: ${sfc_symbol:='#'}
	else
		: ${sfc_symbol:='$'}
	fi

	sfc_status='
'"${sfc_symbol} "

	# Append status to ${STARFIGHTER_PROMPT}.
	STARFIGHTER_PROMPT="${STARFIGHTER_PROMPT}${sfc_status}"
	unset sfc_symbol sfc_status
}

case " ${STARFIGHTER_DEBUG} " in
*" character "*)
	starfighter_character
	echo "${STARFIGHTER_PROMPT}"
	;;
esac

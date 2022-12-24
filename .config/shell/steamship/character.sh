# steamship/character.sh

: ${STEAMSHIP_CHARACTER_SHOW:=true}

steamship_character() {
	[ "${STEAMSHIP_CHARACTER_SHOW}" = "false" ] && return

	ssc_symbol=
	if [ -n "${BASH_VERSION}" ]; then
		: ${ssc_symbol:='\$'}
	elif steamship_user_is_root; then
		: ${ssc_symbol:='#'}
	else
		: ${ssc_symbol:='$'}
	fi

	ssc_status='
'"${ssc_symbol} "

	# Append status to ${STEAMSHIP_PROMPT}.
	STEAMSHIP_PROMPT="${STEAMSHIP_PROMPT}${ssc_status}"
	unset ssc_symbol ssc_status
}

case " ${STEAMSHIP_DEBUG} " in
*" character "*)
	steamship_character
	echo "${STEAMSHIP_PROMPT}"
	;;
esac

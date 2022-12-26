# steamship/character.sh

: ${STEAMSHIP_CHARACTER_SHOW:='true'}
: ${STEAMSHIP_CHARACTER_PREFIX:=${STEAMSHIP_NEWLINE}}
: ${STEAMSHIP_CHARACTER_SUFFIX:=' '}
: ${STEAMSHIP_CHARACTER_SYMBOL:='$'}
: ${STEAMSHIP_CHARACTER_SYMBOL_ROOT:='#'}

steamship_character() {
	[ "${STEAMSHIP_CHARACTER_SHOW}" = "false" ] && return

	ssc_char=
	if steamship_user_is_root; then
		ssc_char=${STEAMSHIP_CHARACTER_SYMBOL_ROOT:='#'}
	else
		ssc_char=${STEAMSHIP_CHARACTER_SYMBOL:='$'}
	fi
	# ${ssc_char} is always set and non-null.

	ssc_status=
	if [ -n "${ssc_char}" ]; then
		ssc_status=${ssc_char}
	fi

	if [ -n "${ssc_status}" ]; then
		ssc_status="${STEAMSHIP_NORMAL}${ssc_status}"
		# Append status to ${STEAMSHIP_PROMPT}.
		if [ -n "${STEAMSHIP_PROMPT}" ]; then
			STEAMSHIP_PROMPT="${STEAMSHIP_PROMPT}${STEAMSHIP_CHARACTER_PREFIX}"
		fi
		STEAMSHIP_PROMPT="${STEAMSHIP_PROMPT}${ssc_status}"
		STEAMSHIP_PROMPT="${STEAMSHIP_PROMPT}${STEAMSHIP_CHARACTER_SUFFIX}"
	fi
	unset ssc_char ssc_status
}

case " ${STEAMSHIP_DEBUG} " in
*" character "*)
	steamship_character
	echo "${STEAMSHIP_PROMPT}"
	;;
esac

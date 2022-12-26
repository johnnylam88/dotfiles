# steamship/character.sh

: ${STEAMSHIP_CHARACTER_SHOW:='true'}
: ${STEAMSHIP_CHARACTER_PREFIX:=${STEAMSHIP_NEWLINE}}
: ${STEAMSHIP_CHARACTER_SUFFIX:=' '}
: ${STEAMSHIP_CHARACTER_SYMBOL:='$'}
: ${STEAMSHIP_CHARACTER_SYMBOL_ROOT:='#'}

steamship_character() {
	ssc_char=
	if	[ -n "${STEAMSHIP_DEBUG}" ] ||
		steamship_user_is_root
	then
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
		if [ "${1}" = "-p" ]; then
			# Add prefix if requested with '-p'.
			ssc_status="${STEAMSHIP_CHARACTER_PREFIX}${ssc_status}"
		fi
		ssc_status="${ssc_status}${STEAMSHIP_CHARACTER_SUFFIX}"
	fi
	echo "${ssc_status}"
	unset ssc_char ssc_status
}

steamship_character_prompt() {
	[ "${STEAMSHIP_CHARACTER_SHOW}" = "false" ] && return

	# Append status to ${STEAMSHIP_PROMPT}.
	if [ -n "${STEAMSHIP_PROMPT}" ]; then
		STEAMSHIP_PROMPT="${STEAMSHIP_PROMPT}$(steamship_character -p)"
	else
		STEAMSHIP_PROMPT=$(steamship_character)
	fi
}

case " ${STEAMSHIP_DEBUG} " in
*" character "*)
	echo "$(steamship_character -p)"
	steamship_character_prompt
	echo "${STEAMSHIP_PROMPT}"
	;;
esac

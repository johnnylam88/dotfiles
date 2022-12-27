# steamship/character.sh

: ${STEAMSHIP_CHARACTER_SHOW:='true'}
: ${STEAMSHIP_CHARACTER_PREFIX:=${STEAMSHIP_NEWLINE}}
: ${STEAMSHIP_CHARACTER_SUFFIX:=' '}
: ${STEAMSHIP_CHARACTER_SYMBOL:='└'}
: ${STEAMSHIP_CHARACTER_SYMBOL_ROOT:='╙'}
: ${STEAMSHIP_CHARACTER_SYMBOL_SUCCESS:=${STEAMSHIP_CHARACTER_SYMBOL}}
: ${STEAMSHIP_CHARACTER_SYMBOL_FAILURE:=${STEAMSHIP_CHARACTER_SYMBOL}}
: ${STEAMSHIP_CHARACTER_COLOR_SUCCESS:=${STEAMSHIP_COLOR_SUCCESS}}
: ${STEAMSHIP_CHARACTER_COLOR_FAILURE:=${STEAMSHIP_COLOR_FAILURE}}

steamship_character() {
	ssc_char=
	ssc_color=
	ssc_colorvar=
	if [ -z "${STEAMSHIP_RETVAL}" ]; then
		ssc_colorvar='STEAMSHIP_WHITE'
		ssc_char=${STEAMSHIP_CHARACTER_SYMBOL}
	elif [ "${STEAMSHIP_RETVAL}" = 0 ]; then
		ssc_colorvar="STEAMSHIP_${STEAMSHIP_CHARACTER_COLOR_SUCCESS}"
		ssc_char=${STEAMSHIP_CHARACTER_SYMBOL_SUCCESS}
	else
		ssc_colorvar="STEAMSHIP_${STEAMSHIP_CHARACTER_COLOR_FAILURE}"
		ssc_char=${STEAMSHIP_CHARACTER_SYMBOL_FAILURE}
	fi
	eval 'ssc_color=${'${ssc_colorvar}'}'

	if	[ -n "${STEAMSHIP_DEBUG}" ] ||
		steamship_user_is_root
	then
		ssc_char=${STEAMSHIP_CHARACTER_SYMBOL_ROOT}
	fi
	# ${ssc_char} is always set and non-null.

	ssc_status=
	if [ -n "${ssc_char}" ]; then
		ssc_status=${ssc_char}
	fi
	if [ -n "${ssc_status}" ]; then
		# Reset color to *normal* for user text.
		ssc_status="${ssc_color}${ssc_status}${STEAMSHIP_NORMAL}"
		if [ "${1}" = '-p' ]; then
			ssc_status="${STEAMSHIP_CHARACTER_PREFIX}${ssc_status}"
		fi
		ssc_status="${ssc_status}${STEAMSHIP_CHARACTER_SUFFIX}"
	fi

	echo "${ssc_status}"
	unset ssc_char ssc_color ssc_colorvar ssc_status
}

steamship_character_prompt() {
	[ "${STEAMSHIP_CHARACTER_SHOW}" = true ] || return

	# Append status to ${STEAMSHIP_PROMPT}.
	if [ "${STEAMSHIP_PROMPT_HAS_COMMAND_SUBST}" = true ]; then
		if [ -n "${STEAMSHIP_PROMPT}" ]; then
			STEAMSHIP_PROMPT="${STEAMSHIP_PROMPT}"'$(steamship_character -p)'
		else
			STEAMSHIP_PROMPT='$(steamship_character)'
		fi
	else
		if [ -n "${STEAMSHIP_PROMPT}" ]; then
			STEAMSHIP_PROMPT="${STEAMSHIP_PROMPT}$(steamship_character -p)"
		else
			STEAMSHIP_PROMPT=$(steamship_character)
		fi
	fi
}

case " ${STEAMSHIP_DEBUG} " in
*" character "*)
	export STEAMSHIP_PROMPT_HAS_COMMAND_SUBST=true
	export STEAMSHIP_RETVAL=1
	echo "$(steamship_character -p)"
	steamship_character_prompt
	echo "${STEAMSHIP_PROMPT}"
	;;
esac

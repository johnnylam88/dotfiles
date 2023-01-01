# shellcheck shell=sh
# steamship/modules/character.sh

steamship_character_init() {
	STEAMSHIP_CHARACTER_SHOW='true'
	STEAMSHIP_CHARACTER_PREFIX=''
	STEAMSHIP_CHARACTER_SUFFIX=''
	STEAMSHIP_CHARACTER_SYMBOL='$ '
	STEAMSHIP_CHARACTER_SYMBOL_ROOT='# '
	STEAMSHIP_CHARACTER_SYMBOL_SUCCESS=${STEAMSHIP_CHARACTER_SYMBOL}
	STEAMSHIP_CHARACTER_SYMBOL_FAILURE=${STEAMSHIP_CHARACTER_SYMBOL}
	STEAMSHIP_CHARACTER_COLOR_SUCCESS=${STEAMSHIP_COLOR_SUCCESS}
	STEAMSHIP_CHARACTER_COLOR_FAILURE=${STEAMSHIP_COLOR_FAILURE}
}

steamship_character() {
	ssc_symbol=
	ssc_color=
	ssc_colorvar=
	if [ -z "${STEAMSHIP_RETVAL}" ]; then
		ssc_colorvar='STEAMSHIP_BASE_COLOR'
		ssc_symbol=${STEAMSHIP_CHARACTER_SYMBOL}
	elif [ "${STEAMSHIP_RETVAL}" = 0 ]; then
		ssc_colorvar="STEAMSHIP_${STEAMSHIP_CHARACTER_COLOR_SUCCESS}"
		ssc_symbol=${STEAMSHIP_CHARACTER_SYMBOL_SUCCESS}
	else
		ssc_colorvar="STEAMSHIP_${STEAMSHIP_CHARACTER_COLOR_FAILURE}"
		ssc_symbol=${STEAMSHIP_CHARACTER_SYMBOL_FAILURE}
	fi
	eval 'ssc_color=${'"${ssc_colorvar}"'}'

	if	[ -n "${STEAMSHIP_DEBUG}" ] ||
		steamship_user_is_root
	then
		ssc_symbol=${STEAMSHIP_CHARACTER_SYMBOL_ROOT}
	fi
	# ${ssc_symbol} is always set and non-null.

	ssc_status=
	if [ -n "${ssc_symbol}" ]; then
		ssc_status=${ssc_symbol}
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
	unset ssc_symbol ssc_color ssc_colorvar ssc_status
}

steamship_character_prompt() {
	[ "${STEAMSHIP_CHARACTER_SHOW}" = true ] || return

	# Append status to ${STEAMSHIP_PROMPT}.
	if [ "${STEAMSHIP_PROMPT_COMMAND_SUBST}" = true ]; then
		if [ -n "${STEAMSHIP_PROMPT}" ]; then
			# shellcheck disable=SC2016
			STEAMSHIP_PROMPT="${STEAMSHIP_PROMPT}"'$(steamship_character -p)'
		else
			# shellcheck disable=SC2016
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
	export STEAMSHIP_PROMPT_COMMAND_SUBST=true
	export STEAMSHIP_RETVAL=1
	steamship_character_init
	steamship_character -p
	steamship_character_prompt
	echo "${STEAMSHIP_PROMPT}"
	;;
esac

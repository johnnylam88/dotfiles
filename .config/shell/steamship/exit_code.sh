# steamship/exit_code.sh

: ${STEAMSHIP_EXIT_CODE_SHOW:='false'}
: ${STEAMSHIP_EXIT_CODE_PREFIX:=''}
: ${STEAMSHIP_EXIT_CODE_SUFFIX:=${STEAMSHIP_SUFFIX_DEFAULT}}
: ${STEAMSHIP_EXIT_CODE_SYMBOL:='✘'}
: ${STEAMSHIP_EXIT_CODE_COLOR:='RED'}

steamship_exit_code() {
	[ "${STEAMSHIP_RETVAL}" = 0 ] && return

	ssec_colorvar="STEAMSHIP_${STEAMSHIP_EXIT_CODE_COLOR}"
	eval 'ssec_color=${'${ssec_colorvar}'}'
	unset ssec_colorvar

	ssec_status=
	if [ -n "${STEAMSHIP_RETVAL}" ]; then
		if [ -n "${STEAMSHIP_EXIT_CODE_SYMBOL}" ]; then
			ssec_status="${STEAMSHIP_EXIT_CODE_SYMBOL} "
		fi
		ssec_status="${ssec_status}${STEAMSHIP_RETVAL}"
	fi
	if [ -n "${ssec_status}" ]; then
		ssec_status="${ssec_color}${ssec_status}${STEAMSHIP_WHITE}"
		if [ "${1}" = '-p' ]; then
			ssec_status="${STEAMSHIP_EXIT_CODE_PREFIX}${ssec_status}"
		fi
		ssec_status="${ssec_status}${STEAMSHIP_EXIT_CODE_SUFFIX}"
	fi
	echo "${ssec_status}"
	unset ssec_status ssec_color
}

steamship_exit_code_prompt() {
	[ -z "${STEAMSHIP_PROMPT_HAS_COMMAND_SUBST}" ] && return
	[ "${STEAMSHIP_EXIT_CODE_SHOW}" = false ] && return

	# Append status to ${STEAMSHIP_PROMPT}.
	if [ -n "${STEAMSHIP_PROMPT}" ]; then
		STEAMSHIP_PROMPT="${STEAMSHIP_PROMPT}"'$(steamship_exit_code -p)'
	else
		STEAMSHIP_PROMPT='$(steamship_exit_code)'
	fi
}

case " ${STEAMSHIP_DEBUG} " in
*" exit_code "*)
	export STEAMSHIP_PROMPT_HAS_COMMAND_SUBST=true
	export STEAMSHIP_EXIT_CODE_SHOW=true
	export STEAMSHIP_RETVAL=1
	echo "$(steamship_exit_code -p)"
	steamship_exit_code_prompt
	echo "${STEAMSHIP_PROMPT}"
	;;
esac

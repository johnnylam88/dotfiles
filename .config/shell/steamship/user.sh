# steamship/user.sh

# --------------------------------------------------------------------------
# | STEAMSHIP_USER_SHOW | show username on local | show username on remote |
# |---------------------+------------------------+-------------------------|
# | false               | never                  | never                   |
# | always              | always                 | always                  |
# | true                | if needed              | always                  |
# | needed              | if needed              | if needed               |
# --------------------------------------------------------------------------

: ${STEAMSHIP_USER_SHOW:='true'}
: ${STEAMSHIP_USER_PREFIX:='with '}
: ${STEAMSHIP_USER_SUFFIX:=${STEAMSHIP_SUFFIX_DEFAULT}}
: ${STEAMSHIP_USER_SYMBOL:=''}
: ${STEAMSHIP_USER_COLOR:='YELLOW'}
: ${STEAMSHIP_USER_COLOR_ROOT:='RED'}

# Global function to be used by other modules.
steamship_user_is_root() {
	# Returns true if the user is root, or false otherwise.
	[ "${UID}" = 0 ]
}

steamship_user() {
	ssu_user=
	if [ -n "${BASH_VERSION}" ]; then
		: ${ssu_user:='\u'}
	elif [ "${STEAMSHIP_PROMPT_PARAM_EXPANSION}" = true ]; then
		: ${ssu_user:='${USER}'}
	else
		: ${ssu_user:=${USER}}
	fi

	ssu_color=
	ssu_colorvar=
	if steamship_user_is_root; then
		ssu_colorvar="STEAMSHIP_${STEAMSHIP_USER_COLOR_ROOT}"
	else
		ssu_colorvar="STEAMSHIP_${STEAMSHIP_USER_COLOR}"
	fi
	eval 'ssu_color=${'${ssu_colorvar}'}'

	ssu_status=
	if [ -n "${ssu_user}" ]; then
		if	[ "${STEAMSHIP_USER_SHOW}" = always ] || \
			[ "${LOGNAME}" != "${USER}" ] || \
			steamship_user_is_root || \
			[ "${STEAMSHIP_USER_SHOW}" = true -a -n "${SSH_CONNECTION}" ]
		then
			if [ -n "${STEAMSHIP_USER_SYMBOL}" ]; then
				ssu_status="${STEAMSHIP_USER_SYMBOL} "
			fi
			ssu_status="${ssu_status}${ssu_user}"
		fi
	fi
	if [ -n "${ssu_status}" ]; then
		ssu_status="${ssu_color}${ssu_status}${STEAMSHIP_BASE_COLOR}"
		if [ "${1}" = '-p' ]; then
			ssu_status="${STEAMSHIP_USER_PREFIX}${ssu_status}"
		fi
		ssu_status="${ssu_status}${STEAMSHIP_USER_SUFFIX}"
	fi

	echo "${ssu_status}"
	unset ssu_user ssu_color ssu_colorvar ssu_status
}

steamship_user_prompt() {
	[ "${STEAMSHIP_USER_SHOW}" = always ] ||
	[ "${STEAMSHIP_USER_SHOW}" = true ] ||
	[ "${STEAMSHIP_USER_SHOW}" = needed ] || return

	# Append status to ${STEAMSHIP_PROMPT}.
	if [ -n "${STEAMSHIP_PROMPT}" ]; then
		STEAMSHIP_PROMPT="${STEAMSHIP_PROMPT}$(steamship_user -p)"
	else
		STEAMSHIP_PROMPT=$(steamship_user)
	fi
}

case " ${STEAMSHIP_DEBUG} " in
*" user "*)
	export STEAMSHIP_PROMPT_PARAM_EXPANSION=true
	echo "$(steamship_user -p)"
	steamship_user_prompt
	echo "${STEAMSHIP_PROMPT}"
	;;
esac

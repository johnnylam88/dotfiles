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
	[ "${UID}" = "0" ]
}

steamship_user() {
	[ "${STEAMSHIP_USER_SHOW}" = "false" ] && return

	ssu_user=
	if [ -n "${BASH_VERSION}" ]; then
		: ${ssu_user:='\u'}
	elif [ -n "${KSH_VERSION}${ZSH_VERSION}" ]; then
		: ${ssu_user:='${USER}'}
	else
		: ${ssu_user:=${USER}}
	fi

	if steamship_user_is_root; then
		ssu_colorvar="STEAMSHIP_${STEAMSHIP_USER_COLOR_ROOT}"
	else
		ssu_colorvar="STEAMSHIP_${STEAMSHIP_USER_COLOR}"
	fi
	eval 'ssu_color=${'${ssu_colorvar}'}'
	unset ssu_colorvar

	ssu_status=
	if [ -n "${ssu_user}" ]; then
		if	[ "${STEAMSHIP_USER_SHOW}" = "always" ] || \
			[ "${LOGNAME}" != "${USER}" ] || \
			steamship_user_is_root || \
			[ "${STEAMSHIP_USER_SHOW}" = "true" -a -n "${SSH_CONNECTION}" ]
		then
			if [ -n "${STEAMSHIP_USER_SYMBOL}" ]; then
				ssu_status="${STEAMSHIP_USER_SYMBOL} "
			fi
			ssu_status="${ssu_status}${ssu_user}"
		fi
	fi

	if [ -n "${ssu_status}" ]; then
		ssu_status="${ssu_color}${ssu_status}${STEAMSHIP_WHITE}"
		# Append status to ${STEAMSHIP_PROMPT}.
		if [ -n "${STEAMSHIP_PROMPT}" ]; then
			STEAMSHIP_PROMPT="${STEAMSHIP_PROMPT}${STEAMSHIP_USER_PREFIX}"
		fi
		STEAMSHIP_PROMPT="${STEAMSHIP_PROMPT}${ssu_status}"
		STEAMSHIP_PROMPT="${STEAMSHIP_PROMPT}${STEAMSHIP_USER_SUFFIX}"
	fi
	unset ssu_user ssu_status ssu_color
}

case " ${STEAMSHIP_DEBUG} " in
*" user "*)
	steamship_user
	echo "${STEAMSHIP_PROMPT}"
	;;
esac

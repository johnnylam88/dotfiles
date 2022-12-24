# steamship/user.sh

# --------------------------------------------------------------------------
# | STEAMSHIP_USER_SHOW | show username on local | show username on remote |
# |---------------------+------------------------+-------------------------|
# | false               | never                  | never                   |
# | always              | always                 | always                  |
# | true                | if needed              | always                  |
# | needed              | if needed              | if needed               |
# --------------------------------------------------------------------------

: ${STEAMSHIP_USER_SHOW:=true}

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

	# Add the user if this is not localhost.
	ssu_prefix=
	ssu_status=
	if [ -n "${ssu_user}" ]; then
		if	[ "${STEAMSHIP_USER_SHOW}" = "always" ] || \
			[ "${LOGNAME}" != "${USER}" ] || \
			steamship_user_is_root || \
			[ "${STEAMSHIP_USER_SHOW}" = "true" -a -n "${SSH_CONNECTION}" ]
		then
			ssu_prefix=" ${STEAMSHIP_WHITE}with${STEAMSHIP_NORMAL}"
			if steamship_user_is_root; then
				ssu_status=" ${STEAMSHIP_RED}${ssu_user}${STEAMSHIP_NORMAL}"
			else
				ssu_status=" ${STEAMSHIP_YELLOW}${ssu_user}${STEAMSHIP_NORMAL}"
			fi
		fi
	fi

	# Append status to ${STEAMSHIP_PROMPT}.
	if [ -n "${STEAMSHIP_PROMPT}" ]; then
		STEAMSHIP_PROMPT="${STEAMSHIP_PROMPT}${ssu_prefix}${ssu_status}"
	else
		STEAMSHIP_PROMPT="${ssu_status}"
	fi
	unset ssu_user ssu_prefix ssu_status
}

case " ${STEAMSHIP_DEBUG} " in
*" user "*)
	steamship_user
	echo "${STEAMSHIP_PROMPT}"
	;;
esac

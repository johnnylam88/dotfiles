# starfighter/user.sh

# ----------------------------------------------------------------------------
# | STARFIGHTER_USER_SHOW | show username on local | show username on remote |
# |-----------------------+------------------------+-------------------------|
# | false                 | never                  | never                   |
# | always                | always                 | always                  |
# | true                  | if needed              | always                  |
# | needed                | if needed              | if needed               |
# ----------------------------------------------------------------------------

: ${STARFIGHTER_USER_SHOW:=true}

# Global function to be used by other modules.
starfighter_user_is_root() {
	# Returns true if the user is root, or false otherwise.
	[ "${UID}" = "0" ]
}

starfighter_user() {
	[ "${STARFIGHTER_USER_SHOW}" = "false" ] && return

	sfu_user=
	if [ -n "${BASH_VERSION}" ]; then
		: ${sfu_user:='\u'}
	elif [ -n "${KSH_VERSION}${ZSH_VERSION}" ]; then
		: ${sfu_user:='${USER}'}
	else
		: ${sfu_user:=${USER}}
	fi

	# Add the user if this is not localhost.
	sfu_prefix=
	sfu_status=
	if [ -n "${sfu_user}" ]; then
		if	[ "${STARFIGHTER_USER_SHOW}" = "always" ] || \
			[ "${LOGNAME}" != "${USER}" ] || \
			starfighter_user_is_root || \
			[ "${STARFIGHTER_USER_SHOW}" = "true" -a -n "${SSH_CONNECTION}" ]
		then
			sfu_prefix=" ${STARFIGHTER_WHITE}with${STARFIGHTER_NORMAL}"
			if starfighter_user_is_root; then
				sfu_status=" ${STARFIGHTER_RED}${sfu_user}${STARFIGHTER_NORMAL}"
			else
				sfu_status=" ${STARFIGHTER_YELLOW}${sfu_user}${STARFIGHTER_NORMAL}"
			fi
		fi
	fi

	# Append status to ${STARFIGHTER_PROMPT}.
	if [ -n "${STARFIGHTER_PROMPT}" ]; then
		STARFIGHTER_PROMPT="${STARFIGHTER_PROMPT}${sfu_prefix}${sfu_status}"
	else
		STARFIGHTER_PROMPT="${sfu_status}"
	fi
	unset sfu_user sfu_prefix sfu_status
}

case " ${STARFIGHTER_DEBUG} " in
*" user "*)
	starfighter_user
	echo "${STARFIGHTER_PROMPT}"
	;;
esac

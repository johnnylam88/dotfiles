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
			[ "${UID}" = "0" ] || \
			[ "${STARFIGHTER_USER_SHOW}" = "true" -a -n "${SSH_CONNECTION}" ]
		then
			sfu_prefix=" ${STARFIGHTER_WHITE}with${STARFIGHTER_NORMAL}"
			case ${USER} in
			root)
				sfu_status=" ${STARFIGHTER_RED}${sfu_user}${STARFIGHTER_NORMAL}"
				;;
			*)
				sfu_status=" ${STARFIGHTER_YELLOW}${sfu_user}${STARFIGHTER_NORMAL}"
				;;
			esac
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

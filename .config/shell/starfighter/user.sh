# spaceship-lite-user.sh

# --------------------------------------------------------------------------
# | SPACESHIP_USER_SHOW | show username on local | show username on remote |
# |---------------------+------------------------+-------------------------|
# | false               | never                  | never                   |
# | always              | always                 | always                  |
# | true                | if needed              | always                  |
# | needed              | if needed              | if needed               |
# --------------------------------------------------------------------------

: ${SPACESHIP_USER_SHOW:=true}

spaceship_lite_prompt_user() {
	[ "${SPACESHIP_USER_SHOW}" = "false" ] && return

	sslpu_user=
	if [ -n "${BASH_VERSION}" ]; then
		: ${sslpu_user:='\u'}
	elif [ -n "${KSH_VERSION}${ZSH_VERSION}" ]; then
		: ${sslpu_user:='${USER}'}
	else
		: ${sslpu_user:=${USER}}
	fi

	# Add the user if this is not localhost.
	sslpu_prefix=
	sslpu_status=
	if [ -n "${sslpu_user}" ]; then
		if	[ "${SPACESHIP_USER_SHOW}" = "always" ] || \
			[ "${LOGNAME}" != "${USER}" ] || \
			[ "${UID}" = "0" ] || \
			[ "${SPACESHIP_USER_SHOW}" = "true" -a -n "${SSH_CONNECTION}" ]
		then
			sslpu_prefix=" ${SS_ESC_WHITE}with${SS_ESC_NORMAL}"
			case ${USER} in
			root)
				sslpu_status=" ${SS_ESC_RED}${sslpu_user}${SS_ESC_NORMAL}"
				;;
			*)
				sslpu_status=" ${SS_ESC_YELLOW}${sslpu_user}${SS_ESC_NORMAL}"
				;;
			esac
		fi
	fi

	# Append status to ${SPACESHIP_LITE_PROMPT}.
	if [ -n "${SPACESHIP_LITE_PROMPT}" ]; then
		SPACESHIP_LITE_PROMPT="${SPACESHIP_LITE_PROMPT}${sslpu_prefix}${sslpu_status}"
	else
		SPACESHIP_LITE_PROMPT="${sslpu_status}"
	fi
	unset sslpu_user sslpu_prefix sslpu_status
}

case " ${SPACESHIP_LITE_DEBUG} " in
*" user "*)
	spaceship_lite_prompt_user
	echo "${SPACESHIP_LITE_PROMPT}"
	;;
esac

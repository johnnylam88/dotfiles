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

	if [ -n "${BASH_VERSION}" ]; then
		: ${sslpu_user:='\u'}
	elif [ -n "${KSH_VERSION}${ZSH_VERSION}" ]; then
		: ${sslpu_user:='${USER}'}
	fi
	: ${sslpu_user:=${USER}}

	# Add the user if this is not localhost.
	sslpu_prompt=
	if	[ "${SPACESHIP_USER_SHOW}" = "always" ] || \
		[ "${LOGNAME}" != "${USER}" ] || \
		[ "${UID}" = "0" ] || \
		[ "${SPACESHIP_USER_SHOW}" = "true" -a -n "${SSH_CONNECTION}" ]
	then
		case ${USER} in
		root)
			sslpu_prompt="${sslpu_prompt} ${SS_ESC_RED}${sslpu_user}${SS_ESC_END}"
			;;
		*)
			sslpu_prompt="${sslpu_prompt} ${SS_ESC_YELLOW}${sslpu_user}${SS_ESC_END}"
			;;
		esac
		sslpu_prompt="${sslpu_prompt} ${SS_ESC_WHITE}in${SS_ESC_END}"
	fi
	echo "${sslpu_prompt}"
	unset sslpu_user sslpu_prompt
}

SPACESHIP_LITE_PROMPT_USER=$(spaceship_lite_prompt_user)

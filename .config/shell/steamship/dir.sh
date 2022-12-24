# starfighter/dir.sh

: ${STARFIGHTER_DIR_SHOW:=true}

starfighter_dir() {
	[ "${STARFIGHTER_DIR_SHOW}" = false ] && return

	sfd_pwd=
	if [ -n "${BASH_VERSION}" ]; then
		: ${sfd_pwd:='\W'}
	elif [ -n "${KSH_VERSION}${ZSH_VERSION}" ]; then
		: ${sfd_pwd:='${PWD##*/}'}
	fi

	# Add the last component of the current directory.
	sfd_prefix=
	sfd_status=
	if [ -n "${sfd_pwd}" ]; then
		sfd_prefix=" ${STARFIGHTER_WHITE}in${STARFIGHTER_NORMAL}"
		sfd_status=" ${STARFIGHTER_CYAN}${sfd_pwd}${STARFIGHTER_NORMAL}"
	fi

	# Append status to ${STARFIGHTER_PROMPT}.
	if [ -n "${STARFIGHTER_PROMPT}" ]; then
		STARFIGHTER_PROMPT="${STARFIGHTER_PROMPT}${sfd_prefix}${sfd_status}"
	else
		STARFIGHTER_PROMPT="${sfd_status}"
	fi
	unset sfd_pwd sfd_prefix sfd_status
}

case " ${STARFIGHTER_DEBUG} " in
*" dir "*)
	starfighter_dir
	echo "${STARFIGHTER_PROMPT}"
	;;
esac

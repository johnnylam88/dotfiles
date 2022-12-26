# steamship/git.sh

: ${STEAMSHIP_GIT_SHOW:='true'}
: ${STEAMSHIP_GIT_PREFIX:='on '}
: ${STEAMSHIP_GIT_SUFFIX:=${STEAMSHIP_SUFFIX_DEFAULT}}

# Dependencies
: ${STEAMSHIP_ROOT:=${HOME}/.config/shell/steamship}
if [ -f "${STEAMSHIP_ROOT}/git_branch.sh" ]; then
	. "${STEAMSHIP_ROOT}/git_branch.sh"
fi
if [ -f "${STEAMSHIP_ROOT}/git_status.sh" ]; then
	. "${STEAMSHIP_ROOT}/git_status.sh"
fi

steamship_git() {
	ssg_git_branch=$(steamship_git_branch)
	ssg_git_status=
	if [ -n "${ssg_git_branch}" ]; then
		ssg_git_status=$(steamship_git_status ${ssg_git_branch})
	fi

	ssg_status="${ssg_git_branch}${ssg_git_status}"
	if [ -n "${ssg_status}" ]; then
		if [ "${1}" = "-p" ]; then
			# Add prefix if requested with '-p'.
			ssg_status="${STEAMSHIP_GIT_PREFIX}${ssg_status}"
		fi
		ssg_status="${ssg_status}${STEAMSHIP_GIT_SUFFIX}"
	fi
	echo "${ssg_status}"
	unset ssg_git_branch ssg_git_status ssg_status
}

steamship_git_prompt() {
	[ "${STEAMSHIP_GIT_SHOW}" = false ] && return

	# Only some shells support command substitution in the shell prompt.
	[ -z "${BASH_VERSION}${KSH_VERSION}${ZSH_VERSION}" ] && return

	# Append status to ${STEAMSHIP_PROMPT}.
	if [ -n "${STEAMSHIP_PROMPT}" ]; then
		STEAMSHIP_PROMPT="${STEAMSHIP_PROMPT}"'$(steamship_git -p)'
	else
		STEAMSHIP_PROMPT='$(steamship_git)'
	fi
}

case " ${STEAMSHIP_DEBUG} " in
*" git "*)
	echo "$(steamship_git)"
	steamship_git_prompt
	echo "${STEAMSHIP_PROMPT}"
	;;
esac

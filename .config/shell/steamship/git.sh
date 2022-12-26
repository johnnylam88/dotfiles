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

steamship_git_helper() {
	ssgh_git_branch=$(steamship_git_branch)
	ssgh_git_status=
	if [ -n "${ssgh_git_branch}" ]; then
		ssgh_git_status=$(steamship_git_status ${ssgh_git_branch})
	fi

	ssgh_status="${ssgh_git_branch}${ssgh_git_status}"
	if [ -n "${ssgh_status}" ]; then
		if [ "${1}" = "-p" ]; then
			# Add prefix if requested with '-p'.
			ssgh_status="${STEAMSHIP_GIT_PREFIX}${ssgh_status}"
		fi
		ssgh_status="${ssgh_status}${STEAMSHIP_GIT_SUFFIX}"
	fi
	echo "${ssgh_status}"
	unset ssgh_git_branch ssgh_git_status ssgh_status
}

steamship_git() {
	[ "${STEAMSHIP_GIT_SHOW}" = false ] && return

	# Only some shells support command substitution in the shell prompt.
	[ -z "${BASH_VERSION}${KSH_VERSION}${ZSH_VERSION}" ] && return

	# Append status to ${STEAMSHIP_PROMPT}.
	if [ -n "${STEAMSHIP_PROMPT}" ]; then
		STEAMSHIP_PROMPT="${STEAMSHIP_PROMPT}"'$(steamship_git_helper -p)'
	else
		STEAMSHIP_PROMPT="${STEAMSHIP_PROMPT}"'$(steamship_git_helper)'
	fi
}

case " ${STEAMSHIP_DEBUG} " in
*" git "*)
	steamship_git
	steamship_git_helper
	echo "${STEAMSHIP_PROMPT}"
	;;
esac

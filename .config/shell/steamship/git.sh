# shellcheck shell=sh
# steamship/git.sh

: "${STEAMSHIP_GIT_SHOW:="true"}"
: "${STEAMSHIP_GIT_PREFIX:="on "}"
: "${STEAMSHIP_GIT_SUFFIX:=${STEAMSHIP_SUFFIX_DEFAULT}}"

# Dependencies
: "${STEAMSHIP_ROOT:="${HOME}/.config/shell/steamship"}"
. "${STEAMSHIP_ROOT}/git_branch.sh"
. "${STEAMSHIP_ROOT}/git_status.sh"

steamship_git() {
	ssg_git_branch=$(steamship_git_branch)
	ssg_git_status=
	if [ -n "${ssg_git_branch}" ]; then
		ssg_git_status=$(steamship_git_status)
	fi

	ssg_status="${ssg_git_branch}${ssg_git_status}"
	if [ -n "${ssg_status}" ]; then
		if [ "${1}" = '-p' ]; then
			ssg_status="${STEAMSHIP_GIT_PREFIX}${ssg_status}"
		fi
		ssg_status="${ssg_status}${STEAMSHIP_GIT_SUFFIX}"
	fi

	echo "${ssg_status}"
	unset ssg_git_branch ssg_git_status ssg_status
}

steamship_git_prompt() {
	[ "${STEAMSHIP_PROMPT_COMMAND_SUBST}" = true ] || return
	[ "${STEAMSHIP_GIT_SHOW}" = true ] || return

	# Append status to ${STEAMSHIP_PROMPT}.
	if [ -n "${STEAMSHIP_PROMPT}" ]; then
		# shellcheck disable=SC2016
		STEAMSHIP_PROMPT="${STEAMSHIP_PROMPT}"'$(steamship_git -p)'
	else
		# shellcheck disable=SC2016
		STEAMSHIP_PROMPT='$(steamship_git)'
	fi
}

case " ${STEAMSHIP_DEBUG} " in
*" git "*)
	steamship_git -p
	steamship_git_prompt
	echo "${STEAMSHIP_PROMPT}"
	;;
esac

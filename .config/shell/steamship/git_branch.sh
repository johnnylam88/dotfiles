# steamship/git_branch.sh

: ${STEAMSHIP_GIT_BRANCH_SHOW:='true'}
: ${STEAMSHIP_GIT_BRANCH_PREFIX:=' '}}
: ${STEAMSHIP_GIT_BRANCH_SUFFIX:=''}
: ${STEAMSHIP_GIT_BRANCH_COLOR:='MAGENTA'}

steamship_git_branch_name() {
	command git branch --show-current 2>/dev/null
}

steamship_git_branch() {
	[ "${STEAMSHIP_GIT_BRANCH_SHOW}" = false ] && return

	ssgb_branch=$(steamship_git_branch_name)

	ssgb_colorvar="STEAMSHIP_${STEAMSHIP_GIT_BRANCH_COLOR}"
	eval 'ssgb_color=${'${ssgb_colorvar}'}'
	unset ssgb_colorvar

	ssgb_status=${ssgb_branch}
	if [ -n "${ssgb_status}" ]; then
		# Add prefix and suffix as part of the status.
		ssgb_status="${STEAMSHIP_GIT_BRANCH_PREFIX}${ssgb_status}"
		ssgb_status="${ssgb_status}${STEAMSHIP_GIT_BRANCH_SUFFIX}"
		# Colorize the entire status.
		ssgb_status="${ssgb_color}${ssgb_status}${STEAMSHIP_WHITE}"
	fi
	echo "${ssgb_status}"
	unset ssgb_branch ssgb_status ssgb_color
}

case " ${STEAMSHIP_DEBUG} " in
*" git_branch "*)
	echo "$(steamship_git_branch)"
	;;
esac

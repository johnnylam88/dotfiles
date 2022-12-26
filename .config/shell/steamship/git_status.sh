# steamship/git_status.sh

: ${STEAMSHIP_GIT_STATUS_SHOW:='true'}
: ${STEAMSHIP_GIT_STATUS_PREFIX:=' ['}
: ${STEAMSHIP_GIT_STATUS_SUFFIX:=']'}
: ${STEAMSHIP_GIT_STATUS_COLOR:='RED'}
: ${STEAMSHIP_GIT_STATUS_UNTRACKED:='?'}
: ${STEAMSHIP_GIT_STATUS_ADDED:='+'}
: ${STEAMSHIP_GIT_STATUS_MODIFIED:='!'}
: ${STEAMSHIP_GIT_STATUS_RENAMED:='»'}
: ${STEAMSHIP_GIT_STATUS_DELETED:='✘'}
: ${STEAMSHIP_GIT_STATUS_STASHED:='$'}
: ${STEAMSHIP_GIT_STATUS_UNMERGED:='='}
: ${STEAMSHIP_GIT_STATUS_AHEAD:='⇡'}
: ${STEAMSHIP_GIT_STATUS_BEHIND:='⇣'}
: ${STEAMSHIP_GIT_STATUS_DIVERGED:='⇕'}

steamship_git_status() {
	[ "${STEAMSHIP_GIT_STATUS_SHOW}" = true ] || return

	# Get the branch state by parsing the output from `git status --porcelain`.
	# This is mostly just copied from git_status.zsh from spaceship-prompt.

	# This is pretty inefficient as it forks many processes to parse the
	# output for each bit of the state. It can probably be rewritten into
	# an `awk` program to read the input once and output a bitstate of
	# the branch state.

	# Get the working tree status in *porcelain* format.
	ssgs_output=$(command git status --porcelain -b 2>/dev/null)
	ssgs_state=
	if [ -n "${ssgs_output}" ]; then
		# Check for untracked files.
		if $(echo "${ssgs_output}" | command grep -E '^\?\? ' &> /dev/null); then
			ssgs_state="${STEAMSHIP_GIT_STATUS_UNTRACKED}${ssgs_state}"
		fi
		# Check for staged files.
		if $(echo "${ssgs_output}" | command grep '^A[ MDAU] ' &> /dev/null); then
			ssgs_state="${STEAMSHIP_GIT_STATUS_ADDED}${ssgs_state}"
		elif $(echo "${ssgs_output}" | command grep '^M[ MD] ' &> /dev/null); then
			ssgs_state="${STEAMSHIP_GIT_STATUS_ADDED}${ssgs_state}"
		elif $(echo "${ssgs_output}" | command grep '^UA' &> /dev/null); then
			ssgs_state="${STEAMSHIP_GIT_STATUS_ADDED}${ssgs_state}"
		fi
		# Check for modified files.
		if $(echo "${ssgs_output}" | command grep '^[ MARC]M ' &> /dev/null); then
			ssgs_state="${STEAMSHIP_GIT_STATUS_MODIFIED}$ssgs_state"
		fi
		# Check for renamed files.
		if $(echo "${ssgs_output}" | command grep '^R[ MD] ' &> /dev/null); then
			ssgs_state="${STEAMSHIP_GIT_STATUS_RENAMED}${ssgs_state}"
		fi
		# Check for deleted files.
		if $(echo "${ssgs_output}" | command grep '^[MARCDU ]D ' &> /dev/null); then
			ssgs_state="${STEAMSHIP_GIT_STATUS_DELETED}${ssgs_state}"
		elif $(echo "${ssgs_output}" | command grep '^D[ UM] ' &> /dev/null); then
			ssgs_state="${STEAMSHIP_GIT_STATUS_DELETED}${ssgs_state}"
		fi
		# Check for stashes.
		if $(command git rev-parse --verify refs/stash >/dev/null 2>&1); then
			ssgs_state="${STEAMSHIP_GIT_STATUS_STASHED}${ssgs_state}"
		fi
		# Check for unmerged files.
		if $(echo "${ssgs_output}" | command grep '^U[UDA] ' &> /dev/null); then
			ssgs_state="${STEAMSHIP_GIT_STATUS_UNMERGED}${ssgs_state}"
		elif $(echo "${ssgs_output}" | command grep '^AA ' &> /dev/null); then
			ssgs_state="${STEAMSHIP_GIT_STATUS_UNMERGED}${ssgs_state}"
		elif $(echo "${ssgs_output}" | command grep '^DD ' &> /dev/null); then
			ssgs_state="${STEAMSHIP_GIT_STATUS_UNMERGED}${ssgs_state}"
		elif $(echo "${ssgs_output}" | command grep '^[DA]U ' &> /dev/null); then
			ssgs_state="${STEAMSHIP_GIT_STATUS_UNMERGED}${ssgs_state}"
		fi
		# Check wheather branch has diverged.
		# The branch name is passed into the function as the 1st param.
		ssgs_branch=${1:-$(command git branch --show-current 2>/dev/null)}
		ssgs_ahead=$(command git rev-list --count ${ssgs_branch}@{upstream}..HEAD 2>/dev/null)
		ssgs_behind=$(command git rev-list --count HEAD..${ssgs_branch}@{upstream} 2>/dev/null)
		: ${ssgs_ahead:=0}
		: ${ssgs_behind:=0}
		if [ ${ssgs_ahead} -gt 0 ] && [ ${ssgs_behind} -gt 0 ]; then
			ssgs_state="${STEAMSHIP_GIT_STATUS_DIVERGED}${ssgs_state}"
		elif [ ${ssgs_ahead} -gt 0 ]; then
			ssgs_state="${STEAMSHIP_GIT_STATUS_AHEAD}${ssgs_state}"
		elif [ ${ssgs_behind} -gt 0 ]; then
			ssgs_state="${STEAMSHIP_GIT_STATUS_BEHIND}${ssgs_state}"
		fi
		unset ssgs_branch ssgs_ahead ssgs_behind
	fi

	ssgs_colorvar="STEAMSHIP_${STEAMSHIP_GIT_STATUS_COLOR}"
	eval 'ssgs_color=${'${ssgs_colorvar}'}'
	unset ssgs_colorvar

	ssgs_status=${ssgs_state}
	if [ -n "${ssgs_status}" ]; then
		# Add prefix and suffix as part of the status.
		ssgs_status="${STEAMSHIP_GIT_STATUS_PREFIX}${ssgs_status}"
		ssgs_status="${ssgs_status}${STEAMSHIP_GIT_STATUS_SUFFIX}"
		# Colorize the entire status.
		ssgs_status="${ssgs_color}${ssgs_status}${STEAMSHIP_WHITE}"
	fi
	echo "${ssgs_status}"
	unset ssgs_state ssgs_status ssgs_color
}

case " ${STEAMSHIP_DEBUG} " in
*" git_status "*)
	echo "$(steamship_git_status $(command git branch --show-current 2>/dev/null))"
	;;
esac

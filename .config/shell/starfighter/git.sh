# starfighter/git.sh

: ${STARFIGHTER_GIT_SHOW:=true}

sf_git_branch_name() {
	command git branch --show-current 2>/dev/null
}

sf_git_branch_state() {
	# Get the branch state by parsing the output from `git status --porcelain`.
	# This is mostly just copied from git_status.zsh from spaceship-prompt.

	# This is pretty inefficient as it forks many processes to parse the
	# output for each bit of the state. It can probably be rewritten into
	# an `awk` program to read the input once and output a bitstate of
	# the branch state.

	# Get the working tree status in *porcelain* format.
	sfgbs_output=$(command git status --porcelain -b 2>/dev/null)
	sfgbs_state=
	if [ -n "${sfgbs_output}" ]; then
		sfgbs_untracked="?"
		sfgbs_added="+"
		sfgbs_modified="!"
		sfgbs_renamed="»"
		sfgbs_deleted="✘"
		sfgbs_stashed="$"
		sfgbs_unmerged="="
		sfgbs_ahead="⇡"
		sfgbs_behind="⇣"
		sfgbs_diverged="⇕"

		# Check for untracked files.
		if $(echo "${sfgbs_output}" | command grep -E '^\?\? ' &> /dev/null); then
			sfgbs_state="${sfgbs_untracked}${sfgbs_state}"
		fi
		# Check for staged files.
		if $(echo "${sfgbs_output}" | command grep '^A[ MDAU] ' &> /dev/null); then
			sfgbs_state="${sfgbs_added}${sfgbs_state}"
		elif $(echo "${sfgbs_output}" | command grep '^M[ MD] ' &> /dev/null); then
			sfgbs_state="${sfgbs_added}${sfgbs_state}"
		elif $(echo "${sfgbs_output}" | command grep '^UA' &> /dev/null); then
			sfgbs_state="${sfgbs_added}${sfgbs_state}"
		fi
		# Check for modified files.
		if $(echo "${sfgbs_output}" | command grep '^[ MARC]M ' &> /dev/null); then
			sfgbs_state="${sfgbs_modified}$sfgbs_state"
		fi
		# Check for renamed files.
		if $(echo "${sfgbs_output}" | command grep '^R[ MD] ' &> /dev/null); then
			sfgbs_state="${sfgbs_renamed}${sfgbs_state}"
		fi
		# Check for deleted files.
		if $(echo "${sfgbs_output}" | command grep '^[MARCDU ]D ' &> /dev/null); then
			sfgbs_state="${sfgbs_deleted}${sfgbs_state}"
		elif $(echo "${sfgbs_output}" | command grep '^D[ UM] ' &> /dev/null); then
			sfgbs_state="${sfgbs_deleted}${sfgbs_state}"
		fi
		# Check for stashes.
		if $(command git rev-parse --verify refs/stash >/dev/null 2>&1); then
			sfgbs_state="${sfgbs_stashed}${sfgbs_state}"
		fi
		# Check for unmerged files.
		if $(echo "${sfgbs_output}" | command grep '^U[UDA] ' &> /dev/null); then
			sfgbs_state="${sfgbs_unmerged}${sfgbs_state}"
		elif $(echo "${sfgbs_output}" | command grep '^AA ' &> /dev/null); then
			sfgbs_state="${sfgbs_unmerged}${sfgbs_state}"
		elif $(echo "${sfgbs_output}" | command grep '^DD ' &> /dev/null); then
			sfgbs_state="${sfgbs_unmerged}${sfgbs_state}"
		elif $(echo "${sfgbs_output}" | command grep '^[DA]U ' &> /dev/null); then
			sfgbs_state="${sfgbs_unmerged}${sfgbs_state}"
		fi
		# Check wheather branch has diverged.
		sfgbs_branch=$(sf_git_branch_name)
		sfgbs_ahead=$(command git rev-list --count ${sfgbs_branch}@{upstream}..HEAD 2>/dev/null)
		sfgbs_behind=$(command git rev-list --count HEAD..${sfgbs_branch}@{upstream} 2>/dev/null)
		: ${sfgbs_ahead:=0}
		: ${sfgbs_behind:=0}
		if [ ${sfgbs_ahead} -gt 0 ] && [ ${sfgbs_behind} -gt 0 ]; then
			sfgbs_state="${sfgbs_diverged}${sfgbs_state}"
		elif [ ${sfgbs_ahead} -gt 0 ]; then
			sfgbs_state="${sfgbs_ahead}${sfgbs_state}"
		elif [ ${sfgbs_behind} -gt 0 ]; then
			sfgbs_state="${sfgbs_behind}${sfgbs_state}"
		fi

		unset sfgbs_untracked sfgbs_added sfgbs_modified sfgbs_renamed
		unset sfgbs_deleted sfgbs_stashed sfgbs_unmerged sfgbs_ahead
		unset sfgbs_behind sfgbs_diverged
	fi
	echo "${sfgbs_state}"
	unset sfgbs_output sfgbs_state
}

starfighter_git_helper() {
	sfgs_branch=$(sf_git_branch_name)
	sfgs_state=
	sfgs_prefix=
	sfgs_status=
	if [ -n "${sfgs_branch}" ]; then
		if [ "${1}" == "-p" ]; then
			# Add prefix if requested with '-p'.
			sfgs_prefix=" ${STARFIGHTER_WHITE}on${STARFIGHTER_NORMAL}"
		fi
		sfgs_status=" ${STARFIGHTER_MAGENTA} ${sfgs_branch}${STARFIGHTER_NORMAL}"
		sfgs_state=$(sf_git_branch_state)
		if [ -n "${sfgs_state}" ]; then
			sfgs_status="${sfgs_status} ${STARFIGHTER_RED}[${sfgs_state}]${STARFIGHTER_NORMAL}"
		fi
	fi
	echo "${sfgs_prefix}${sfgs_status}"
	unset sfgs_branch sfgs_state sfgs_prefix sfgs_status
}

starfighter_git() {
	[ "${STARFIGHTER_GIT_SHOW}" = false ] && return

	# Only some shells support command substitution in the shell prompt.
	[ -z "${BASH_VERSION}${KSH_VERSION}${ZSH_VERSION}" ] && return

	# Append status to ${STARFIGHTER_PROMPT}.
	if [ -n "${STARFIGHTER_PROMPT}" ]; then
		STARFIGHTER_PROMPT="${STARFIGHTER_PROMPT}"'$(starfighter_git_helper -p)'
	else
		STARFIGHTER_PROMPT="${STARFIGHTER_PROMPT}"'$(starfighter_git_helper)'
	fi
}

case " ${STARFIGHTER_DEBUG} " in
*" git "*)
	starfighter_git
	starfighter_git_helper
	echo "${STARFIGHTER_PROMPT}"
	;;
esac

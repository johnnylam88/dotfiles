# spaceship-lite-git.sh

ss_git_branch_name() {
	command git branch --show-current 2>/dev/null
}

ss_git_branch_state() {
	# Get the branch state by parsing the output from `git status --porcelain`.
	# This is mostly just copied from git_status.zsh from spaceship-prompt.

	# This is pretty inefficient as it forks many processes to parse the
	# output for each bit of the state. It can probably be rewritten into
	# an `awk` program to read the input once and output a bitstate of
	# the branch state.

	# Get the working tree status in *porcelain* format.
	ssgbs_output=$(command git status --porcelain -b 2>/dev/null)
	ssgbs_state=
	if [ -n "${ssgbs_output}" ]; then
		ssgbs_untracked="?"
		ssgbs_added="+"
		ssgbs_modified="!"
		ssgbs_renamed="»"
		ssgbs_deleted="✘"
		ssgbs_stashed="$"
		ssgbs_unmerged="="
		ssgbs_ahead="⇡"
		ssgbs_behind="⇣"
		ssgbs_diverged="⇕"

		# Check for untracked files.
		if $(echo "${ssgbs_output}" | command grep -E '^\?\? ' &> /dev/null); then
			ssgbs_state="${ssgbs_untracked}${ssgbs_state}"
		fi
		# Check for staged files.
		if $(echo "${ssgbs_output}" | command grep '^A[ MDAU] ' &> /dev/null); then
			ssgbs_state="${ssgbs_added}${ssgbs_state}"
		elif $(echo "${ssgbs_output}" | command grep '^M[ MD] ' &> /dev/null); then
			ssgbs_state="${ssgbs_added}${ssgbs_state}"
		elif $(echo "${ssgbs_output}" | command grep '^UA' &> /dev/null); then
			ssgbs_state="${ssgbs_added}${ssgbs_state}"
		fi
		# Check for modified files.
		if $(echo "${ssgbs_output}" | command grep '^[ MARC]M ' &> /dev/null); then
			ssgbs_state="${ssgbs_modified}$ssgbs_state"
		fi
		# Check for renamed files.
		if $(echo "${ssgbs_output}" | command grep '^R[ MD] ' &> /dev/null); then
			ssgbs_state="${ssgbs_renamed}${ssgbs_state}"
		fi
		# Check for deleted files.
		if $(echo "${ssgbs_output}" | command grep '^[MARCDU ]D ' &> /dev/null); then
			ssgbs_state="${ssgbs_deleted}${ssgbs_state}"
		elif $(echo "${ssgbs_output}" | command grep '^D[ UM] ' &> /dev/null); then
			ssgbs_state="${ssgbs_deleted}${ssgbs_state}"
		fi
		# Check for stashes.
		if $(command git rev-parse --verify refs/stash >/dev/null 2>&1); then
			ssgbs_state="${ssgbs_stashed}${ssgbs_state}"
		fi
		# Check for unmerged files.
		if $(echo "${ssgbs_output}" | command grep '^U[UDA] ' &> /dev/null); then
			ssgbs_state="${ssgbs_unmerged}${ssgbs_state}"
		elif $(echo "${ssgbs_output}" | command grep '^AA ' &> /dev/null); then
			ssgbs_state="${ssgbs_unmerged}${ssgbs_state}"
		elif $(echo "${ssgbs_output}" | command grep '^DD ' &> /dev/null); then
			ssgbs_state="${ssgbs_unmerged}${ssgbs_state}"
		elif $(echo "${ssgbs_output}" | command grep '^[DA]U ' &> /dev/null); then
			ssgbs_state="${ssgbs_unmerged}${ssgbs_state}"
		fi
		# Check wheather branch has diverged.
		ssgbs_branch=$(ss_git_branch_name)
		ssgbs_ahead=$(command git rev-list --count ${ssgbs_branch}@{upstream}..HEAD 2>/dev/null)
		ssgbs_behind=$(command git rev-list --count HEAD..${ssgbs_branch}@{upstream} 2>/dev/null)
		: ${ssgbs_ahead:=0}
		: ${ssgbs_behind:=0}
		if [ ${ssgbs_ahead} -gt 0 ] && [ ${ssgbs_behind} -gt 0 ]; then
			ssgbs_state="${ssgbs_diverged}${ssgbs_state}"
		elif [ ${ssgbs_ahead} -gt 0 ]; then
			ssgbs_state="${ssgbs_ahead}${ssgbs_state}"
		elif [ ${ssgbs_behind} -gt 0 ]; then
			ssgbs_state="${ssgbs_behind}${ssgbs_state}"
		fi

		unset ssgbs_untracked ssgbs_added ssgbs_modified ssgbs_renamed
		unset ssgbs_deleted ssgbs_stashed ssgbs_unmerged ssgbs_ahead
		unset ssgbs_behind ssgbs_diverged
	fi
	echo "${ssgbs_state}"
	unset ssgbs_output ssgbs_state
}

spaceship_lite_prompt_git() {
	sslpg_prompt=
	sslpg_branch=$(ss_git_branch_name)
	if [ -n "${sslpg_branch}" ]; then
		sslpg_prompt="${sslpg_prompt} ${SS_ESC_WHITE}on${SS_ESC_NORMAL}"
		sslpg_prompt="${sslpg_prompt} ${SS_ESC_PURPLE} ${sslpg_branch}${SS_ESC_NORMAL}"
		sslpg_state=$(ss_git_branch_state)
		if [ -n "${sslpg_state}" ]; then
			sslpg_prompt="${sslpg_prompt} ${SS_ESC_RED}[${sslpg_state}]${SS_ESC_NORMAL}"
		fi
		unset sslpg_state
	fi
	echo "${sslpg_prompt}"
	unset sslpg_prompt sslpg_branch
}

SPACESHIP_LITE_PROMPT_GIT='$(spaceship_lite_prompt_git)'

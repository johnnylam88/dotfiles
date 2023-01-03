# shellcheck shell=sh
# steamship/modules/precmd.sh

case " ${STEAMSHIP_MODULES_SOURCED} " in *" precmd "*) return ;; esac

steamship_precmd_init() {
	steamship_precmd_hooks=
}

steamship_precmd_run_hooks() {
	if [ -n "${steamship_precmd_hooks}" ]; then
		for ssprh_hook_fn in ${steamship_precmd_hooks}; do
			eval "${ssprh_hook_fn}"
		done
		unset ssprh_hook_fn
	fi
}

steamship_precmd_add_hook() {
	sspah_hook_fn=${1}
	if [ -n "${sspah_hook_fn}" ]; then
		if [ -z "${steamship_precmd_hooks}" ]; then
			steamship_precmd_hooks=${sspah_hook_fn}
		else
			steamship_precmd_hooks="${steamship_precmd_hooks} ${sspah_hook_fn}"
		fi
	fi
}

steamship_precmd_prompt() {
	[ "${STEAMSHIP_PROMPT_COMMAND_SUBST}" = true ] || return

	# shellcheck disable=SC2089,SC2016
	sspp_prefix='$(STEAMSHIP_RETVAL=$?; steamship_precmd_run_hooks; echo "'
	sspp_suffix='")'
	sspp_prompt="${sspp_prefix}${STEAMSHIP_PROMPT_PS1}${sspp_suffix}"
	STEAMSHIP_PROMPT_PS1=${sspp_prompt}

	unset sspp_prefix sspp_suffix sspp_prompt
}

STEAMSHIP_MODULES_SOURCED="${STEAMSHIP_MODULES_SOURCED} precmd"

case " ${STEAMSHIP_DEBUG} " in
*" precmd "*)
	export STEAMSHIP_PROMPT_COMMAND_SUBST=true
	# shellcheck disable=SC2090
	export STEAMSHIP_PROMPT_PS1='$ '
	steamship_precmd_init
	steamship_precmd_prompt
	echo "${STEAMSHIP_PROMPT_PS1}"
	;;
esac

# shellcheck shell=sh
# steamship/modules/precmd.sh

case " ${STEAMSHIP_MODULES_SOURCED} " in *" precmd "*) return ;; esac

steamship_precmd_init() {
	: "do nothing"
}

steamship_precmd_prompt() {
	[ "${STEAMSHIP_PROMPT_COMMAND_SUBST}" = true ] || return

	# shellcheck disable=SC2089,SC2016
	sspp_prefix='$(STEAMSHIP_RETVAL=$? && echo "'
	sspp_suffix='")'
	sspp_prompt="${sspp_prefix}${STEAMSHIP_PROMPT}${sspp_suffix}"
	STEAMSHIP_PROMPT=${sspp_prompt}

	unset sspp_prefix sspp_suffix sspp_prompt
}

STEAMSHIP_MODULES_SOURCED="${STEAMSHIP_MODULES_SOURCED} precmd"

case " ${STEAMSHIP_DEBUG} " in
*" precmd "*)
	export STEAMSHIP_PROMPT_COMMAND_SUBST=true
	# shellcheck disable=SC2090
	export STEAMSHIP_PROMPT='$ '
	steamship_precmd_init
	steamship_precmd_prompt
	echo "${STEAMSHIP_PROMPT}"
	;;
esac

# steamship/precmd.sh

steamship_precmd_prompt() {
	[ -z "${STEAMSHIP_PROMPT_HAS_COMMAND_SUBST}" ] && return

	sspp_prefix='$(STEAMSHIP_RETVAL=$? && echo "'
	sspp_suffix='")'
	sspp_prompt="${sspp_prefix}${STEAMSHIP_PROMPT}${sspp_suffix}"
	STEAMSHIP_PROMPT=${sspp_prompt}
	unset sspp_prefix sspp_suffix sspp_prompt
}

case " ${STEAMSHIP_DEBUG} " in
*" precmd "*)
	export STEAMSHIP_PROMPT_HAS_COMMAND_SUBST=true
	export STEAMSHIP_PROMPT='$ '
	steamship_precmd_prompt
	echo "${STEAMSHIP_PROMPT}"
	;;
esac

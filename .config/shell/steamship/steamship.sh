# steamship/steamship.sh

# Path to steamship main directory.
: ${STEAMSHIP_ROOT:=${HOME}/.config/shell/steamship}

# Order of sections show in the shell prompt.
STEAMSHIP_PROMPT_ORDER_DEFAULT='
	user
	dir
	host
	git
	container
'

# Global variables to be used by other modules.
STEAMSHIP_NEWLINE='
'
STEAMSHIP_PROMPT=
STEAMSHIP_PROMPT_HAS_COMMAND_SUBST=

: ${STEAMSHIP_PROMPT_ORDER=${STEAMSHIP_PROMPT_ORDER_DEFAULT}}
: ${STEAMSHIP_PREFIX_DEFAULT='via '}
: ${STEAMSHIP_SUFFIX_DEFAULT=' '}

#######################################
# Initialization

steamship_init() {
	if [ -n "${BASH_VERSION}${KSH_VERSION}${ZSH_VERSION}" ]; then
		STEAMSHIP_PROMPT_HAS_COMMAND_SUBST=true
	fi
}

steamship_init

# Load modules in the correct order. `nonprintable` needs to be loaded
# first as it defines variables used by `colors`, which needs to be
# loaded next as it defines the color variables used by the other
# modules.
STEAMSHIP_MODULE_ORDER='
	nonprintable
	colors
	character
	container
	delimiter
	dir
	git
	host
	user
'

if [ -n "${STEAMSHIP_MODULE_ORDER}" ]; then
	for steamship_module in ${STEAMSHIP_MODULE_ORDER}; do
		steamship_module_file="${STEAMSHIP_ROOT}/${steamship_module}.sh"
		if [ -f "${steamship_module_file}" ]; then
			. "${steamship_module_file}"
		fi
	done
	unset steamship_module steamship_module_file
fi

steamship_prompt() {
	ssi_order=${STEAMSHIP_PROMPT_ORDER}

	# Prepend the special delimiter module to the prompt.
	ssi_order="${ssi_order} delimiter"

	# Append the special character module to the prompt.
	ssi_order="${ssi_order} character"

	# Final fix-ups for non-printable characters.
	ssi_order="${ssi_order} nonprintable"

	for ssi_section in ${ssi_order}; do
		ssi_section_prompt_fn="steamship_${ssi_section}_prompt"
		eval ${ssi_section_prompt_fn} 2>/dev/null
	done
	unset ssi_section ssi_section_prompt_fn
}

steamship() {
	case ${1} in
	init)
		echo 'PS1=${STEAMSHIP_PROMPT}'
		;;
	*)
		echo 1>&2 "steamship: unknown command \`${1}'"
		return 1
		;;
	esac
}

steamship_prompt

case " ${STEAMSHIP_DEBUG} " in
*" steamship "*)
	echo "${STEAMSHIP_PROMPT}"
	;;
esac

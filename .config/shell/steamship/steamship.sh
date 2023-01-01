# shellcheck shell=sh
# steamship/steamship.sh

# Path to steamship main directory.
: "${STEAMSHIP_ROOT:="${HOME}/.config/shell/steamship"}"

# Order of sections show in the shell prompt.
STEAMSHIP_PROMPT_ORDER_DEFAULT='
	user
	dir
	host
	git
	container
	line_separator
	exit_code
	character
'

# Global variables to be used by other modules.
STEAMSHIP_PROMPT=
STEAMSHIP_PROMPT_PARAM_EXPANSION=
STEAMSHIP_PROMPT_COMMAND_SUBST=

: "${STEAMSHIP_PROMPT_ORDER=${STEAMSHIP_PROMPT_ORDER_DEFAULT}}"

# Default prefix and suffix for sections.
: "${STEAMSHIP_PREFIX_DEFAULT="via "}"
: "${STEAMSHIP_SUFFIX_DEFAULT=" "}"

# Success and failure colors.
: "${STEAMSHIP_COLOR_SUCCESS:="GREEN"}"
: "${STEAMSHIP_COLOR_FAILURE:="RED"}"

#######################################
# Initialization

steamship_init() {
	# POSIX shells will do variable expansion of prompt strings.
	STEAMSHIP_PROMPT_PARAM_EXPANSION='true'

	# The bash, ksh, and zsh shells will do command substitution in
	# prompt strings.
	if [ -n "${BASH_VERSION}${KSH_VERSION}${ZSH_VERSION}" ]; then
		STEAMSHIP_PROMPT_COMMAND_SUBST='true'
	fi

	# shellcheck disable=SC3044
	if [ -z "${BASH_VERSION}" ] || shopt -q promptvars; then
		: "do nothing"
	else
		# Bash has "promptvars" shell option turned off.
		STEAMSHIP_PROMPT_PARAM_EXPANSION=
		STEAMSHIP_PROMPT_COMMAND_SUBST=
	fi
	if [ -z "${KSH_VERSION}" ] || true; then
		: "do nothing"
	else
		# UNREACHABLE because ksh always does parameter expansion and
		# command substitution in prompt strings.
		: "do nothing"
	fi
	# shellcheck disable=SC3010
	if [ -z "${ZSH_VERSION}" ] || [[ -o PROMPT_SUBST ]]; then
		: "do nothing"
	else
		# Zsh has "PROMPT_SUBST" option turned off.
		STEAMSHIP_PROMPT_PARAM_EXPANSION=
		# shellcheck disable=SC2034
		STEAMSHIP_PROMPT_COMMAND_SUBST=
	fi
}

steamship_init

. "${STEAMSHIP_ROOT}/theme.sh"
. "${STEAMSHIP_ROOT}/config.sh"

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
	exit_code
	git
	host
	line_separator
	precmd
	prompt_newline
	user
'

if [ -n "${STEAMSHIP_MODULE_ORDER}" ]; then
	for steamship_module in ${STEAMSHIP_MODULE_ORDER}; do
		steamship_module_file="${STEAMSHIP_ROOT}/${steamship_module}.sh"
		# shellcheck disable=SC1090
		. "${steamship_module_file}"
	done
	unset steamship_module steamship_module_file
fi

steamship_prompt() {
	ssi_order=${STEAMSHIP_PROMPT_ORDER}

	# Prepend the special delimiter module to the prompt.
	ssi_order="${ssi_order} delimiter"

	# Prepend the newline module to the prompt.
	ssi_order="${ssi_order} prompt_newline"

	# Call the special precmd module to wrap the prompt in a command.
	ssi_order="${ssi_order} precmd"

	# Final fix-ups for non-printable characters.
	ssi_order="${ssi_order} nonprintable"

	# Execute each "*_prompt" function to progressively build
	# STEAMSHIP_PROMPT as a side-effect.

	STEAMSHIP_PROMPT=
	for ssi_section in ${ssi_order}; do
		ssi_section_prompt_fn="steamship_${ssi_section}_prompt"
		eval "${ssi_section_prompt_fn}" 2>/dev/null
	done
	unset ssi_order ssi_section ssi_section_prompt_fn
	# ${STEAMSHIP_PROMPT} contains the prompt string.
}

steamship_refresh() {
	steamship_prompt
	if [ "${STEAMSHIP_PROMPT_PARAM_EXPANSION}" = true ]; then
		eval "PS1='${STEAMSHIP_PROMPT}'"
	else
		eval "PS1=${STEAMSHIP_PROMPT}"
	fi
}

steamship() {
	case ${1} in
	refresh)
		steamship_refresh
		;;
	theme)
		shift
		steamship_theme "${@}"
		steamship_refresh
		;;
	esac
}

steamship refresh

case " ${STEAMSHIP_DEBUG} " in
*" steamship "*)
	echo "${STEAMSHIP_PROMPT}"
	;;
esac

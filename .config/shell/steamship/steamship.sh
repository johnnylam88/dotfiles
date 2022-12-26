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

: ${STEAMSHIP_PROMPT_ORDER=${STEAMSHIP_PROMPT_ORDER_DEFAULT}}
: ${STEAMSHIP_PREFIX_DEFAULT='via '}
: ${STEAMSHIP_SUFFIX_DEFAULT=' '}


if [ -f "${STEAMSHIP_ROOT}/nonprintable.sh" ]; then
	# nonprintable.sh needs to be loaded first as it defines
	# variables used by colors.sh.
	. "${STEAMSHIP_ROOT}/nonprintable.sh"
fi
if [ -f "${STEAMSHIP_ROOT}/colors.sh" ]; then
	# colors.sh needs to be loaded second as it defines variables
	# used by the other modules.
	. "${STEAMSHIP_ROOT}/colors.sh"
fi

if [ -f "${STEAMSHIP_ROOT}/character.sh" ]; then
	. "${STEAMSHIP_ROOT}/character.sh"
fi
if [ -f "${STEAMSHIP_ROOT}/container.sh" ]; then
	. "${STEAMSHIP_ROOT}/container.sh"
fi
if [ -f "${STEAMSHIP_ROOT}/dir.sh" ]; then
	. "${STEAMSHIP_ROOT}/dir.sh"
fi
if [ -f "${STEAMSHIP_ROOT}/git.sh" ]; then
	. "${STEAMSHIP_ROOT}/git.sh"
fi
if [ -f "${STEAMSHIP_ROOT}/host.sh" ]; then
	. "${STEAMSHIP_ROOT}/host.sh"
fi
if [ -f "${STEAMSHIP_ROOT}/delimiter.sh" ]; then
	. "${STEAMSHIP_ROOT}/delimiter.sh"
fi
if [ -f "${STEAMSHIP_ROOT}/user.sh" ]; then
	. "${STEAMSHIP_ROOT}/user.sh"
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

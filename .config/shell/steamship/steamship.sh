# steamship/steamship.sh

# Path to steamship main directory.
: ${STEAMSHIP_ROOT:=${HOME}/.config/shell/steamship}

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
if [ -f "${STEAMSHIP_ROOT}/prefix.sh" ]; then
	. "${STEAMSHIP_ROOT}/prefix.sh"
fi
if [ -f "${STEAMSHIP_ROOT}/user.sh" ]; then
	. "${STEAMSHIP_ROOT}/user.sh"
fi

# Global variable to be used by other modules.
STEAMSHIP_PROMPT=

steamship_init() {
	steamship_user
	steamship_dir
	steamship_host
	steamship_git
	steamship_container

	# Prepend the special prefix module to the prompt.
	steamship_prefix

	# Append the special character module to the prompt.
	steamship_character

	# Final fix-ups for non-printable characters.
	steamship_nonprintable
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

steamship_init

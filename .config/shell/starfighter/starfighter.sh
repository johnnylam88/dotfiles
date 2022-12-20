# starfighter.sh

# Path to starfighter main directory.
: ${STARFIGHTER_ROOT:=${HOME}/.config/shell/starfighter}

if [ -f "${STARFIGHTER_ROOT}/nonprintable.sh" ]; then
	# nonprintable.sh needs to be loaded first as it defines
	# variables used by colors.sh.
	. "${STARFIGHTER_ROOT}/nonprintable.sh"
fi
if [ -f "${STARFIGHTER_ROOT}/colors.sh" ]; then
	# colors.sh needs to be loaded second as it defines variables
	# used by the other modules.
	. "${STARFIGHTER_ROOT}/colors.sh"
fi

if [ -f "${STARFIGHTER_ROOT}/character.sh" ]; then
	. "${STARFIGHTER_ROOT}/character.sh"
fi
if [ -f "${STARFIGHTER_ROOT}/container.sh" ]; then
	. "${STARFIGHTER_ROOT}/container.sh"
fi
if [ -f "${STARFIGHTER_ROOT}/dir.sh" ]; then
	. "${STARFIGHTER_ROOT}/dir.sh"
fi
if [ -f "${STARFIGHTER_ROOT}/git.sh" ]; then
	. "${STARFIGHTER_ROOT}/git.sh"
fi
if [ -f "${STARFIGHTER_ROOT}/host.sh" ]; then
	. "${STARFIGHTER_ROOT}/host.sh"
fi
if [ -f "${STARFIGHTER_ROOT}/prefix.sh" ]; then
	. "${STARFIGHTER_ROOT}/prefix.sh"
fi
if [ -f "${STARFIGHTER_ROOT}/user.sh" ]; then
	. "${STARFIGHTER_ROOT}/user.sh"
fi

STARFIGHTER_PROMPT=

starfighter_main() {
	starfighter_user
	starfighter_dir
	starfighter_host
	starfighter_git
	starfighter_container

	# Prepend the special prefix module to the prompt.
	starfighter_prefix

	# Append the special character module to the prompt.
	starfighter_character

	# Final fix-ups for non-printable characters.
	starfighter_nonprintable
}

starfighter_main

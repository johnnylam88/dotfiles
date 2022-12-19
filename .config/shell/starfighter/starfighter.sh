# starfighter.sh

# Path to starfighter main directory.
: ${STARFIGHTER_ROOT:=${HOME}/.config/shell/starfighter}

if [ -f "${STARFIGHTER_ROOT}/colors.sh" ]; then
	# colors.sh needs to be loaded first as it defines variables
	# used by the other modules.
	. "${STARFIGHTER_ROOT}/colors.sh"
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

	# Add the header and footer to the prompt.
	STARFIGHTER_PROMPT='
┌'"${STARFIGHTER_PROMPT}"'
└ '
}

starfighter_main

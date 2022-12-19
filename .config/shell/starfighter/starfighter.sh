# starfighter.sh

# Path to starfighter main directory.
: ${STARFIGHTER_DIR:=${HOME}/.config/shell/starfighter}

if [ -f "${STARFIGHTER_DIR}/colors.sh" ]; then
	# colors.sh needs to be loaded first as it defines variables
	# used by the other modules.
	. "${STARFIGHTER_DIR}/colors.sh"
fi

if [ -f "${STARFIGHTER_DIR}/container.sh" ]; then
	. "${STARFIGHTER_DIR}/container.sh"
fi
if [ -f "${STARFIGHTER_DIR}/dir.sh" ]; then
	. "${STARFIGHTER_DIR}/dir.sh"
fi
if [ -f "${STARFIGHTER_DIR}/git.sh" ]; then
	. "${STARFIGHTER_DIR}/git.sh"
fi
if [ -f "${STARFIGHTER_DIR}/host.sh" ]; then
	. "${STARFIGHTER_DIR}/host.sh"
fi
if [ -f "${STARFIGHTER_DIR}/user.sh" ]; then
	. "${STARFIGHTER_DIR}/user.sh"
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

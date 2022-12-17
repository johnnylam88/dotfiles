# spaceship-lite.sh

# Path to Spaceship Lite main directory.
: ${SPACESHIP_LITE_DIR:=${HOME}/.config/shell/spaceship-lite}

if [ -f "${SPACESHIP_LITE_DIR}/colors.sh" ]; then
	# colors.sh needs to be loaded first as it defines variables
	# used by the other modules.
	. "${SPACESHIP_LITE_DIR}/colors.sh"
fi

if [ -f "${SPACESHIP_LITE_DIR}/container.sh" ]; then
	. "${SPACESHIP_LITE_DIR}/container.sh"
fi
if [ -f "${SPACESHIP_LITE_DIR}/dir.sh" ]; then
	. "${SPACESHIP_LITE_DIR}/dir.sh"
fi
if [ -f "${SPACESHIP_LITE_DIR}/git.sh" ]; then
	. "${SPACESHIP_LITE_DIR}/git.sh"
fi
if [ -f "${SPACESHIP_LITE_DIR}/host.sh" ]; then
	. "${SPACESHIP_LITE_DIR}/host.sh"
fi
if [ -f "${SPACESHIP_LITE_DIR}/user.sh" ]; then
	. "${SPACESHIP_LITE_DIR}/user.sh"
fi

SPACESHIP_LITE_PROMPT=

spaceship_lite_main() {
	spaceship_lite_prompt_user
	spaceship_lite_prompt_dir
	spaceship_lite_prompt_host
	spaceship_lite_prompt_git
	spaceship_lite_prompt_container

	# Add the header and footer to the prompt.
	SPACESHIP_LITE_PROMPT='
┌'"${SPACESHIP_LITE_PROMPT}"'
└ '
}

spaceship_lite_main

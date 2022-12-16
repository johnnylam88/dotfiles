# spaceship-lite.sh

# Path to Spaceship Lite main directory.
: ${SPACESHIP_LITE_DIR:=${HOME}/.config/shell/spaceship-lite}

if [ -f "${SPACESHIP_LITE_DIR}/colors.sh" ]; then
	# colors.sh needs to be loaded first as it defines variables
	# used by the other modules.
	. "${SPACESHIP_LITE_DIR}/colors.sh"
fi

SPACESHIP_LITE_PROMPT_CONTAINER=
SPACESHIP_LITE_PROMPT_DIR=
SPACESHIP_LITE_PROMPT_GIT=
SPACESHIP_LITE_PROMPT_HOST=
SPACESHIP_LITE_PROMPT_USER=

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

spaceship_lite_prompt() {
	# Start with a new line.
	sslp_prompt='
'
	sslp_prompt="${sslp_prompt}"'┌'

	sslp_prompt="${sslp_prompt}${SPACESHIP_LITE_PROMPT_USER}"
	sslp_prompt="${sslp_prompt}${SPACESHIP_LITE_PROMPT_DIR}"
	sslp_prompt="${sslp_prompt}${SPACESHIP_LITE_PROMPT_HOST}"
	sslp_prompt="${sslp_prompt}${SPACESHIP_LITE_PROMPT_GIT}"
	sslp_prompt="${sslp_prompt}${SPACESHIP_LITE_PROMPT_CONTAINER}"

	# Append a new line.
	sslp_prompt="${sslp_prompt}"'
'
	# Append a final prompt symbol.
	# NOTE: This should not contain any escape codes or else command-line
	#       editing may break.
	sslp_prompt="${sslp_prompt}"'└ '

	echo "${sslp_prompt}"
	unset sslp_prompt
}

SPACESHIP_LITE_PROMPT=$(spaceship_lite_prompt)

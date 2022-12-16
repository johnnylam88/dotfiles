# spaceship-lite.sh

# Path to Spaceship Lite main directory.
: ${SPACESHIP_LITE_DIR:=${HOME}/.config/shell/spaceship-lite}

# Global color variables to be used by Spaceship Lite modules.
if [ -n "${BASH_VERSION}${KSH_VERSION}${ZSH_VERSION}" ]; then
	SS_ESC_BLUE='[1;34m'
	SS_ESC_CYAN='[1;36m'
	SS_ESC_GRAY='[1;30m'
	SS_ESC_GREEN='[1;32m'
	SS_ESC_PURPLE='[1;35m'
	SS_ESC_RED='[1;31m'
	SS_ESC_WHITE='[1;37m'
	SS_ESC_YELLOW='[1;33m'
	SS_ESC_END='[m'
else
	SS_ESC_BLUE=
	SS_ESC_CYAN=
	SS_ESC_GRAY=
	SS_ESC_GREEN=
	SS_ESC_PURPLE=
	SS_ESC_RED=
	SS_ESC_WHITE=
	SS_ESC_YELLOW=
	SS_ESC_END=
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
if [ -f "${SPACESHIP_LITE_DIR}/spaceship-lite-git.sh" ]; then
	. "${SPACESHIP_LITE_DIR}/spaceship-lite-git.sh"
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
PS1="${SPACESHIP_LITE_PROMPT}"

# spaceship-lite-colors.sh

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

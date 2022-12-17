# spaceship-lite-colors.sh

# Global color variables to be used by Spaceship Lite modules.
SS_ESC_BLUE=
SS_ESC_CYAN=
SS_ESC_GRAY=
SS_ESC_GREEN=
SS_ESC_PURPLE=
SS_ESC_RED=
SS_ESC_WHITE=
SS_ESC_YELLOW=
SS_ESC_NORMAL=

if [ -t 1 ]; then
	ss_esc_bold=$(tput bold)
	if [ -n "${ss_esc_bold}" ]; then
		ss_ncolors=$(tput colors)
		if [ -n "${ss_ncolors}" ] && [ ${ss_ncolors} -ge 8 ]; then
			SS_ESC_BLUE=${ss_esc_bold}$(tput setaf 4)
			SS_ESC_CYAN=${ss_esc_bold}$(tput setaf 6)
			SS_ESC_GRAY=${ss_esc_bold}$(tput setaf 0)
			SS_ESC_GREEN=${ss_esc_bold}$(tput setaf 2)
			SS_ESC_PURPLE=${ss_esc_bold}$(tput setaf 5)
			SS_ESC_RED=${ss_esc_bold}$(tput setaf 1)
			SS_ESC_WHITE=${ss_esc_bold}$(tput setaf 7)
			SS_ESC_YELLOW=${ss_esc_bold}$(tput setaf 3)
			SS_ESC_NORMAL=$(tput sgr0)
		else
			SS_ESC_BLUE=${ss_esc_bold}
			SS_ESC_CYAN=${ss_esc_bold}
			SS_ESC_GRAY=${ss_esc_bold}
			SS_ESC_GREEN=${ss_esc_bold}
			SS_ESC_PURPLE=${ss_esc_bold}
			SS_ESC_RED=${ss_esc_bold}
			SS_ESC_WHITE=${ss_esc_bold}
			SS_ESC_YELLOW=${ss_esc_bold}
			SS_ESC_NORMAL=$(tput sgr0)
		fi
		unset ss_ncolors
	fi
	unset ss_esc_bold
fi

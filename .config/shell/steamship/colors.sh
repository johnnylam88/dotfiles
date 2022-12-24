# steamship/colors.sh

# Global color variables to be used by other modules.
STEAMSHIP_BLUE=
STEAMSHIP_CYAN=
STEAMSHIP_GRAY=
STEAMSHIP_GREEN=
STEAMSHIP_MAGENTA=
STEAMSHIP_RED=
STEAMSHIP_WHITE=
STEAMSHIP_YELLOW=
STEAMSHIP_NORMAL=

steamship_colors_init() {
	if [ -t 1 ]; then
		ssci_start=${STEAMSHIP_ESC_START}
		ssci_end=${STEAMSHIP_ESC_END}
		ssci_bold=$(tput bold)
		if [ -n "${ssci_bold}" ]; then
			ssci_ncolors=$(tput colors)
			if [ -n "${ssci_ncolors}" ] && [ ${ssci_ncolors} -ge 8 ]; then
				STEAMSHIP_BLUE=${ssci_start}${ssci_bold}$(tput setaf 4)${ssci_end}
				STEAMSHIP_CYAN=${ssci_start}${ssci_bold}$(tput setaf 6)${ssci_end}
				STEAMSHIP_GRAY=${ssci_start}${ssci_bold}$(tput setaf 0)${ssci_end}
				STEAMSHIP_GREEN=${ssci_start}${ssci_bold}$(tput setaf 2)${ssci_end}
				STEAMSHIP_MAGENTA=${ssci_start}${ssci_bold}$(tput setaf 5)${ssci_end}
				STEAMSHIP_RED=${ssci_start}${ssci_bold}$(tput setaf 1)${ssci_end}
				STEAMSHIP_WHITE=${ssci_start}${ssci_bold}$(tput setaf 7)${ssci_end}
				STEAMSHIP_YELLOW=${ssci_start}${ssci_bold}$(tput setaf 3)${ssci_end}
				STEAMSHIP_NORMAL=${ssci_start}$(tput sgr0)${ssci_end}
			else
				STEAMSHIP_BLUE=${ssci_start}${ssci_bold}${ssci_end}
				STEAMSHIP_CYAN=${ssci_start}${ssci_bold}${ssci_end}
				STEAMSHIP_GRAY=${ssci_start}${ssci_bold}${ssci_end}
				STEAMSHIP_GREEN=${ssci_start}${ssci_bold}${ssci_end}
				STEAMSHIP_MAGENTA=${ssci_start}${ssci_bold}${ssci_end}
				STEAMSHIP_RED=${ssci_start}${ssci_bold}${ssci_end}
				STEAMSHIP_WHITE=${ssci_start}${ssci_bold}${ssci_end}
				STEAMSHIP_YELLOW=${ssci_start}${ssci_bold}${ssci_end}
				STEAMSHIP_NORMAL=${ssci_start}$(tput sgr0)${ssci_end}
			fi
			unset ssci_ncolors
		fi
		unset ssci_start ssci_end ssci_bold
	fi
}

steamship_colors_init

case " ${STEAMSHIP_DEBUG} " in
*" colors "*)
	echo "${STEAMSHIP_BLUE}blue${STEAMSHIP_NORMAL}"
	echo "${STEAMSHIP_CYAN}cyan${STEAMSHIP_NORMAL}"
	echo "${STEAMSHIP_GRAY}gray${STEAMSHIP_NORMAL}"
	echo "${STEAMSHIP_GREEN}green${STEAMSHIP_NORMAL}"
	echo "${STEAMSHIP_MAGENTA}magenta${STEAMSHIP_NORMAL}"
	echo "${STEAMSHIP_RED}red${STEAMSHIP_NORMAL}"
	echo "${STEAMSHIP_WHITE}white${STEAMSHIP_NORMAL}"
	echo "${STEAMSHIP_YELLOW}yellow${STEAMSHIP_NORMAL}"
	;;
esac

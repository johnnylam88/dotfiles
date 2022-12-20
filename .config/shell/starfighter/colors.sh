# starfighter/colors.sh

# Global color variables to be used by starfighter modules.
STARFIGHTER_BLUE=
STARFIGHTER_CYAN=
STARFIGHTER_GRAY=
STARFIGHTER_GREEN=
STARFIGHTER_MAGENTA=
STARFIGHTER_RED=
STARFIGHTER_WHITE=
STARFIGHTER_YELLOW=
STARFIGHTER_NORMAL=

if [ -t 1 ]; then
	sf_start=${STARFIGHTER_ESC_START}
	sf_end=${STARFIGHTER_ESC_END}
	sf_bold=$(tput bold)
	if [ -n "${sf_bold}" ]; then
		sf_ncolors=$(tput colors)
		if [ -n "${sf_ncolors}" ] && [ ${sf_ncolors} -ge 8 ]; then
			STARFIGHTER_BLUE=${sf_start}${sf_bold}$(tput setaf 4)${sf_end}
			STARFIGHTER_CYAN=${sf_start}${sf_bold}$(tput setaf 6)${sf_end}
			STARFIGHTER_GRAY=${sf_start}${sf_bold}$(tput setaf 0)${sf_end}
			STARFIGHTER_GREEN=${sf_start}${sf_bold}$(tput setaf 2)${sf_end}
			STARFIGHTER_MAGENTA=${sf_start}${sf_bold}$(tput setaf 5)${sf_end}
			STARFIGHTER_RED=${sf_start}${sf_bold}$(tput setaf 1)${sf_end}
			STARFIGHTER_WHITE=${sf_start}${sf_bold}$(tput setaf 7)${sf_end}
			STARFIGHTER_YELLOW=${sf_start}${sf_bold}$(tput setaf 3)${sf_end}
			STARFIGHTER_NORMAL=${sf_start}$(tput sgr0)${sf_end}
		else
			STARFIGHTER_BLUE=${sf_start}${sf_bold}${sf_end}
			STARFIGHTER_CYAN=${sf_start}${sf_bold}${sf_end}
			STARFIGHTER_GRAY=${sf_start}${sf_bold}${sf_end}
			STARFIGHTER_GREEN=${sf_start}${sf_bold}${sf_end}
			STARFIGHTER_MAGENTA=${sf_start}${sf_bold}${sf_end}
			STARFIGHTER_RED=${sf_start}${sf_bold}${sf_end}
			STARFIGHTER_WHITE=${sf_start}${sf_bold}${sf_end}
			STARFIGHTER_YELLOW=${sf_start}${sf_bold}${sf_end}
			STARFIGHTER_NORMAL=${sf_start}$(tput sgr0)${sf_end}
		fi
		unset sf_ncolors
	fi
	unset sf_start sf_end sf_bold
fi

case " ${STARFIGHTER_DEBUG} " in
*" colors "*)
	echo "${STARFIGHTER_BLUE}blue${STARFIGHTER_NORMAL}"
	echo "${STARFIGHTER_CYAN}cyan${STARFIGHTER_NORMAL}"
	echo "${STARFIGHTER_GRAY}gray${STARFIGHTER_NORMAL}"
	echo "${STARFIGHTER_GREEN}green${STARFIGHTER_NORMAL}"
	echo "${STARFIGHTER_MAGENTA}magenta${STARFIGHTER_NORMAL}"
	echo "${STARFIGHTER_RED}red${STARFIGHTER_NORMAL}"
	echo "${STARFIGHTER_WHITE}white${STARFIGHTER_NORMAL}"
	echo "${STARFIGHTER_YELLOW}yellow${STARFIGHTER_NORMAL}"
	;;
esac

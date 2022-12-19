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
	sf_bold=$(tput bold)
	if [ -n "${sf_bold}" ]; then
		sf_ncolors=$(tput colors)
		if [ -n "${sf_ncolors}" ] && [ ${sf_ncolors} -ge 8 ]; then
			STARFIGHTER_BLUE=${sf_bold}$(tput setaf 4)
			STARFIGHTER_CYAN=${sf_bold}$(tput setaf 6)
			STARFIGHTER_GRAY=${sf_bold}$(tput setaf 0)
			STARFIGHTER_GREEN=${sf_bold}$(tput setaf 2)
			STARFIGHTER_MAGENTA=${sf_bold}$(tput setaf 5)
			STARFIGHTER_RED=${sf_bold}$(tput setaf 1)
			STARFIGHTER_WHITE=${sf_bold}$(tput setaf 7)
			STARFIGHTER_YELLOW=${sf_bold}$(tput setaf 3)
			STARFIGHTER_NORMAL=$(tput sgr0)
		else
			STARFIGHTER_BLUE=${sf_bold}
			STARFIGHTER_CYAN=${sf_bold}
			STARFIGHTER_GRAY=${sf_bold}
			STARFIGHTER_GREEN=${sf_bold}
			STARFIGHTER_MAGENTA=${sf_bold}
			STARFIGHTER_RED=${sf_bold}
			STARFIGHTER_WHITE=${sf_bold}
			STARFIGHTER_YELLOW=${sf_bold}
			STARFIGHTER_NORMAL=$(tput sgr0)
		fi
		unset sf_ncolors
	fi
	unset sf_bold
fi

# starfighter/nonprintable.sh

# Global delimiter variables to be used by colors.sh.
STARFIGHTER_ESC_START=
STARFIGHTER_ESC_END=

# Global variable to indicate whether delimiters exist.
STARFIGHTER_NONPRINTABLE=

# Module variable
starfighter_preamble=

starfighter_nonprintable_init() {
	if [ -n "${BASH_VERSION}" ]; then
		# Bash:
		#   readline uses \001 and \002 as start and end delimiters for
		#   non-printable text.
		STARFIGHTER_ESC_START=$(printf '\001')
		STARFIGHTER_ESC_END=$(printf '\002')
		STARFIGHTER_NONPRINTABLE=yes
	elif [ -n "${KSH_VERSION}" ]; then
		# KSH:
		#   Prefix the prompt with any non-printable character followed
		#   by an ASCII carriage return, then delimit escape codes with
		#   this with this non-printable character.
		STARFIGHTER_ESC_START=$(printf '\001')
		STARFIGHTER_ESC_END=${STARFIGHTER_ESC_START}
		starfighter_preamble="${STARFIGHTER_ESC_START}$(printf '\015')"
		STARFIGHTER_NONPRINTABLE=yes
	elif [ -n "${ZSH_VERSION}" ]; then
		# ZSH:
		#   Delimit a character sequnce with '%{' and '%}' to indicate
		#   the sequence has zero length.
		STARFIGHTER_ESC_START='%{'
		STARFIGHTER_ESC_END='%}'
		STARFIGHTER_NONPRINTABLE=yes
	fi
}

starfighter_nonprintable() {
	# Prepend the preamble to ${STARFIGHTER_PROMPT}.
	if [ -n "${starfighter_preamble}" ]; then
		STARFIGHTER_PROMPT="${starfighter_preamble}${STARFIGHTER_PROMPT}"
	fi
}

starfighter_nonprintable_init

case " ${STARFIGHTER_DEBUG} " in
*" nonprintable "*)
	starfighter_nonprintable
	echo "start: ${STARFIGHTER_ESC_START}"
	echo "end: ${STARFIGHTER_ESC_END}"
	echo "exist: ${STARFIGHTER_NONPRINTABLE:-no}"
	echo "${STARFIGHTER_PROMPT}"
	;;
esac

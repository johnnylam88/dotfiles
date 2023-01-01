# shellcheck shell=sh
# steamship/nonprintable.sh

# Global delimiter variables to be used by colors.sh.
STEAMSHIP_ESC_START=
STEAMSHIP_ESC_END=

# Global variable to indicate whether delimiters exist.
STEAMSHIP_NONPRINTABLE=

# Module variable
steamship_preamble=

steamship_nonprintable_init() {
	if [ -n "${BASH_VERSION}" ]; then
		# Bash:
		#   readline uses \001 and \002 as start and end delimiters for
		#   non-printable text.
		STEAMSHIP_ESC_START=$(printf '\001')
		STEAMSHIP_ESC_END=$(printf '\002')
		STEAMSHIP_NONPRINTABLE=yes
	elif [ -n "${KSH_VERSION}" ]; then
		# KSH:
		#   Prefix the prompt with any non-printable character followed
		#   by an ASCII carriage return, then delimit escape codes with
		#   this with this non-printable character.
		STEAMSHIP_ESC_START=$(printf '\001')
		STEAMSHIP_ESC_END=${STEAMSHIP_ESC_START}
		steamship_preamble="${STEAMSHIP_ESC_START}$(printf '\015')"
		STEAMSHIP_NONPRINTABLE=yes
	elif [ -n "${ZSH_VERSION}" ]; then
		# ZSH:
		#   Delimit a character sequnce with '%{' and '%}' to indicate
		#   the sequence has zero length.
		STEAMSHIP_ESC_START='%{'
		STEAMSHIP_ESC_END='%}'
		STEAMSHIP_NONPRINTABLE=yes
	fi
}

steamship_nonprintable_prompt() {
	# Prepend the preamble to ${STEAMSHIP_PROMPT}.
	if [ -n "${steamship_preamble}" ]; then
		STEAMSHIP_PROMPT="${steamship_preamble}${STEAMSHIP_PROMPT}"
	fi
}

case " ${STEAMSHIP_DEBUG} " in
*" nonprintable "*)
	steamship_nonprintable_init
	steamship_nonprintable_prompt
	echo "start: ${STEAMSHIP_ESC_START}"
	echo "end: ${STEAMSHIP_ESC_END}"
	echo "exist: ${STEAMSHIP_NONPRINTABLE:-no}"
	echo "${STEAMSHIP_PROMPT}"
	;;
esac

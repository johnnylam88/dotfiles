# shellcheck shell=sh
# steamship/line_separator.sh

: "${STEAMSHIP_LINE_SEPARATOR_SHOW:="true"}"

# This module does not have configurable prefix, suffix, or color.
# Its sole purpose is to add a newline character into the prompt
# so that it spans multiple lines.

steamship_line_separator_prompt() {
	[ "${STEAMSHIP_LINE_SEPARATOR_SHOW}" = true ] || return

	# Append a newline to ${STEAMSHIP_PROMPT}.
	STEAMSHIP_PROMPT="${STEAMSHIP_PROMPT}"'
'
}

# shellcheck shell=sh disable=SC2034
# steamship/themes/starship.sh

STEAMSHIP_THEMES="${STEAMSHIP_THEMES} starship"

steamship_theme_starship() {
	STEAMSHIP_CHARACTER_SHOW='true'
	STEAMSHIP_CHARACTER_SYMBOL='❯ '
	STEAMSHIP_CHARACTER_SYMBOL_SUCCESS=${STEAMSHIP_CHARACTER_SYMBOL}
	STEAMSHIP_CHARACTER_SYMBOL_FAILURE=${STEAMSHIP_CHARACTER_SYMBOL}
	STEAMSHIP_DELIMITER_SHOW='false'
	STEAMSHIP_PROMPT_COLOR='NORMAL'
}

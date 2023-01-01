# shellcheck shell=sh disable=SC2034
# steamship/themes/spaceship.sh

STEAMSHIP_THEMES="${STEAMSHIP_THEMES} spaceship"

steamship_theme_spaceship() {
	STEAMSHIP_CHARACTER_SHOW='true'
	STEAMSHIP_CHARACTER_SYMBOL='→ '
	STEAMSHIP_CHARACTER_SYMBOL_ROOT='⇒ '
	STEAMSHIP_CHARACTER_SYMBOL_SUCCESS=${STEAMSHIP_CHARACTER_SYMBOL}
	STEAMSHIP_CHARACTER_SYMBOL_FAILURE=${STEAMSHIP_CHARACTER_SYMBOL}
	STEAMSHIP_DELIMITER_SHOW='false'
}
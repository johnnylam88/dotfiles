# steamship/theme.sh

STEAMSHIP_THEMES=

STEAMSHIP_THEMES="${STEAMSHIP_THEMES} ascii"
steamship_theme_ascii() {
	STEAMSHIP_CHARACTER_SYMBOL='$'
	STEAMSHIP_CHARACTER_SYMBOL_ROOT='#'
	STEAMSHIP_DELIMITER_SHOW='false'
}

STEAMSHIP_THEMES="${STEAMSHIP_THEMES} bracket"
steamship_theme_bracket() {
	STEAMSHIP_CHARACTER_SYMBOL='└'
	STEAMSHIP_CHARACTER_SYMBOL_ROOT='╙'
	STEAMSHIP_DELIMITER_SYMBOL='┌'
	STEAMSHIP_DELIMITER_SYMBOL_ROOT='╓'
	STEAMSHIP_EXIT_CODE_SHOW='false'
}

STEAMSHIP_THEMES="${STEAMSHIP_THEMES} spaceship"
steamship_theme_spaceship() {
	STEAMSHIP_CHARACTER_SYMBOL='→'
	STEAMSHIP_CHARACTER_SYMBOL_ROOT='⇒'
	STEAMSHIP_DELIMITER_SHOW='false'
}

STEAMSHIP_THEMES="${STEAMSHIP_THEMES} starship"
steamship_theme_starship() {
	STEAMSHIP_CHARACTER_SYMBOL='❯'
	STEAMSHIP_DELIMITER_SHOW='false'
	STEAMSHIP_PROMPT_COLOR='NORMAL'
}

STEAMSHIP_THEMES="${STEAMSHIP_THEMES} steamship"
steamship_theme_steamship() {
	STEAMSHIP_CHARACTER_SYMBOL='$'
	STEAMSHIP_CHARACTER_SYMBOL_ROOT='#'
	STEAMSHIP_DELIMITER_SYMBOL='❯'
}

steamship_theme() {
	sst_theme=${1:-'steamship'}
	case " ${STEAMSHIP_THEMES} " in
	*" ${sst_theme} "*)
		;;
	*)
		echo 1>&2 "steamship_theme: \`${sst_theme}' theme not found, using \`steamship'."
		sst_theme='default'
	esac
	sst_theme_fn="steamship_theme_${sst_theme}"
	eval "${sst_theme_fn}"
	unset sst_theme sst_theme_fn
}

# Load default theme when the module is loaded.
steamship_theme

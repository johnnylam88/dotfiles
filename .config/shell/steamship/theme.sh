# steamship/theme.sh

STEAMSHIP_THEMES='default'
steamship_theme_default() {
	STEAMSHIP_CHARACTER_SYMBOL='└'
	STEAMSHIP_CHARACTER_SYMBOL_ROOT='╙'
	STEAMSHIP_DELIMITER_SYMBOL='┌'
	STEAMSHIP_DELIMITER_SYMBOL_ROOT='╓'
}

STEAMSHIP_THEMES="${STEAMSHIP_THEMES} ascii"
steamship_theme_ascii() {
	STEAMSHIP_DELIMITER_SHOW='false'
	STEAMSHIP_CHARACTER_SYMBOL='$'
	STEAMSHIP_CHARACTER_SYMBOL_ROOT='#'
}

STEAMSHIP_THEMES="${STEAMSHIP_THEMES} spaceship"
steamship_theme_spaceship() {
	STEAMSHIP_DELIMITER_SHOW='false'
	STEAMSHIP_CHARACTER_SYMBOL='➜'
}

steamship_theme() {
	sst_theme=${1:-'default'}
	case " ${STEAMSHIP_THEMES} " in
	*" ${sst_theme} "*)
		;;
	*)
		echo 1>&2 "steamship_theme: \`${sst_theme}' theme not found, using default."
		sst_theme='default'
	esac
	sst_theme_fn="steamship_theme_${sst_theme}"
	eval "${sst_theme_fn}"
	unset sst_theme sst_theme_fn
}

# Load default theme when the module is loaded.
steamship_theme

# steamship/steamship.sh
# shellcheck shell=sh

# Path to the steamship main directory.
: "${STEAMSHIP_ROOT:="${XDG_CONFIG_HOME:-"${HOME}/.config"}/shell/steamship"}"

steamship_load() {
	# Load all libraries in the `lib` directory.
	STEAMSHIP_LIBS_SOURCED=
	for ssl_lib_file in "${STEAMSHIP_ROOT}"/lib/*.sh; do
		# shellcheck disable=SC1090
		. "${ssl_lib_file}"
	done
	# Run "init" function for each library.
	for ssl_lib in ${STEAMSHIP_LIBS_SOURCED}; do
		ssl_lib_init_fn="steamship_${ssl_lib}_init"
		eval "${ssl_lib_init_fn}"
	done
	unset ssl_lib ssl_lib_file ssl_lib_init_fn
}

steamship() {
	case ${1} in
	refresh)
		# Rebuild prompt strings after configuration changes.
		steamship_prompt_refresh
		;;
	reset)
		# Reset to default settings.
		steamship_modules_reset
		steamship_config
		steamship_themes_load "${STEAMSHIP_THEME:-"starship"}"
		steamship_prompt_refresh
		;;
	theme)
		shift
		steamship_themes_load "${@}"
		steamship_prompt_refresh
		;;
	esac
}

steamship_load
steamship reset

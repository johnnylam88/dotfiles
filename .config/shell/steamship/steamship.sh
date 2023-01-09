# steamship/steamship.sh
# shellcheck shell=sh

steamship_init() {
	if [ -z "${STEAMSHIP_ROOT}" ]; then
		# Path to the steamship main directory.
		STEAMSHIP_ROOT="${XDG_CONFIG_HOME:-"${HOME}/.config"}/shell/steamship"
	fi
}

steamship_load_library() {
	if [ -f "${STEAMSHIP_ROOT}/lib/${1}.sh" ]; then
		# shellcheck disable=SC1090
		. "${STEAMSHIP_ROOT}/lib/${1}.sh"
	else
		echo 1>&2 "steamship: \`${1}' library not found."
		return 1
	fi
}

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
		steamship_load_theme "${STEAMSHIP_THEME:-"starship"}"
		steamship_prompt_refresh
		;;
	theme)
		shift
		steamship_load_theme "${@}"
		steamship_prompt_refresh
		;;
	esac
}

steamship_init
steamship_load
steamship reset

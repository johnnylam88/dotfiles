# steamship/lib/themes.sh
# shellcheck shell=sh

case " ${STEAMSHIP_LIBS_SOURCED} " in *" themes "*) return ;; esac

# Track which themes are available.
# shellcheck disable=SC2034
STEAMSHIP_THEMES=

: "${STEAMSHIP_ROOT:="${XDG_CONFIG_HOME:-"${HOME}/.config"}/shell/steamship"}"

steamship_themes_init()
{
	STEAMSHIP_THEMES=

	# Load all available themes in the `themes` directory.
	for sst_theme_file in "${STEAMSHIP_ROOT}"/themes/*.sh; do
		# shellcheck disable=SC1090
		. "${sst_theme_file}"
	done
	unset sst_theme_file
	# ${STEAMSHIP_THEMES} contains the list of available themes.
}

steamship_themes_load()
{
	sstl_theme_fn=
	sstl_theme=${1}
	if [ -n "${sstl_theme}" ]; then
		case " ${STEAMSHIP_THEMES} " in
		*" ${sstl_theme} "*)
			sstl_theme_fn="steamship_theme_${sstl_theme}"
			eval "${sstl_theme_fn}"
			;;
		*)
			echo 1>&2 "steamship: \`${sstl_theme}' theme not found."
			return 1
			;;
		esac
	fi
	unset sstl_theme sstl_theme_fn
}

STEAMSHIP_LIBS_SOURCED="${STEAMSHIP_LIBS_SOURCED} themes"

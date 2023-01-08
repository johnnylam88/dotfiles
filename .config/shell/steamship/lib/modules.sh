# steamship/lib/modules.sh
# shellcheck shell=sh

case " ${STEAMSHIP_LIBS_SOURCED} " in *" modules "*) return ;; esac

# Dependencies
: "${STEAMSHIP_ROOT:="${XDG_CONFIG_HOME:-"${HOME}/.config"}/shell/steamship"}"
# shellcheck disable=SC1091
. "${STEAMSHIP_ROOT}/lib/config.sh"
# shellcheck disable=SC1091
. "${STEAMSHIP_ROOT}/lib/shell_features.sh"

# Track the order in which modules are sourced.
# shellcheck disable=SC2034
STEAMSHIP_MODULES_SOURCED=

steamship_modules_init() {
	STEAMSHIP_MODULES_SOURCED=

	# Load all modules in the `modules` directory.
	for ssm_module_file in "${STEAMSHIP_ROOT}"/modules/*.sh; do
		# shellcheck disable=SC1090
		. "${ssm_module_file}"
	done
	unset ssm_module_file
	# ${STEAMSHIP_MODULES_SOURCED} contains the modules in the order they
	# were sourced.
}

steamship_modules_reset() {
	# Invoke every module "init" function to reset the configuration
	# variables to their defaults.
	for ssmr_module in ${STEAMSHIP_MODULES_SOURCED}; do
		ssmr_module_init_fn="steamship_${ssmr_module}_init"
		eval "${ssmr_module_init_fn}"
	done
	unset ssmr_module ssmr_module_init_fn
}

STEAMSHIP_LIBS_SOURCED="${STEAMSHIP_LIBS_SOURCED} modules"

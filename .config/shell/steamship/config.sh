# shellcheck shell=sh
# steamship/config.sh

: "${STEAMSHIP_CONFIG:="${HOME}/.config/steamship/steamship.sh"}"

if [ -f "${STEAMSHIP_CONFIG}" ]; then
	# shellcheck disable=SC1090
	. "${STEAMSHIP_CONFIG}"
fi

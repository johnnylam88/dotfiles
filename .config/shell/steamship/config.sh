# steamship/config.sh

: ${STEAMSHIP_CONFIG:=${HOME}/.config/steamship/steamship.sh}

if [ -f "${STEAMSHIP_CONFIG}" ]; then
	. "${STEAMSHIP_CONFIG}"
fi

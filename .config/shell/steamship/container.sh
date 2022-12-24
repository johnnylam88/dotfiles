# starfighter/container.sh

: ${STARFIGHTER_CONTAINER_SHOW:=true}

starfighter_container() {
	[ "${STARFIGHTER_CONTAINER_SHOW}" = false ] && return

	# Add container name if we're in a container.
	sfc_name=
	sfc_status=
	sfc_prefix=
	if [ -f /run/.containerenv ]; then
		sfc_name=$(. /run/.containerenv && command printf ${name})
		if [ -n "${sfc_name}" ]; then
			sfc_prefix=" ${STARFIGHTER_WHITE}on${STARFIGHTER_NORMAL}"
			sfc_status=" ${STARFIGHTER_CYAN}⬢ (${sfc_name})${STARFIGHTER_NORMAL}"
		fi
	fi

	# Append status to ${STARFIGHTER_PROMPT}.
	if [ -n "${STARFIGHTER_PROMPT}" ]; then
		STARFIGHTER_PROMPT="${STARFIGHTER_PROMPT}${sfc_prefix}${sfc_status}"
	else
		STARFIGHTER_PROMPT="${sfc_status}"
	fi
	unset sfc_name sfc_status sfc_prefix
}

case " ${STARFIGHTER_DEBUG} " in
*" container "*)
	starfighter_container
	echo "${STARFIGHTER_PROMPT}"
	;;
esac

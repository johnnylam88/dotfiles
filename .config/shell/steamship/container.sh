# steamship/container.sh

: ${STEAMSHIP_CONTAINER_SHOW:=true}

steamship_container() {
	[ "${STEAMSHIP_CONTAINER_SHOW}" = false ] && return

	# Add container name if we're in a container.
	ssc_name=
	ssc_status=
	ssc_prefix=
	if [ -f /run/.containerenv ]; then
		ssc_name=$(. /run/.containerenv && command printf ${name})
		if [ -n "${ssc_name}" ]; then
			ssc_prefix=" ${STEAMSHIP_WHITE}on${STEAMSHIP_NORMAL}"
			ssc_status=" ${STEAMSHIP_CYAN}⬢ (${ssc_name})${STEAMSHIP_NORMAL}"
		fi
	fi

	# Append status to ${STEAMSHIP_PROMPT}.
	if [ -n "${STEAMSHIP_PROMPT}" ]; then
		STEAMSHIP_PROMPT="${STEAMSHIP_PROMPT}${ssc_prefix}${ssc_status}"
	else
		STEAMSHIP_PROMPT="${ssc_status}"
	fi
	unset ssc_name ssc_status ssc_prefix
}

case " ${STEAMSHIP_DEBUG} " in
*" container "*)
	steamship_container
	echo "${STEAMSHIP_PROMPT}"
	;;
esac

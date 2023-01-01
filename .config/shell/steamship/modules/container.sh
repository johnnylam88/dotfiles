# shellcheck shell=sh
# steamship/modules/container.sh

steamship_container_init() {
	STEAMSHIP_CONTAINER_SHOW='true'
	STEAMSHIP_CONTAINER_PREFIX='on '
	STEAMSHIP_CONTAINER_SUFFIX=${STEAMSHIP_SUFFIX_DEFAULT}
	STEAMSHIP_CONTAINER_SYMBOL='⬢ '
	STEAMSHIP_CONTAINER_COLOR='CYAN'
}

steamship_container() {
	ssc_name=
	if [ -f /run/.containerenv ]; then
		# shellcheck disable=SC1091,SC2154
		ssc_name=$(. /run/.containerenv && printf '%s' "${name}")
	fi
	ssc_color=
	ssc_colorvar="STEAMSHIP_${STEAMSHIP_CONTAINER_COLOR}"
	eval 'ssc_color=${'"${ssc_colorvar}"'}'

	ssc_status=
	if [ -n "${ssc_name}" ]; then
		if [ -n "${STEAMSHIP_CONTAINER_SYMBOL}" ]; then
			ssc_status=${STEAMSHIP_CONTAINER_SYMBOL}
		fi
		ssc_status="${ssc_status}${ssc_name}"
	fi
	if [ -n "${ssc_status}" ]; then
		ssc_status="${ssc_color}${ssc_status}${STEAMSHIP_BASE_COLOR}"
		if [ "${1}" = '-p' ]; then
			ssc_status="${STEAMSHIP_CONTAINER_PREFIX}${ssc_status}"
		fi
		ssc_status="${ssc_status}${STEAMSHIP_CONTAINER_SUFFIX}"
	fi

	echo "${ssc_status}"
	unset ssc_name ssc_color ssc_colorvar ssc_status
}

steamship_container_prompt() {
	[ "${STEAMSHIP_CONTAINER_SHOW}" = true ] || return

	# Append status to ${STEAMSHIP_PROMPT}.
	if [ -n "${STEAMSHIP_PROMPT}" ]; then
		STEAMSHIP_PROMPT="${STEAMSHIP_PROMPT}$(steamship_container -p)"
	else
		STEAMSHIP_PROMPT=$(steamship_container)
	fi
}

case " ${STEAMSHIP_DEBUG} " in
*" container "*)
	steamship_container_init
	steamship_container -p
	steamship_container_prompt
	echo "${STEAMSHIP_PROMPT}"
	;;
esac

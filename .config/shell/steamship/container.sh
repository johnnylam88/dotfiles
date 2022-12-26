# steamship/container.sh

: ${STEAMSHIP_CONTAINER_SHOW:='true'}
: ${STEAMSHIP_CONTAINER_PREFIX:='on '}
: ${STEAMSHIP_CONTAINER_SUFFIX:=${STEAMSHIP_SUFFIX_DEFAULT}}
: ${STEAMSHIP_CONTAINER_SYMBOL:='⬢'}
: ${STEAMSHIP_CONTAINER_COLOR:='CYAN'}

steamship_container() {
	[ "${STEAMSHIP_CONTAINER_SHOW}" = false ] && return

	ssc_colorvar="STEAMSHIP_${STEAMSHIP_CONTAINER_COLOR}"
	eval 'ssc_color=${'${ssc_colorvar}'}'
	unset ssc_colorvar

	ssc_name=
	if [ -f /run/.containerenv ]; then
		ssc_name=$(. /run/.containerenv && printf ${name})
	fi

	ssc_status=
	if [ -n "${ssc_name}" ]; then
		if [ -n "${STEAMSHIP_CONTAINER_SYMBOL}" ]; then
			ssc_status="${STEAMSHIP_CONTAINER_SYMBOL} "
		fi
		ssc_status="${ssc_status}${ssc_name}"
	fi

	if [ -n "${ssc_status}" ]; then
		ssc_status="${ssc_color}${ssc_status}${STEAMSHIP_WHITE}"
		# Append status to ${STEAMSHIP_PROMPT}.
		if [ -n "${STEAMSHIP_PROMPT}" ]; then
			STEAMSHIP_PROMPT="${STEAMSHIP_PROMPT}${STEAMSHIP_CONTAINER_PREFIX}"
		fi
		STEAMSHIP_PROMPT="${STEAMSHIP_PROMPT}${ssc_status}"
		STEAMSHIP_PROMPT="${STEAMSHIP_PROMPT}${STEAMSHIP_CONTAINER_SUFFIX}"
	fi
	unset ssc_name ssc_status ssc_color
}

case " ${STEAMSHIP_DEBUG} " in
*" container "*)
	steamship_container
	echo "${STEAMSHIP_PROMPT}"
	;;
esac

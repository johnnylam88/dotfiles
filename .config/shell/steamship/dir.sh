# steamship/dir.sh

: ${STEAMSHIP_DIR_SHOW:='true'}
: ${STEAMSHIP_DIR_PREFIX:='in '}
: ${STEAMSHIP_DIR_SUFFIX:=${STEAMSHIP_SUFFIX_DEFAULT}}
: ${STEAMSHIP_DIR_TRUNCATE:=3}
: ${STEAMSHIP_DIR_TRUNCATE_PREFIX:=''}
: ${STEAMSHIP_DIR_TRUNCATE_REPO:='true'}
: ${STEAMSHIP_DIR_SYMBOL:=''}
: ${STEAMSHIP_DIR_COLOR:='CYAN'}

steamship_dir_truncate_repo_path() {
	ssdrp_dir=${PWD}
	ssdrp_toplevel=$(command git rev-parse --show-toplevel 2>/dev/null)
	ssdrp_pwd=
	ssdrp_proj=
	if [ -n "${ssdrp_toplevel}" ]; then
		ssdrp_pwd=$(pwd -P)
		if [ "${ssdrp_pwd}" = "${ssdrp_toplevel}" ]; then
			ssdrp_proj=${ssdrp_dir##*/}
			ssdrp_dir=${ssdrp_proj}
		else
			ssdrp_proj=${ssdrp_toplevel##*/}
			ssdrp_dir="${ssdrp_proj}${ssdrp_pwd#${ssdrp_toplevel}}"
		fi
	fi
	echo "${ssdrp_dir}"
	unset ssdrp_dir ssdrp_toplevel ssdrp_pwd ssdrp_proj
}

steamship_dir_truncate_path() {
	ssdtp_dir=${PWD}

	# Tilde substitution for ${HOME}.
	case ${ssdtp_dir} in
	${HOME})
		ssdtp_dir='~'
		;;
	${HOME}/*)
		ssdtp_dir="~/${ssdtp_dir#${HOME}/}"
		;;
	esac

	# Truncate to last ${STEAMSHIP_DIR_TRUNCATE} components of path.
	ssdtp_chop=
	case ${STEAMSHIP_DIR_TRUNCATE} in
	1)	ssdtp_chop="${ssdtp_dir%/*}/"
		;;
	2)	case ${ssdtp_dir} in
		*/*)	ssdtp_chop="${ssdtp_dir%/*/*}/" ;;
		esac
		;;
	3)	case ${ssdtp_dir} in
		*/*/*)	ssdtp_chop="${ssdtp_dir%/*/*/*}/" ;;
		esac
		;;
	4)	case ${ssdtp_dir} in
		*/*/*/*)
				ssdtp_chop="${ssdtp_dir%/*/*/*/*}/" ;;
		esac
		;;
	5)	case ${ssdtp_dir} in
		*/*/*/*/*)
				ssdtp_chop="${ssdtp_dir%/*/*/*/*/*}/" ;;
		esac
		;;
	esac
	case X${ssdtp_chop} in
	X/)	;;
	*)	ssdtp_dir=${ssdtp_dir#${ssdtp_chop}} ;;
	esac
	case ${ssdtp_dir} in
	'~'|'~'/*|/*)
		;;
	*)	ssdtp_dir="${STEAMSHIP_DIR_TRUNCATE_PREFIX}${ssdtp_dir}"
		;;
	esac
	echo "${ssdtp_dir}"
	unset ssdtp_dir ssdtp_chop
}

steamship_dir() {
	ssd_dir=
	if [ "${STEAMSHIP_PROMPT_HAS_COMMAND_SUBST}" = true ]; then
		if	[ "${STEAMSHIP_DIR_TRUNCATE_REPO}" = true ] &&
			command git rev-parse --is-inside-work-tree >/dev/null 2>&1
		then
			ssd_dir=$(steamship_dir_truncate_repo_path)
		else
			ssd_dir=$(steamship_dir_truncate_path)
		fi
	else
		ssd_dir='${PWD}'
	fi

	ssd_color=
	ssd_colorvar="STEAMSHIP_${STEAMSHIP_DIR_COLOR}"
	eval 'ssd_color=${'${ssd_colorvar}'}'

	ssd_status=
	if [ -n "${ssd_dir}" ]; then
		if [ -n "${STEAMSHIP_DIR_SYMBOL}" ]; then
			ssd_status="${STEAMSHIP_DIR_SYMBOL} "
		fi
		ssd_status="${ssd_status}${ssd_dir}"
	fi
	if [ -n "${ssd_status}" ]; then
		ssd_status="${ssd_color}${ssd_status}${STEAMSHIP_BASE_COLOR}"
		if [ "${1}" = '-p' ]; then
			ssd_status="${STEAMSHIP_DIR_PREFIX}${ssd_status}"
		fi
		ssd_status="${ssd_status}${STEAMSHIP_DIR_SUFFIX}"
	fi

	echo "${ssd_status}"
	unset ssd_dir ssd_color ssd_colorvar ssd_status
}

steamship_dir_prompt() {
	[ "${STEAMSHIP_DIR_SHOW}" = true ] || return

	# Append status to ${STEAMSHIP_PROMPT}.
	if [ "${STEAMSHIP_PROMPT_HAS_COMMAND_SUBST}" = true ]; then
		if [ -n "${STEAMSHIP_PROMPT}" ]; then
			STEAMSHIP_PROMPT="${STEAMSHIP_PROMPT}"'$(steamship_dir -p)'
		else
			STEAMSHIP_PROMPT='$(steamship_dir)'
		fi
	else
		if [ -n "${STEAMSHIP_PROMPT}" ]; then
			STEAMSHIP_PROMPT="${STEAMSHIP_PROMPT}$(steamship_dir -p)"
		else
			STEAMSHIP_PROMPT=$(steamship_dir)
		fi
	fi
}

case " ${STEAMSHIP_DEBUG} " in
*" dir "*)
	export STEAMSHIP_PROMPT_HAS_COMMAND_SUBST=true
	echo "$(steamship_dir -p)"
	steamship_dir_prompt
	echo "${STEAMSHIP_PROMPT}"
	;;
esac

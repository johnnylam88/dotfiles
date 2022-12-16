# spaceship-lite.sh

# Global color variables to be used by Spaceship Lite modules.
if [ -n "${BASH_VERSION}${KSH_VERSION}${ZSH_VERSION}" ]; then
	SS_ESC_BLUE='[1;34m'
	SS_ESC_CYAN='[1;36m'
	SS_ESC_GRAY='[1;30m'
	SS_ESC_GREEN='[1;32m'
	SS_ESC_PURPLE='[1;35m'
	SS_ESC_RED='[1;31m'
	SS_ESC_WHITE='[1;37m'
	SS_ESC_YELLOW='[1;33m'
	SS_ESC_END='[m'
else
	SS_ESC_BLUE=
	SS_ESC_CYAN=
	SS_ESC_GRAY=
	SS_ESC_GREEN=
	SS_ESC_PURPLE=
	SS_ESC_RED=
	SS_ESC_WHITE=
	SS_ESC_YELLOW=
	SS_ESC_END=
fi

ss_git_prompt_sourced=
case ${SYSTYPE} in
git-sdk-*)
	# Git For Windows automatically sources git-prompt.sh.
	ss_git_prompt_sourced=yes
	;;
esac
if [ -z "${ss_git_prompt_sourced}" ]; then
	if [ -n "${BASH_VERSION}${ZSH_VERSION}" ]; then
		# git-prompt.sh is designed for bash(1) and zsh(1).
		for ss_git_prompt_path in \
			"${HOME}"/.config/shell \
			/usr/share/git-core/contrib/completion
		do
			if [ -f "${ss_git_prompt_path}/git-prompt.sh" ]; then
				ss_git_prompt_sourced=yes
			    . "${ss_git_prompt_path}/git-prompt.sh"
				break
			fi
		done
		unset ss_git_prompt_path
	fi
fi
if [ -n "${ss_git_prompt_sourced}" ]; then
	# Configure __git_ps1 to show the state of working directory
	# relative to the branch.
	GIT_PS1_SHOWDIRTYSTATE=yes
	GIT_PS1_SHOWSTATESTATE=yes
	GIT_PS1_SHOWUNTRACKEDFILES=yes
fi

# Prompt section definitions
if [ -n "${BASH_VERSION}" ]; then
	: ${ss_prompt_host:='\h'}
	: ${ss_prompt_pwd:='\W'}
	: ${ss_prompt_user:='\u'}
elif [ -n "${KSH_VERSION}${ZSH_VERSION}" ]; then
	: ${ss_prompt_host:=${HOSTNAME:+'${HOSTNAME}'}}
	: ${ss_prompt_host:=${HOST:+'${HOST}'}}
	: ${ss_prompt_host:='${SYSTYPE}'}
	: ${ss_prompt_pwd:='${PWD##*/}'}
	: ${ss_prompt_user:='${USER}'}
fi
: ${ss_prompt_host:=${HOSTNAME}}
: ${ss_prompt_host:=${HOST}}
: ${ss_prompt_host:=${SYSTYPE}}
: ${ss_prompt_pwd:=}
: ${ss_prompt_user:=${USER}}

# Start with a new line.
PS1='
'
PS1="${PS1}"'┌ '
# Add the user if this is not localhost.
if [ -n "${SSH_CONNECTION}" ]; then
	case ${USER} in
	root)	PS1="${PS1}${SS_ESC_RED}${ss_prompt_user}${SS_ESC_END}" ;;
	*)		PS1="${PS1}${SS_ESC_YELLOW}${ss_prompt_user}${SS_ESC_END}" ;;
	esac
fi
# Add the last component of the current directory.
if [ -n "${ss_prompt_pwd}" ]; then
	if [ -n "${SSH_CONNECTION}" ]; then
		PS1="${PS1} ${SS_ESC_WHITE}in${SS_ESC_END} "
	fi
	PS1="${PS1}${SS_ESC_CYAN}${ss_prompt_pwd}${SS_ESC_END}"
fi
# Add the hostname if we're in an SSH session.
if [ -n "${SSH_CONNECTION}" ]; then
	PS1="${PS1} ${SS_ESC_WHITE}at${SS_ESC_END}"
	PS1="${PS1} ${SS_ESC_GREEN}${ss_prompt_host}${SS_ESC_END}"
fi
if [ -n "${ss_git_prompt_sourced}" ]; then
	# Append Git status.
	ss_git_status_fmt=" ${SS_ESC_WHITE}on${SS_ESC_END} ${SS_ESC_PURPLE} %s${SS_ESC_END}"
	PS1="${PS1}"'$(__git_ps1 "${ss_git_status_fmt}")'
fi
# Add container name if we're in a container.
if [ -f /run/.containerenv ]; then
	ss_container_name=$(. /run/.containerenv && printf ${name})
	if [ -n "${ss_container_name}" ]; then
		PS1="${PS1} ${SS_ESC_WHITE}on${SS_ESC_END}"
		PS1="${PS1} ${SS_ESC_CYAN}⬢ (${ss_container_name})${SS_ESC_END}"
	fi
	unset ss_container_name
fi
# Append a new line.
PS1="${PS1}"'
'
# Append a final prompt symbol.
# NOTE: This should not contain any escape codes or else command-line
#       editing may break.
PS1="${PS1}"'└ '

unset ss_prompt_host ss_prompt_pwd ss_prompt_user

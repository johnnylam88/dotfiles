# spaceship-lite.sh

if [ -n "${BASH_VERSION}${KSH_VERSION}${ZSH_VERSION}" ]; then
	ss_esc_blue='[1;34m'
	ss_esc_cyan='[1;36m'
	ss_esc_gray='[1;30m'
	ss_esc_green='[1;32m'
	ss_esc_purple='[1;35m'
	ss_esc_red='[1;31m'
	ss_esc_white='[1;37m'
	ss_esc_yellow='[1;33m'
	ss_esc_end='[m'
else
	ss_esc_blue=
	ss_esc_cyan=
	ss_esc_gray=
	ss_esc_green=
	ss_esc_purple=
	ss_esc_red=
	ss_esc_white=
	ss_esc_yellow=
	ss_esc_end=
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
	root)	PS1="${PS1}${ss_esc_red}${ss_prompt_user}${ss_esc_end}" ;;
	*)		PS1="${PS1}${ss_esc_yellow}${ss_prompt_user}${ss_esc_end}" ;;
	esac
fi
# Add the last component of the current directory.
if [ -n "${ss_prompt_pwd}" ]; then
	if [ -n "${SSH_CONNECTION}" ]; then
		PS1="${PS1} ${ss_esc_white}in${ss_esc_end} "
	fi
	PS1="${PS1}${ss_esc_cyan}${ss_prompt_pwd}${ss_esc_end}"
fi
# Add the hostname if we're in an SSH session.
if [ -n "${SSH_CONNECTION}" ]; then
	PS1="${PS1} ${ss_esc_white}at${ss_esc_end}"
	PS1="${PS1} ${ss_esc_green}${ss_prompt_host}${ss_esc_end}"
fi
if [ -n "${ss_git_prompt_sourced}" ]; then
	# Append Git status.
	ss_git_status_fmt=" ${ss_esc_white}on${ss_esc_end} ${ss_esc_purple} %s${ss_esc_end}"
	PS1="${PS1}"'$(__git_ps1 "${ss_git_status_fmt}")'
fi
# Add container name if we're in a container.
if [ -f /run/.containerenv ]; then
	ss_container_name=$(. /run/.containerenv && printf ${name})
	if [ -n "${ss_container_name}" ]; then
		PS1="${PS1} ${ss_esc_white}on${ss_esc_end}"
		PS1="${PS1} ${ss_esc_cyan}⬢ (${ss_container_name})${ss_esc_end}"
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

unset ss_esc_blue ss_esc_cyan ss_esc_gray
unset ss_esc_green ss_esc_purple ss_esc_red
unset ss_esc_white ss_esc_yellow ss_esc_end
unset ss_prompt_host ss_prompt_pwd ss_prompt_user

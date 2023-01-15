# steamship/lib/utils.sh
# shellcheck shell=sh

case " ${STEAMSHIP_LIBS_SOURCED} " in *" utils "*) return ;; esac

# Check if a command exists in ${PATH}.
# USAGE:
#     steamship_exists <command>
steamship_exists() {
	command -v "${1}" >/dev/null 2>&1
}

# Check if the current directory is in a Git repository.
# USAGE:
#     steamship_is_git
steamship_is_git() {
	steamship_exists git &&
	[ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" = true ]
}

# Print the root of the Git repository.
# USAGE:
#     steamship_git_repo_path
steamship_git_repo_path() {
	steamship_exists git &&
	git rev-parse --show-toplevel 2>/dev/null
}

# Shell-quote an arbitrary string.
# USAGE:
#     steamship_quote_arg "string_with_weird_characters"
steamship_shquote() {
	printf %s\\n "${1}" | sed "s/'/'\\\\''/g;1s/^/'/;\$s/\$/'/"
}

# Save the parameter list as quoted strings separated by newlines.
# USAGE:
#     steamship_save_argv "$@"
# EXAMPLE:
#     argv=$(steamship_save_argv "#@")   # save parameters
#     set -- foo bar baz boo             # set new parameters
#     eval "set -- ${argv}"              # restore saved parameters
steamship_save_argv() {
	for sssa_arg; do
		steamship_shquote "${sssa_arg}"
	done
	echo " "
	unset sssa_arg
}

# Search upward through the directory tree from the current directory
# for a specific file or directory. Returns the path to the first found
# file or fails.
# USAGE:
#     steamship_upsearch <glob1> ...
# EXAMPLE:
#     $ steamship_upsearch package.json node_modules
#     /home/username/path/to/project/node_modules
steamship_upsearch() (
	# Returns the path to the first file found in an "upsearch" from the
	# current directory.
	ssu_argv=$(steamship_save_argv "$@")
	ssu_root=${PWD}
	while [ -n "${ssu_root}" ]; do
		for ssu_arg in ${ssu_argv}; do
			eval "set -- ${ssu_arg}"
			for ssu_glob; do
				for ssu_name in ${ssu_glob}; do
					ssu_path="${ssu_root}/${ssu_name}"
					if [ -e "${ssu_path}" ]; then
						echo "${ssu_path}"
						return 0
					fi
				done
			done
		done

		[ -d "${ssu_root}/.git" ] && return 1

		ssu_root=${ssu_root%/*}
		[ -z "${ssu_root}" ] || cd ..
	done
	return 1
)

STEAMSHIP_LIBS_SOURCED="${STEAMSHIP_LIBS_SOURCED} utils"

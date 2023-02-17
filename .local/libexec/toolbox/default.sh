#!/bin/sh

script=${0##*/}

if [ ! -f /run/.containerenv ]; then
	echo 1>&2 "${script}: must be run inside a toolbox"
	exit 1
fi

# shellcheck disable=SC2016
toolbox_name=$(eval '. /run/.containerenv && printf "${name}"')
toolbox_statedir="${HOME}/.var/toolbox/${toolbox_name}"

# Setup
setup() {
	mkdir -p "${toolbox_statedir}"

	# Install packages that are useful in the default toolbox.
	xargs -rt sudo dnf install -y <<- EOF
		shellcheck
	EOF
}

# Teardown
teardown() {
	rm -fr "${toolbox_statedir}"
}

setup
teardown
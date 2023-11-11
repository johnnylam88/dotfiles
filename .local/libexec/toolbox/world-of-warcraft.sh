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

	# Install neovim for development.
	xargs -rt sudo dnf install -y <<- EOF
		gcc
		libstdc++-devel
		neovim
	EOF
	# Use nvim in place of vi.
	sudo update-alternatives --install /usr/bin/vim vim "$(which nvim)" 10

	# Install all packages for World of Warcraft addon development.
	# shellcheck disable=SC2016
	xargs -rt sudo dnf install -y <<- EOF
		binutils
		gcc
		make
		ncurses-devel
		openssl-devel
		python
		readline
		readline-devel
		shellcheck
		tig
	EOF

	# Install Lua 5.1.
	( cd "${toolbox_statedir}" &&
	  VERSION='5.1.5' &&
	  wget "https://www.lua.org/ftp/lua-${VERSION}.tar.gz" &&
	  tar zxvpf "lua-${VERSION}.tar.gz" &&
	  cd "lua-${VERSION}" &&
	  make linux &&
	  sudo make install ) || return 1

	# Install LuaRocks.
	( cd "${toolbox_statedir}" &&
	  VERSION='3.9.2' &&
	  wget "https://luarocks.org/releases/luarocks-${VERSION}.tar.gz" &&
	  tar zxvpf "luarocks-${VERSION}.tar.gz" &&
	  cd "luarocks-${VERSION}" &&
	  ./configure && make &&
	  sudo make install ) || return 1

	# Install helper modules for LuaRocks.
	sudo luarocks install luasocket
	sudo luarocks install luasec

    # Install bitlib since it is in the standard WoW API.
	sudo luarocks install bitlib

	# Install Fennel.
	sudo luarocks install readline
	sudo luarocks install fennel
}

# Teardown
teardown() {
	rm -fr "${toolbox_statedir}"
}

setup
teardown

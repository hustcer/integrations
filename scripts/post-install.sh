#!/bin/sh
# Author: hustcer
# Created: 2025/02/25 18:55:20

set -e

# Running nu in the rpm-ostree script environment fails if the config directory
# doesn't exist, preventing the post-install.nu script from being run.
if [ -n "${XDG_CONFIG_HOME+x}" ]; then
	mkdir -p "$XDG_CONFIG_HOME"
elif [ -n "${HOME+x}" ]; then
	mkdir -p "$HOME/.config"
else
	export XDG_CONFIG_HOME="$PWD/.config"
	mkdir -p "$XDG_CONFIG_HOME"
fi

nu /usr/libexec/nushell/post-install.nu

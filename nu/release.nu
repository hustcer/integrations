#!/usr/bin/env nu
# Author: hustcer
# Created: 2025/03/21 19:15:20
# Description: Script to release Nushell packages for various Linux distributions.
# Usage:
#   docker run -it --rm -v $"(pwd):/work" --platform linux/amd64 ubuntu:latest
#

# Fetch the latest Nushell release package from GitHub
export def 'fetch pkg' [
  arch: string,   # The target architecture, e.g. amd64 & arm64
] {
  const ARCH_MAP = {
    'amd64': 'x86_64-unknown-linux-musl',
    'arm64': 'aarch64-unknown-linux-musl',
  }
  if $arch not-in $ARCH_MAP {
    print $'Invalid architecture: (ansi r)($arch)(ansi reset)'; exit 1
  }
  let assets = http get https://api.github.com/repos/nushell/nushell/releases
      | sort-by -r created_at
      | select name created_at assets
      | get 0
      | get assets.browser_download_url
  let download_url = $assets | where $it =~ ($ARCH_MAP | get $arch) | get 0
  if ('release' | path exists) { rm -rf release }
  if not ('release' | path exists) { mkdir release }
  cd release
  http get $download_url | save -rpf nushell.tar.gz
  tar -xzf nushell.tar.gz
  cp nu-*/nu* .
}

# Build the Nushell deb packages
export def 'build pkg' [
  arch: string,   # The target architecture, e.g. amd64 & arm64
] {
  let version = run-external 'release/nu' '--version' | complete | get stdout | default 0.102.0
  load-env {
    NU_VERSION: $version
    NU_PKG_ARCH: $arch
    NU_VERSION_RELEASE: 1
  }
  nfpm pkg --packager deb
  ls -f nushell*
}

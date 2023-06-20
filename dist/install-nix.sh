#!/usr/bin/env bash

# This is a cut-down version of https://github.com/cachix/install-nix-action/blob/master/lib/install-nix.sh
# Users should use install-nix-action if they want to customise how Nix is installed.

set -euo pipefail

emacs_ci_version=$1
[[ -n "$emacs_ci_version" ]]

if type -p nix &>/dev/null ; then
  echo "Aborting: Nix is already installed at $(type -p nix)"
  exit
fi

# Create a temporary workdir
workdir=$(mktemp -d)
trap 'rm -rf "$workdir"' EXIT

# Configure Nix
add_config() {
  echo "$1" | tee -a "$workdir/nix.conf" >/dev/null
}

# Set jobs to number of cores
add_config "max-jobs = auto"
if [[ $OSTYPE =~ darwin ]]; then
  add_config "ssl-cert-file = /etc/ssl/cert.pem"
fi
# Allow binary caches for user
add_config "trusted-users = root ${USER:-}"

# Add github access token
if [[ -n "${INPUT_GITHUB_ACCESS_TOKEN:-}" ]]; then
    add_config "access-tokens = github.com=$INPUT_GITHUB_ACCESS_TOKEN"
elif [[ -n "${GITHUB_TOKEN:-}" ]]; then
    add_config "access-tokens = github.com=$GITHUB_TOKEN"
fi

# Nix installer flags
installer_options=(
  --no-channel-add
  --darwin-use-unencrypted-nix-store-volume
  --nix-extra-conf-file "$workdir/nix.conf"
)

# only use the nix-daemon settings if on darwin (which get ignored) or systemd is supported
if [[ $OSTYPE =~ darwin || -e /run/systemd/system ]]; then
  installer_options+=(
    --daemon
    --daemon-user-count "$(python -c 'import multiprocessing as mp; print(mp.cpu_count() * 2)')"
  )
else
  # "fix" the following error when running nix*
  # error: the group 'nixbld' specified in 'build-users-group' does not exist
  add_config "build-users-group ="
  sudo mkdir -p /etc/nix
  sudo chmod 0755 /etc/nix
  sudo cp $workdir/nix.conf /etc/nix/nix.conf
fi

echo "installer options: ${installer_options[*]}"

# There is --retry-on-errors, but only newer curl versions support that
curl_retries=5
while ! curl -sS -o "$workdir/install" -v --fail -L "${INPUT_INSTALL_URL:-https://nixos.org/nix/install}"
do
  sleep 1
  ((curl_retries--))
  if [[ $curl_retries -le 0 ]]; then
    echo "curl retries failed" >&2
    exit 1
  fi
done

sh "$workdir/install" "${installer_options[@]}"

# Set paths
echo "/nix/var/nix/profiles/default/bin" >> "$GITHUB_PATH"
# new path for nix 2.14
echo "$HOME/.nix-profile/bin" >> "$GITHUB_PATH"

export NIX_PATH=nixpkgs=channel:nixpkgs-unstable
echo "NIX_PATH=${NIX_PATH}" >> $GITHUB_ENV

## Emacs installation

PATH="$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:$PATH"
nix-env --quiet -j8 -iA cachix -f https://cachix.org/api/v1/install
cachix use emacs-ci

nix-env -iA "$emacs_ci_version" -f "https://github.com/purcell/nix-emacs-ci/archive/master.tar.gz"

emacs -version

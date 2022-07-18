#!/usr/bin/env bash

set -euo pipefail

KEY="$(dirname "$0")/release-key.gpg"
VERSION="${VERSION:=2.10.3}"
CHECK_SIGNATURE=true

if ! command -v gpg &>/dev/null; then
    echo "WARN: gpg is not available, signatures will not be checked"
    CHECK_SIGNATURE=false
fi

if [ ! -f "$KEY" ]; then
    echo "WARN: gpg key is not present in '$KEY', signatures will not be checked"
    CHECK_SIGNATURE=false
fi

if [ "$CHECK_SIGNATURE" == "true" ]; then
    gpg --quiet --import "$KEY"
fi

workdir=$(mktemp -d)
trap 'cd ~ && rm -rf "$workdir"' EXIT

INSTALLER="install-nix-$VERSION"

pushd "$workdir" &>/dev/null
curl -sS "https://releases.nixos.org/nix/nix-$VERSION/install" -o "$INSTALLER"
curl -sS "https://releases.nixos.org/nix/nix-$VERSION/install.asc" -o "$INSTALLER.asc"
if [ "$CHECK_SIGNATURE" == "true" ]; then
    gpg --always-trust --quiet --verify "./$INSTALLER.asc"
fi
chmod +x "$INSTALLER"
popd &>/dev/null

cat <<EOF >"$workdir/nix.conf"
accept-flake-config = true
auto-optimise-store = true
builders-use-substitutes = true
connect-timeout = 5
cores = 0
experimental-features = nix-command flakes
http-connections = 0
max-jobs = auto
sandbox = true
substituters = https://cache.nixos.org/ https://nix-community.cachix.org
trusted-public-keys = cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=
trusted-users = root $USER
EOF

if [ -n "${TOKEN+x}" ]; then
    echo "access-tokens = github.com=$TOKEN" >>"$workdir/nix.conf"
fi

"$workdir/$INSTALLER" --daemon --nix-extra-conf-file "$workdir/nix.conf"

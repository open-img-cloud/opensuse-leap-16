#!/usr/bin/env bash
# Prints the latest upstream openSUSE Leap 16 cloud image version on stdout
# (e.g. 16.0-18.92), parsed from the directory listing at
#   https://download.opensuse.org/distribution/leap/16.0/appliances/
# Runs in the upstream-watch reusable workflow (no KVM needed): keep it
# portable bash + curl + grep + sort only.

set -euo pipefail

URL='https://download.opensuse.org/distribution/leap/16.0/appliances/'

listing=$(curl -fsL "$URL")
if [[ -z "$listing" ]]; then
  echo "::error::could not fetch $URL" >&2
  exit 1
fi

latest=$(printf '%s\n' "$listing" \
  | grep -oE 'Leap-16\.0-Minimal-VM\.x86_64-Cloud-Build[0-9]+\.[0-9]+\.qcow2' \
  | sed -E 's#Leap-16\.0-Minimal-VM\.x86_64-Cloud-Build([0-9]+\.[0-9]+)\.qcow2#\1#' \
  | sort -uV \
  | tail -n1)

if [[ -z "$latest" ]]; then
  echo "::error::no openSUSE Leap 16 cloud image found in $URL" >&2
  exit 1
fi

printf '16.0-%s\n' "$latest"

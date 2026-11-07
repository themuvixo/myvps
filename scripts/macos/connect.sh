#!/usr/bin/env bash
set -euo pipefail
set +x

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "This script is for macOS." >&2
  exit 2
fi
if [[ -x "/Applications/Tailscale.app/Contents/MacOS/Tailscale" ]]; then
  tailscale_cli="/Applications/Tailscale.app/Contents/MacOS/Tailscale"
elif command -v tailscale >/dev/null 2>&1; then
  tailscale_cli="$(command -v tailscale)"
else
  echo "Tailscale is not installed. Install and launch the official macOS app first." >&2
  exit 1
fi
if [[ -z "${TAILSCALE_AUTHKEY:-}" ]]; then
  echo "Set TAILSCALE_AUTHKEY in the environment using a short-lived, least-privilege key." >&2
  exit 1
fi

host_name="${TAILSCALE_HOSTNAME:-$(scutil --get ComputerName 2>/dev/null || hostname -s)}"
"$tailscale_cli" up --authkey="$TAILSCALE_AUTHKEY" --hostname="$host_name"
unset TAILSCALE_AUTHKEY

echo "Tailscale IPv4 address:"
"$tailscale_cli" ip -4
echo "Tailscale status:"
"$tailscale_cli" status

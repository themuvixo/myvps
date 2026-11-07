#!/usr/bin/env bash
set -euo pipefail
set +x

if [[ "$(uname -s)" != "Linux" ]]; then
  echo "This script is for Linux." >&2
  exit 2
fi
if ! command -v tailscale >/dev/null 2>&1; then
  echo "Tailscale is not installed. Install it using the official instructions for your Linux distribution." >&2
  exit 1
fi
if [[ -z "${TAILSCALE_AUTHKEY:-}" ]]; then
  echo "Set TAILSCALE_AUTHKEY in the environment using a short-lived, least-privilege key." >&2
  exit 1
fi
if ! command -v sudo >/dev/null 2>&1; then
  echo "sudo is required to connect the Linux Tailscale client." >&2
  exit 1
fi

host_name="${TAILSCALE_HOSTNAME:-$(hostname -s)}"
sudo tailscale up --authkey="$TAILSCALE_AUTHKEY" --hostname="$host_name"
unset TAILSCALE_AUTHKEY

echo "Tailscale IPv4 address:"
tailscale ip -4
echo "Tailscale status:"
tailscale status

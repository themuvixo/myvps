# Secure Remote Access (Linux, macOS, Windows)

This project provides small, cross-platform helpers for joining a machine to your Tailscale network. It does **not** turn GitHub-hosted Actions runners into VPS hosts and does not publish SSH, RDP, or other services to the public internet.

## Security model

- Tailscale is the only network tunnel included. A Tailscale auth key enrolls a device in your tailnet; it is not a login password for Linux, macOS, Windows, SSH, or RDP.
- Keep normal operating-system authentication enabled. SSH and screen-sharing/RDP still require valid host credentials and access controls.
- Do not expose SSH/RDP ports to the public internet. Reach them over the tailnet instead.
- Create a least-privilege, tagged, short-lived Tailscale auth key for the intended machine. Store it in a trusted secret manager or inject it into the process environment. Never commit it, print it, or paste it into a workflow log.
- The scripts expect Tailscale to already be installed. Install it from the official download page: <https://tailscale.com/download>. The auth key is passed briefly to the local Tailscale CLI, so run this only on a machine you administer and trust.

## Linux server

Install Tailscale using the official instructions for your distribution, then run:

```bash
read -rsp 'Tailscale auth key: ' TAILSCALE_AUTHKEY
echo
export TAILSCALE_AUTHKEY
./scripts/linux/connect.sh
unset TAILSCALE_AUTHKEY
```

The script uses `sudo` to connect the installed Tailscale client and reports the assigned Tailscale IP. It does not open firewall ports or change SSH configuration.

## macOS

Install and launch the official Tailscale app, then run:

```bash
read -rsp 'Tailscale auth key: ' TAILSCALE_AUTHKEY
echo
export TAILSCALE_AUTHKEY
./scripts/macos/connect.sh
unset TAILSCALE_AUTHKEY
```

The script uses the app's bundled CLI when available, otherwise it uses `tailscale` from `PATH`. It does not enable Remote Login or Screen Sharing.

## Windows

Install Tailscale, open PowerShell, set `TAILSCALE_AUTHKEY` through your secret manager, then run:

```powershell
.\scripts\windows\Connect-Tailscale.ps1
Remove-Item Env:TAILSCALE_AUTHKEY
```

The script connects the local Tailscale client and prints the assigned Tailscale IP. It does not enable RDP, change firewall rules, or create an administrator account.

## Accessing services

After the machine is online, use its Tailscale IP or MagicDNS name with the service's normal client. For example, SSH to a Linux host using your existing OS account, or use macOS Screen Sharing / Windows RDP with the host's normal authentication. Tailscale controls network reachability; it does not replace service-level login.

Anonymous public tunnels and quick-tunnel modes are intentionally not included. They can expose a machine to anyone who discovers the endpoint. GitHub Actions is used here only for syntax checks, not as a long-running remote server.

## Validation

The GitHub Actions workflow checks Bash and PowerShell syntax on hosted runners. It requires no secrets and does not connect to your tailnet.

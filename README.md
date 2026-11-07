# 🚀 CloudVPS - Universal Multi-OS Cloud Runner & Remote Desktop

> **Turn GitHub Actions into powerful, on-demand Linux, Windows, and macOS virtual machines with zero authentication, zero account creation, and instant remote access.**

---

## 🌟 Key Features

- **⚡ Full Zero-Auth Setup**: No tokens, no API keys, no registrations, no credit cards required for TryCloudflare, Tmate, Bore, or Pinggy!
- **💻 All Major Operating Systems**:
  - **Ubuntu Linux**: Choose between headless server CLI (Docker, root sudo) or full **XFCE Desktop with browser noVNC GUI & XRDP**.
  - **Windows Server**: Full Remote Desktop Protocol (**RDP**) with admin privileges, hardware acceleration, and `mstsc` support.
  - **macOS (Apple Silicon / Latest)**: Terminal SSH or native **Screen Sharing (VNC)**.
- **🌐 5 Different Tunneling Technologies**:
  1. **Tmate** *(Zero-Auth)*: Instant clickable browser web shell + SSH command. Works on mobile & desktop with zero client software!
  2. **TryCloudflare** *(Zero-Auth)*: Fast, secure Cloudflare edge network tunnels for web desktops, RDP, or SSH.
  3. **Bore** *(Zero-Auth)*: Open-source, direct TCP tunnel (`bore.pub:PORT`) with no client software needed on your PC.
  4. **Pinggy** *(Zero-Auth)*: Clean reverse TCP tunnel over SSH.
  5. **Tailscale** *(Auth-Key Supported)*: Private, encrypted WireGuard mesh network connecting your devices securely.
- **⏱️ Up to 6 Hours Per Session**: Maximum runner duration permitted by GitHub Actions (360 minutes).

---

## 📋 Tunnel Comparison Matrix

| Tunnel Provider | Authentication Required? | Client Software Required? | Best For |
| :--- | :---: | :---: | :--- |
| **Tmate** | ❌ **None** | ❌ **None** (Opens in Browser) | Instant web shell, mobile terminal, fast debugging |
| **TryCloudflare** | ❌ **None** | ❌ (None for Web Desktop) / `cloudflared` for RDP | High-speed web GUI desktop, stable RDP |
| **Bore** | ❌ **None** | ❌ **None** (Direct IP/Port) | Native RDP (`mstsc`) or SSH without installing anything |
| **Pinggy** | ❌ **None** | ❌ **None** | Direct SSH & TCP proxy |
| **Tailscale** | ✅ Yes (`TAILSCALE_AUTHKEY`) | Tailscale App | Private, encrypted LAN mesh across your devices |

---

## 🚀 Workflows Guide

### 1. 🐧 Linux Cloud VPS (`.github/workflows/linux-vps.yml`)
- **Environment**:
  - `gui`: Deploys XFCE4 desktop + XRDP + **noVNC** (HTML5 browser desktop).
  - `cli`: Ultra-fast headless server with Docker, Python, Node.js, and root sudo.
- **How to Connect**:
  - **If using Tmate**: Click the generated web URL in the workflow step summary to open a terminal right in your browser.
  - **If using TryCloudflare (GUI)**: Click the `trycloudflare.com/vnc.html` link, enter the password, and control the Linux desktop directly in your browser!
  - **If using Bore**: Run `ssh runner@bore.pub -p <PORT>` or connect with your RDP client to `bore.pub:<PORT>`.

### 2. 🪟 Windows Cloud RDP (`.github/workflows/windows-rdp.yml`)
- **Environment**: Latest Windows Server runner with full administrative privileges.
- **Default Username**: `CynetAdmin`
- **Default Password**: `Cynet@2026` (Customizable via workflow input or `RDP_PASSWORD` secret).
- **How to Connect**:
  - **TryCloudflare**:
    ```bash
    cloudflared access rdp --hostname <TUNNEL_URL> --url localhost:13389
    # Then open Remote Desktop (mstsc) and connect to: localhost:13389
    ```
  - **Bore (Direct TCP)**:
    - Open `mstsc` (Remote Desktop Connection) and directly connect to `bore.pub:<PORT>`.
    - No client proxy needed!
  - **Tailscale**:
    - Connect to the assigned Tailscale IP directly via `mstsc`.

### 3. 🍎 macOS Cloud VPS (`.github/workflows/macos-vps.yml`)
- **Environment**: Latest macOS Apple Silicon runner.
- **Service**:
  - `ssh`: Command line terminal with Homebrew.
  - `vnc`: Native macOS Screen Sharing on port 5900.
- **How to Connect**:
  - Open via Tmate web shell or connect your VNC client (VNC Viewer / RealVNC) to the tunnel address.

### 4. ⚡ Instant Terminal (`.github/workflows/quick-terminal.yml`)
- Launches in **under 5 seconds**.
- Outputs a clickable link in the GitHub Actions summary.
- One click gives you a full Linux root shell in any web browser!

---

## ⚙️ Configuration & Secrets (Optional)

The workflows run **100% out of the box with zero secrets**. If you want custom passwords or to use Tailscale, add these repository secrets in **Settings > Secrets and variables > Actions**:

| Secret Name | Description | Required? |
| :--- | :--- | :---: |
| `RDP_PASSWORD` | Custom password for Windows RDP & Linux VPS | Optional (Default: `Cynet@2026`) |
| `TAILSCALE_AUTHKEY` | Tailscale reusable auth key (`tskey-auth-...`) | Only if using Tailscale tunnel |

---

## 🔒 Security & Best Practices

1. **Ephemeral Runners**: GitHub Actions virtual machines are completely isolated and destroyed automatically once the workflow finishes or times out.
2. **Never store sensitive private data** on public runners.
3. Keep workflows private if you want to prevent others from seeing your workflow dispatch run summaries.
4. **Usage Guidelines**: Ensure compliance with GitHub Actions Terms of Service.

---

## 📄 License
MIT License. Created for development, testing, and continuous integration workflows.

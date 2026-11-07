[CmdletBinding()]
param(
    [string]$HostName = $env:TAILSCALE_HOSTNAME
)

$ErrorActionPreference = 'Stop'
if ([string]::IsNullOrWhiteSpace($env:TAILSCALE_AUTHKEY)) {
    throw 'Set TAILSCALE_AUTHKEY through a trusted secret manager using a short-lived, least-privilege key.'
}

$tailscale = Join-Path $env:ProgramFiles 'Tailscale\tailscale.exe'
if (-not (Test-Path -LiteralPath $tailscale)) {
    throw 'Tailscale is not installed. Install it from the official download page first.'
}
if ([string]::IsNullOrWhiteSpace($HostName)) {
    $HostName = $env:COMPUTERNAME
}

& $tailscale up "--authkey=$($env:TAILSCALE_AUTHKEY)" "--hostname=$HostName"
$connectExitCode = $LASTEXITCODE
$env:TAILSCALE_AUTHKEY = $null
if ($connectExitCode -ne 0) {
    throw "Tailscale connection failed with exit code $connectExitCode. Check local Tailscale status without sharing the key."
}

Write-Output 'Tailscale IPv4 address:'
& $tailscale ip -4
Write-Output 'Tailscale status:'
& $tailscale status

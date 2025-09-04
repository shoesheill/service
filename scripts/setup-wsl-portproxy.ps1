# ---------------------------------------------
# Fully automatic WSL portproxy setup script
# Reads LISTEN_PORT, POSTGRES_PORT, WSL_IP from .env
# ---------------------------------------------
# Run as Administrator
# ---------------------------------------------

# -------------------------------
# 0. Load .env
# -------------------------------
$envFile = Join-Path (Split-Path $MyInvocation.MyCommand.Path -Parent) "..\.env"
if (-not (Test-Path $envFile)) {
    Write-Error "Cannot find .env file at $envFile"
    exit 1
}

$envContent = Get-Content $envFile | Where-Object { $_ -notmatch "^\s*#|^\s*$" }
$vars = @{}
foreach ($line in $envContent) {
    if ($line -match "^\s*([^=]+)\s*=\s*(.+)\s*$") {
        $vars[$Matches[1]] = $Matches[2]
    }
}

if (-not ($vars["LISTEN_PORT"] -and $vars["POSTGRES_PORT"] -and $vars["WSL_IP"])) {
    Write-Error "LISTEN_PORT, POSTGRES_PORT or WSL_IP not defined in .env"
    exit 1
}

$LISTEN_PORT = [int]$vars["LISTEN_PORT"]
$POSTGRES_PORT = [int]$vars["POSTGRES_PORT"]
$WSL_IP = $vars["WSL_IP"]

$FirewallRulePrefix = "WSL PortProxy"

Write-Host "Using WSL IP from .env: $WSL_IP"

# -------------------------------
# 1. Apply portproxy + firewall rules
# -------------------------------
# Remove existing portproxy rule if any
netsh interface portproxy delete v4tov4 listenport=$LISTEN_PORT listenaddress=0.0.0.0 -ErrorAction SilentlyContinue

# Add new portproxy
netsh interface portproxy add v4tov4 listenport=$LISTEN_PORT listenaddress=0.0.0.0 connectport=$POSTGRES_PORT connectaddress=$WSL_IP
Write-Host "Portproxy set: Windows $LISTEN_PORT -> WSL ${WSL_IP}:$POSTGRES_PORT"

# Firewall rule
$ruleName = "$FirewallRulePrefix $LISTEN_PORT"
$existingRule = Get-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue
if ($existingRule) { Remove-NetFirewallRule -DisplayName $ruleName }

New-NetFirewallRule -DisplayName $ruleName -Direction Inbound -Action Allow -Protocol TCP -LocalPort $LISTEN_PORT
Write-Host "Firewall rule added for port $LISTEN_PORT"

# -------------------------------
# 2. Show final portproxy rules
# -------------------------------
Write-Host "`nCurrent portproxy rules:"
netsh interface portproxy show all

$taskName = "WSL Auto Start1111"

# Command to run inside WSL
$wslCommand = '-d Ubuntu -u root sh -c "tail -f /dev/null"'

# Build the task components
$action = New-ScheduledTaskAction -Execute "wsl.exe" -Argument " $wslCommand"
$trigger = New-ScheduledTaskTrigger -AtStartup
$currentUser = "$env:USERDOMAIN\$env:USERNAME"
$principal = New-ScheduledTaskPrincipal -UserId $currentUser -LogonType Interactive -RunLevel Highest

# Settings (Win8 enum works for Windows 10/11)
$settings = New-ScheduledTaskSettingsSet -Compatibility Win8 -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries

# Combine into scheduled task
$task = New-ScheduledTask -Action $action -Trigger $trigger -Principal $principal -Settings $settings

# Register the task
Register-ScheduledTask -TaskName $taskName -InputObject $task -Force

Write-Host "Scheduled Task '$taskName' created and should start WSL properly."

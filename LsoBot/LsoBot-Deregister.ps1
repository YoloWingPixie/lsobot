Unregister-ScheduledJob -Name "LSO Check" -ErrorAction SilentlyContinue
Unregister-ScheduledJob -Name "LSO Check" -ErrorAction SilentlyContinue
function Get-Timestamp {
    return Get-Date -Format "yyyy-MM-dd HH:mm:ss:fff"
}

Write-Output "$(Get-Timestamp) | WARNING | The Powershell Scheduled Job has been deregistered" | Out-file $PSScriptRoot\Logs\lsobot-debug.txt -append

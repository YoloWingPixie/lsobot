Unregister-ScheduledJob -Name "LSO Check"
function Get-Timestamp {return Get-Date -Format "yyyy-MM-dd HH:mm:ss:fff"}

Write-Output "$(Get-Timestamp) | WARNING | The Powershell Scheduled Job has been deregistered" | Out-file C:\lsobot-debug.txt -append

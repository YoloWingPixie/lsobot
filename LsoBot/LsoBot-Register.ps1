## BEGIN USER VARIABLES

$lsoBotfilePath = ".\LsoBot.ps1"
$LsoScriptRoot = $PWD.Path
$LsoScriptRoot.Trim()
$LsoScriptRoot.Split([Environment]::NewLine)[0]
$logX = "\Logs\lsobot-debug.txt"
$logDir = "$LsoScriptRoot\Logs"
$logPath =  $LsoScriptRoot + $logX
[int16]$repetitionInterval = 600

if (!(Test-Path $logDir)) {
    New-Item -ItemType Directory -Force -Path $logDir
}

## END USER VARIABLES

$lsoJobStart = Get-Date

function Get-Timestamp {
    return Get-Date -Format "yyyy-MM-dd HH:mm:ss:fff"
}

# Queue jobs if current instance is running late
$O = New-ScheduledJobOption -MultipleInstancePolicy Queue

# Start the job immediately, repeate every minute, for 10 years.This wil persist past reboot.
$T = New-JobTrigger -Once -At $lsoJobStart -RepetitionInterval (New-TimeSpan -Seconds $repetitionInterval) -RepetitionDuration (New-Timespan -Days 3650)

# Create scheduled job
try {
    Register-ScheduledJob -Name "LSO Check" -FilePath $lsoBotfilePath -ScheduledJobOption $O -Trigger $T -RunNow -ArgumentList @($LsoScriptRoot,$repetitionInterval)

}
catch {
    Write-Output "$(Get-Timestamp) | ERROR | The Powershell Scheduled Job failed to be created." | Out-file $PSScriptRoot\Logs\lsobot-debug.txt -append
}

Write-Output "$(Get-Timestamp) | INFO | The Powershell Scheduled Job has been started successfully." | Out-file $PSScriptRoot\Logs\lsobot-debug.txt -append
Write-Host "LSO Bot Powershell Scheduled Job Created" -ForegroundColor Green

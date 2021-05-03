## BEGIN USER VARIABLES

$filePath = ".\LsoBot.ps1"

## END USER VARIABLES

# Check if LSO Bot is already a valid Application log source, and if not, create it. New-EventLog requires Administrator rights to run. This loop only needs to run once per system.
if ([System.Diagnostics.EventLog]::SourceExists("LSO Bot") -eq $False) {
    New-EventLog -LogName 'Application' -Source 'LSO Bot'
} 

$start = Get-Date

# Queue jobs if current instance is running late
$O = New-ScheduledJobOption -MultipleInstancePolicy Queue

# Start the job immediately, repeate every minute, for 10 years.This wil persist past reboot.
$T = New-JobTrigger -Once -At $start -RepetitionInterval (New-TimeSpan -Seconds 60) -RepetitionDuration (New-Timespan -Days 3650)

# Create scheduled job
try {
    Register-ScheduledJob -Name "LSO Check" -FilePath $filePath -ScheduledJobOption $O -Trigger $T
}
catch {
    Write-EventLog -LogName "Application" -Source "LSO Bot" -EventId 3 -EntryType Error -Message "The Powershell scheduled job could not be created." -Category 1
}

Write-EventLog -LogName "Application" -Source "LSO Bot" -EventId 1 -EntryType Information -Message "LSO Bot has started" -Category 1
Write-Host "LSO Bot Powershell Scheduled Job Created" -ForegroundColor Green

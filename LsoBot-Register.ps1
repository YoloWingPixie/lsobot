# BEGIN USER VARIABLES
$filePath = "C:\Scripts\LsoBot.ps1"
# END USER VARIABLES

if ([System.Diagnostics.EventLog]::SourceExists("LSO") -eq $False) {
    New-EventLog -LogName 'Application' -Source 'LSO Bot'
} 
$start = Get-Date
$O = New-ScheduledJobOption -MultipleInstancePolicy Queue
$T = New-JobTrigger -Once -At $start -RepetitionInterval (New-TimeSpan -Seconds 60) -RepetitionDuration (New-Timespan -Days 365)
Register-ScheduledJob -Name "LSO Check" -FilePath $filePath -ScheduledJobOption $O -Trigger $T
Write-EventLog -LogName "Application" -Source "LSO Bot" -EventId 1 -EntryType Information -Message "LSO Bot has started" -Category 1
Write-Host "LSO Bot Powershell Scheduled Job Created"

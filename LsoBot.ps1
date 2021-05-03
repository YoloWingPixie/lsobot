# BEGIN USER VARIABLES

$logPath = "$env:USERPROFILE\Saved Games\DCS.openbeta_server\Logs\dcs.log"
$hookUrl = "https://discord.com/api/webhooks/DONTFORGETTOADDYOURHOOKURLTHISISNOTAREALURL"

# END USER VARIABLES

$lsoEventRegex = "^.*landing.quality.mark.*"
$timeTarget = New-TimeSpan -Seconds 60
[DateTime]$sysTime = [DateTime]::UtcNow.ToString('HH:mm:ss')

try {
    $landingEvent = Select-String -Path $logPath -Pattern $lsoEventRegex | Select-Object
}
catch {
    Write-EventLog -LogName "Application" -Source "LSO Bot" -EventId 402 -EntryType Information -Message -join ("Could not find dcs.log at ", $logPath) -Category 1
}

if ($landingEvent -eq $null ) {
    Exit
}


$logTime = $landingEvent
$logTime = $logTime -replace "^.*\d{4}\-\d{2}\-\d{2}.", ""
$logTime = $logTime -replace "\..*$", ""
$logTime = $logTime.split()[-1]

[DateTime]$trapTime = $logTime
$diff = New-TimeSpan -Start $trapTime -End $sysTime

$Grade = $landingEvent
$Grade = $Grade[-1] -replace "^.*(?:comment=LSO:)", ""
$Grade = $Grade -replace ",.*$", ""

$Pilot = $landingEvent
$Pilot = $Pilot[-1] -replace "^.*(?:initiatorPilotName=)", ""
$Pilot = $Pilot -replace ",.*$", ""

if ($diff -gt $timeTarget) {

    Exit

    }

    elseif (($Pilot = "System.Object[]") -or ($Grade = "System.Object[]")) {
        Write-EventLog -LogName "Application" -Source "LSO Bot" -EventId 400 -EntryType Warning -Message "A landing event was detected but the pilot name or grade was malformed. Discarding pass." -Category 1
        Exit

    }

    elseif (($Pilot -match "^.*\d{4}\-\d{2}\-\d{2}.*$") -or ($Grade -match "^.*\d{4}\-\d{2}\-\d{2}.*$")) {
        Write-EventLog -LogName "Application" -Source "LSO Bot" -EventId 401 -EntryType Warning -Message "A landing event was detected but the name or grade contained a date in the format of 2020-01-01 after processing. This indicates that the pass was performed by an AI or the log message was malformed. Discarding pass." -Category 1
        Exit

    }

    else {
        $messageConcent = -join("Pilot: ", $Pilot, " Grade: ", $Grade  )

        #Webhook
        
        $payload = [PSCustomObject]@{
            content = $messageConcent
        }
        
        try {
            Invoke-RestMethod -Uri $hookUrl -Method Post -Body ($payload | ConvertTo-Json) -ContentType 'application/json'  
        }
        catch [System.Net.WebException],[System.IO.IOException] {
            Write-EventLog -LogName "Application" -Source "LSO Bot" -EventId 403 -EntryType Warning -Message "Failed to establish connection to Discord webhook. Please check that the webhook URL is correct, and activated in Discord." -Category 1 -RawData $hookUrl
           
        }
        catch {
            Write-EventLog -LogName "Application" -Source "LSO Bot" -EventId 404 -EntryType Warning -Message "An unknown error occurred attempting to invoke the API request to Discord." -Category 1


        }
   
        Write-EventLog -LogName "Application" -Source "LSO Bot" -EventId 100 -EntryType Information -Message "A landing event was detected and sent successfully via Discord." -Category 1

}
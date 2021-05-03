# BEGIN USER VARIABLES

$logPath = "$env:USERPROFILE\Saved Games\DCS.openbeta_server\Logs\dcs.log"
$hookUrl = "https://discord.com/api/webhooks/838305965459243028/XhZ-srh8YP7ZZYLjSL3yN2IXKXGhaZ4f6_Gnko9ACO61h9jcKdBxQFIXJE4oTQWBfV7I"

# END USER VARIABLES

# The regex to check the log messages for
$lsoEventRegex = "^.*landing.quality.mark.*"

#The number of seconds that a landing quality mark should've arrived in. Anything older than this amount is discounted as a duplicate.
$timeTarget = New-TimeSpan -Seconds 60

#Get the system time, convert to UTC, and format to HH:mm:ss
[DateTime]$sysTime = [DateTime]::UtcNow.ToString('HH:mm:ss')

#Check dcs.log for the last line that matches the landing quality mark regex.
try {
    $landingEvent = Select-String -Path $logPath -Pattern $lsoEventRegex | Select-Object -Last 1
}
catch {
    Write-EventLog -LogName "Application" -Source "LSO Bot" -EventId 402 -EntryType Information -Message -join ("Could not find dcs.log at ", $logPath) -Category 1
}

#If dcs.log did not contain any lines that matched the LSO regex, stop.
if ($landingEvent -eq $null ) {
    Exit
}

# Strip the log message down to the time that the log event occurred. 
$logTime = $landingEvent
$logTime = $logTime -replace "^.*\d{4}\-\d{2}\-\d{2}.", ""
$logTime = $logTime -replace "\..*$", ""
$logTime = $logTime.split()[-1]

#Convert the log time string to a usable time object
[DateTime]$trapTime = $logTime

#Get the difference between the LSO event and the current time
$diff = New-TimeSpan -Start $trapTime -End $sysTime

#Strip the log message down to the landing grade and add escapes for _
$Grade = $landingEvent
$Grade = $Grade -replace "^.*(?:comment=LSO:)", ""
$Grade = $Grade -replace ",.*$", ""
$Grade = $Grade -replace "_", "\_"

#Strip the log message down to the pilot name
$Pilot = $landingEvent
$Pilot = $Pilot -replace "^.*(?:initiatorPilotName=)", ""
$Pilot = $Pilot -replace ",.*$", ""

#If the difference between the system time and log event time is greater than the time target, stop. 
if ($diff -gt $timeTarget) {

    Exit

    }

    #If the $Pilot or $Grade somehow turned up $null or blank, stop
    elseif (($Pilot -eq "System.Object[]") -or ($Grade -eq "System.Object[]")) {
        Write-EventLog -LogName "Application" -Source "LSO Bot" -EventId 400 -EntryType Warning -Message "A landing event was detected but the pilot name or grade was malformed. Discarding pass." -Category 1
        Exit

    }

    #If the $Pilot or $Grade has a date in the format of ####-##-##, stop. This will happen when AI land as the regex doesn't work correctly without a pilot field in the log event.
    elseif (($Pilot -match "^.*\d{4}\-\d{2}\-\d{2}.*$") -or ($Grade -match "^.*\d{4}\-\d{2}\-\d{2}.*$")) {
        Write-EventLog -LogName "Application" -Source "LSO Bot" -EventId 401 -EntryType Warning -Message "A landing event was detected but the name or grade contained a date in the format of 2020-01-01 after processing. This indicates that the pass was performed by an AI or the log message was malformed. Discarding pass." -Category 1
        Exit

    }
    #Create the webhook and send it
    else {
        #Message content
        $messageContent = -join("**Pilot:** ", $Pilot, " **Grade:** ", $Grade  )


        #json payload
        $payload = [PSCustomObject]@{
            content = $messageContent
        }
        #The webhook
        try {
            Invoke-RestMethod -Uri $hookUrl -Method Post -Body ($payload | ConvertTo-Json) -ContentType 'application/json'  
        }
        #If the error was specifically a network exception or IO exception, write friendly log message
        catch [System.Net.WebException],[System.IO.IOException] {
            Write-EventLog -LogName "Application" -Source "LSO Bot" -EventId 403 -EntryType Warning -Message "Failed to establish connection to Discord webhook. Please check that the webhook URL is correct, and activated in Discord." -Category 1 -RawData $hookUrl
           
        }
        catch {
            Write-EventLog -LogName "Application" -Source "LSO Bot" -EventId 404 -EntryType Warning -Message "An unknown error occurred attempting to invoke the API request to Discord." -Category 1

        }
   
        Write-EventLog -LogName "Application" -Source "LSO Bot" -EventId 100 -EntryType Information -Message "A landing event was detected and sent successfully via Discord." -Category 1
}

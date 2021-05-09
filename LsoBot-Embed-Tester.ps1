$webHookUrl =  "https://discord.com/api/webhooks/838497159484670022/skvK73LpMD4ZMcyUznSnjvGSemZdl8J0hYFeFBZu0mGwRQMjlTwBFBE3M2H5D37Tt8KG"

#Create embed array
[System.Collections.ArrayList]$lsoHookEmbedArray = @()


#Store embed values
$Pilot = "Virtual Aviator"
$Grade = "WO (Wave Off):"
$lsoComments = $Grade.Split(":")[-1]
$Grade = $Grade.Split(":")[0]

$embedColor = "93ca3b"
if ($Grade -Match "_OK_") {
    $embedColor = "835704"
}
elseif ($Grade -Match "(?<!_|\()OK") {
    $embedColor = "41056"
}
elseif ($Grade -Match "\(OK") {
    $embedColor = "31818"
}   
elseif ($Grade -Match "---") {
    $embedColor = "16751120"
}
elseif ($Grade -Match "CUT") {
    $embedColor = "15404878"
}
elseif ($Grade -Match "Bolter") {
    $embedColor = "16756287"
}
elseif ($Grade -Match "WO") {
    $embedColor = "1535929"
}
else {
    $embedColor = "410486"
}

#Create embed object
$hookEmbedObject = [PSCustomObject]@{

    #title       = $title
    color       = $embedColor
    fields      = @(
    [PSCustomObject]@{ 
        name = "Pilot"
        value = $Pilot
        inline = $true
        }
    [PSCustomObject]@{ 
        name = "Grade"
        value = $Grade
        inline = $true
        }
    [PSCustomObject]@{ 
        name = "Comments"
        value = $lsoComments
        inline = $true
        }
    )

}

#Add embed object to array
$lsoHookEmbedArray.Add($hookEmbedObject) | Out-Null

#Create the payload
$hookPayload = [PSCustomObject]@{

    embeds = $lsoHookEmbedArray

}

#Send webhook
Invoke-RestMethod -Uri $webHookUrl -Body ($hookPayload | ConvertTo-Json -Depth 5) -Method Post -ContentType 'application/json'
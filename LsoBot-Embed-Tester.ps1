$webHookUrl =  "https://discord.com/api/webhooks/838497159484670022/skvK73LpMD4ZMcyUznSnjvGSemZdl8J0hYFeFBZu0mGwRQMjlTwBFBE3M2H5D37Tt8KG"

#Create embed array
[System.Collections.ArrayList]$embedArray = @()


#Store embed values
$Pilot = "Virtual Aviator"
$Grade = "WO (Wave Off): (LURIM) DRIM LOIM WO(AFU)IC"
$Comments = $Grade.Split(":")[-1]
$Grade = $Grade.Split(":")[0]

$Color = "93ca3b"
if ($Grade -Match "_OK_") {
    $Color = "835704"
}
elseif ($Grade -Match "(?<!_|\()OK") {
    $Color = "41056"
}
elseif ($Grade -Match "\(OK") {
    $Color = "31818"
}   
elseif ($Grade -Match "---") {
    $Color = "16751120"
}
elseif ($Grade -Match "CUT") {
    $Color = "15404878"
}
elseif ($Grade -Match "Bolter") {
    $Color = "16756287"
}
elseif ($Grade -Match "WO") {
    $Color = "1535929"
}
else {
    $Color = "410486"
}

#Create embed object
$embedObject = [PSCustomObject]@{

    #title       = $title
    color       = $color
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
        value = $Comments
        inline = $true
        }
    )

}

#Add embed object to array
$embedArray.Add($embedObject) | Out-Null

#Create the payload
$payload = [PSCustomObject]@{

    embeds = $embedArray

}

#Send over payload, converting it to JSON
Invoke-RestMethod -Uri $webHookUrl -Body ($payload | ConvertTo-Json -Depth 5) -Method Post -ContentType 'application/json'
# lsobot
A log scrapper for DCS World that checks for new carrier landing grades made by humans and sends them to Discord. 

# Installation

## Requirements

* Powershell 5.1
* Administrative rights to register the Event Log Source, however normal operation does not require admin rights.
* Manage Webhooks rights on the Discord server to create the webhook

## Creating a Discord Webhook

1. Select the settings gear for the channel you want LSO grades to go to.

2. Select Integrations

4. Click **Create Webhook**

5. Name the webhook whatever you want and give it a picture if you'd like. 

6. Copy the Webhook URL and save it for the next step.


## Setup LSO Bot

1. Open LsoBot.ps1 and update the following variables:

    **$logpath** = The location of your dcs.log. Defaults to $env:USERPROFILE\Saved Games\DCS.openbeta_server\Logs\dcs.log
  
    **$hookUrl** = The URL for your Discord Web Hook

2. Place LsoBot.ps1, LsoBot-Register.ps1, and LsoBot-Deregister.ps1 on the DCS World server in folder. Recommend: C:\Scripts or C:\LsoBot or something similiar in the root of C:\ or in a common scripts folder.

3. Open LsoBot-Register.ps1 and update $filePath to the location of LsoBot.ps1. Defaults to C:\Scripts\LsoBot.ps1

4. Open Powershell **as an Administrator**

5. Change directory to the folder used above. e.g. *cd C:\Scripts*

6. Run *.\LsoBot-Register.ps1* 

   * You should review a response indicating that a powershell scheduled job was created.

7. Land on the carrier and each trap should result in a message to the Discord channel with the webhook.

8. If you need to stop the bot from sending messages to Discord, run *.\LsoBot-Deregister.ps1* from Powershell. 

9. To start LSO Bot again, simply run *.\LsoBot-Register.ps1*. You do not need to run as administrator on subsequent runs. 

# Event Log Reference
LSO BOT writes to the Windows Application log when it starts, stops, or encounters some errors:

## Informational
**1** - LSO Bot has started
**2** - LSO Bot has stopped
**100** - A landing event was detected, was formatted correctly, and was sent to Discord successfully.

## Errors
**400** - After finding a landing event and stripping the pilot and grade of unecessary characters, one or both were a blank object. This happens on some runs if the server has restarted and dcs.log contains no landing grades. This particular condition is checked for at beginning of the script run, so if this error actually triggers it's also possible a regex or split step failed and vaporized the whole string.

**401** - After finding a landing event and stripping the pilot and grade of unecessary character, one or both contained a date in ####-##-## format. This is a test to make sure the regex steps occurred properly. Due to DCS not including the pilot name when an AI lands, this will always happen as the string split that deals with removing text before the pilot name will fail, leaving the whole log message. This error is included in case it is clear that the bot failed on a human landing.

**402** - The dcs.log could not be found. Check that the correct log path is called for.

**403** - The invoke REST API method failed connecting to Discord and a network connection could not be made. Check the hook URL first, and also make sure that the Webhook actually exists in Discord.

**404** - The invoke REST API method failed connecting to Discord but for some other reason than a net connection issue.

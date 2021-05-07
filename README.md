![LSO BOT](https://i.imgur.com/Sdd379E.png)

 LSO BOT
A log scrapper for DCS World that checks for new carrier landing grades made by humans and sends them to Discord. LSO BOT is a Powershell script that runs at regular intervals using Powershell's scheduled job function. It then formats its results and sends them to Discord via Discord's webhook API. 

By running as a scheduled job, LSO BOT runs silently in the background on Windows and it will persist between reboots. It has no dependencies that do not already ship with modern versions of Windows. 

[LSO BOT on Discord](https://discord.gg/nr9xb6YJfw)

# Installation

Review the [Installation](https://github.com/YoloWingPixie/lsobot/wiki/Installation-Guide) procedure in the wiki.

# Limitations

* The message displayed in Discord is different than the one the client gets on screen. This is a DCS problem, as the logged grade is different than the displayed grade.

* Currently LSO BOT runs every 60 seconds and only checks for the latest landing within the last 60 seconds. This means that if n+1 aircraft land within any given polling period, only the last landing will be recorded and sent to Discord. This will be updated in the future.

* In theory, having a comma (`,`) in your display name could cause LsoBot to cut your name out of the message. 

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

**403** - The invoke REST API method failed connecting to Discord and a **network connection** could not be made. Check the hook URL first, and also make sure that the Webhook actually exists in Discord.

**404** - The invoke REST API method failed connecting to Discord but for some other reason than a net connection issue.



![LSO BOT](https://i.imgur.com/Sdd379E.png)
### [LSO BOT on Discord](https://discord.gg/nr9xb6YJfw)

LSO BOT is a log scrapper for DCS World that checks for new carrier landing grades made by humans and sends them to Discord. LSO BOT is a Powershell script that runs at regular intervals using Powershell's scheduled job function. It then formats its results and sends them to Discord via Discord's webhook API. 

By running as a scheduled job, LSO BOT runs silently in the background on Windows and it will persist between reboots. It has no dependencies that do not already ship with modern versions of Windows. 

# Features

## 15 Second Scan Cycle
LSO BOT runs in the background as a Powershell scheduled job. Externally the job restarted every 60 seconds. Internally, by default, the script checks every 15 seconds although this number can be adjusted.
The minimum scan cycle is realistically 7.5 seconds due to the way bolter detections need to work, as explained below.

15 second scan intervals should be sufficient to catch all grades in a multiplayer operation's Case I recovery.

## Regrading 

LSO BOT can regrade landings that come in to make them more readable and helpful for learning.
By default a DCS server's dcs.log will have extremely unhelpful and pedantic grades that do not reflect what the player sees from their client's LSO readout.
A worst case scenario looks like this, note as well how the AI LSO messes up and places the IW and wire comments before IC:

`GRADE:C _SLOX_ _LURX_ _DRX_ _LULX_ _DLX_ (LURIM) _LOIM_ (DRIM) _PIM_ 3PTSIW LNFIW WIRE #1 _LOIC_ _PIC_ _PPPIC_ _LURIC_ _LRIW_  _EGIW_ [BC]`

Obviously this is not a good landing at all, but some of the comments recorded by DCS are redundant, conflicting, or bugs related to how the AI LSO functions.

LSO BOT can take the above grade and turn it into this:

`GRADE: C (CUT): _LURX_ _DRX_ (LURIM) _LOIM_ (DRIM) _PIM_ _LOIC_ _PPPIC_ _LURIC_ LR LNF 3PTS WIRE #1`

This is still an extremely long comment that is not indicative of a normal landing but here's what LSO BOT did:

1. It removed `SLOX` and `EGIW` as these calls are buggy in the AI LSO with either the Tomcat or both the Tomcat and the Hornet. They trigger on most landings from the server side.
2. Evaluated that `LURX` and `LULX` and `DRX` and `DLX` all appeared in the comment and replaced them with the lineup and drift that was reported first, so `LURX` and `DRX`. 
3. Replaced `PIC PPPIC` with `PPPIC`
4. Removed IW from comments that do not need IW such as `LL` `LNF` and `3PTS`
5. Reordered the whole comment so it follows the flow of X IM IC AR IW WIRE
6. `[BC]` is removed since we don't really care if the pilot interacts with the AI LSO

This feature is being constantly improved upon but on a practical front it take grades like this:

`GRADE:--- : _SLOX_ WIRE# 3 _EGIW_` and turn them in to this: `_OK_ (Perfect): WIRE# 3`

and grades like this `GRADE: ---: _SLOX_ LURX LULX WIRE #2 _EGIW_` and turn them in to this: `OK (Acceptable): LURX WIRE #2`

## Bolter Detection
The server dcs.log does not properly detect bolters in landing grades. 
LSO BOT fixes this by checking for Waveoffs and if it detects a waveoff it will wait 6 seconds and then investigate the dcs.log for a takeoff event from the same pilot. 

So we can take these incorrectly scored waveoff: `GRADE:OWO : _LOIC_ _LOAR_ `

And replace it with the correct bolter grade: `B (Bolter): _LOIC_ _LOAR_`

## Embed Messages in Discord
LSO BOT by default will take grades and send them to Discord in a pretty embed messages like this:

![Embed messages](https://i.imgur.com/uFa56Fs.jpg)

This feature can be turned off in the config file.

# Installation

Review the [Installation](https://github.com/YoloWingPixie/lsobot/wiki/Installation-Guide) procedure in the wiki.

# Limitations

* The message displayed in Discord is different than the one the client gets on screen. This is a DCS problem, as the logged grade is different than the displayed grade. Regrading *can* make the reported grade nearly identical to the client's LSO score in *most cases* but it's not perfect.

* In theory, having a comma (`,`) in your display name could cause LsoBot to cut your name out of the message. 

# Logging

LSO BOT outputs the following logs to the Log folder in the project's root directory.

lsobot-debug : This logs the state of the script on each run to determine what steps it took. This is the main log you'll use for troubleshooting.
lsobot-rawGrades : These are the raw grades as reported from the DCS.log before regrading occurs with SLOX and EGIW removed.
lsoBot-reGrades : This log contains the regraded grades. 

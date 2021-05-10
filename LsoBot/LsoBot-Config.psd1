<# 
////////////////////////////////////////////// LSO BOT //////////////////////////////////////////////

Version: 1.1.0 dev

Join the Discord: https://discord.gg/nr9xb6YJfw

Contributors:
YoloWingPixie   | https://github.com/YoloWingPixie
Auranis         | https://github.com/Auranis

Special Thanks to:
Carrier Strike Group 8 - https://discord.gg/9h9QUA8

////////////////////////////////////////////// SETTINGS //////////////////////////////////////////////

    MANDATORY

    webHookUrl = The webhook URL for Discord

    logPath = The location of your dcs.log. The default should be correct for most server installs as long as you are running under the correct user.

    OPTIONS

    underlineStyle = Select if you want emphasis comments and perfect passes to be underlined (OK) or underscored like an APARTS trend analysis (_OK_) in Discord.
        See NAVAIR 00-80T-104 pg 11-4 for example differences.

        Accepts: "Underline" or "APARTS" 
        Fallback: "APARTS" 

    $hookStyle = Choose between basic text webhook messages and rich formatted embed text webhooks.
        Basic webhooks are more compact and look like a normal Discord message, which may hurt readability
        Embed webhooks are more readable but take up more space in the Discord message log. They also have accent colors that correspond with landing grades

        Accepts: "embed" or "basic"
        Fallback: "basic"
#>

@{
    
    webHookUrl  = 'https://discord.com/api/webhooks/NOTAREALWEBHOOKCHANGEME'

    logpath     = '$env:USERPROFILE\Saved Games\DCS.openbeta_server\Logs\dcs.log'
    #Only the environment variable $env:USERPROFILE is supported

    #////////////////////////////////////////////// OPTIONS //////////////////////////////////////////////

    underlineStyle = "Underline" 

    hookStyle = "embed"   

}
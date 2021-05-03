Unregister-ScheduledJob -Name "LSO Check"
Write-EventLog -LogName "Application" -Source "LSO Bot" -EventId 2 -EntryType Information -Message "LSO Bot has stopped" -Category 1

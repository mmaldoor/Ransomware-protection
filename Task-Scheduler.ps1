param([string]$Tar = (Read-Host "Enter the files you want to backup" ) ,
    [string]$Des = (Read-Host "Enter where you want to back them up"),
    [string]$File = (Read-Host "Enter the password for the backup file (optional)"),
    [string]$emai = (Read-Host "Enter your email if you want the reports (Optional)"))

  
$TaskName = "Backup-digsec"
$Trigger= New-ScheduledTaskTrigger -At 12:00am –Daily  
$Action= New-ScheduledTaskAction -Execute "C:\Program Files\PowerShell\7\pwsh.exe" -Argument "-ExecutionPolicy bypass -File C:\Users\user\documents\script.ps1 -Target $Tar -Destination $Des -FilePW $File -email $emai"  # Specify what program to run
Register-ScheduledTask -TaskName $TaskName -Trigger $Trigger -Action $Action -RunLevel Highest –Force 

# Unregister-ScheduledTask -TaskName Backup-digsec // To unregister the task 

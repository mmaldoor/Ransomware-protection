#Requires -RunAsAdministrator

param([Parameter(Position=0)][string]$Target = (Read-Host "Enter the files you want to backup" ) ,
[Parameter(Position=1)][string]$Destination = (Read-Host "Enter where you want to back them up"), #I tested taking backups to Onedrive.
[Parameter(Position=2)][string]$FilePW = (Read-Host "Enter the password for the backup file (optional)"),
[Parameter(Position=3)][string]$email = (Read-Host "Enter your email if you want the reports (Optional)"))
$splittarget = $Target -split " (?=[a-z]:)"  # To split the target paths. This makes it posibile to take backup from differents paths at the same time.


# Jeg valgte å lage en Rapport-test epost til testingsformål. Tenkte å fjerne den i starten etter testing, men jeg velger å stole på dere og lar den bli værende med passordet i koden. Jeg skal fjerne Eposten etter karaktergivning.
$User = "backup.digsec@gmail.com"
$PWord = ConvertTo-SecureString -String "digsec123" -as -Force
$smtpconfig = @{        
    Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $PWord
     From = $User
     To = $email
     SmtpServer ="smtp.gmail.com"   #Gmail sine smtp
     Port= 587                      #Porten de bruker 
     UseSsl = 1
}

# $password = $pps | ConvertTo-SecureString -asPlainText -Force

$software = "7-Zi*";
$installed = (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -Match $software })
$date = (Get-Date).ToString("yyyy-MM-dd")

# Install Chocolatey if its not installed.
if (!(Test-Path "C:\ProgramData\chocolatey\choco.exe")) {
    Write-Output "Installing Chocolatey.....";
    Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

# Install 7zip if its not installed.
if (!($installed.DisplayName -match "7-Zi*" )) {
    
    Write-Output "7Zip is not installed, installing...."
    choco install 7zip.install
}
# Enable windows defender If its not enabled
if ((Get-Service WinDefend).Status -eq "Stopped") {
    Write-Output "Enabling Windows Defender...."
    Start-Service WinDefend
    Set-Service WinDefend -StartupType Automatic
    Set-MpPreference -DisableScanningNetworkFiles $false -DisableRealtimeMonitoring $false -DisableScriptScanning $false
    Write-Output "Windows defender has been enabled. Restart the computer to activate Windows defenender (Critical)"
}
# Enable Controlled access folder if its not enabled If its not enabled
if ((Get-MpPreference).EnableControlledFolderAccess -eq 0) {
    Set-MpPreference -EnableControlledFolderAccess Enabled
    Write-Output "Enabling Controlled Folder Access"
}
# Add each folder of souce folders as a protected folder
foreach ($folder in $splittarget) {
    if ((Get-MpPreference).ControlledFolderAccessProtectedFolders -notcontains $folder) {
        Add-MpPreference -ControlledFolderAccessProtectedFolders $folder   
        Write-Output "Adding $folder as a protected folder"
    }
}
# Add This script as an exeption in case it wont get allowed to access the files

if ((Get-MpPreference).ControlledFolderAccessAllowedApplications -notcontains $MyInvocation.MyCommand.Path) {
    Add-MpPreference -ControlledFolderAccessAllowedApplications $MyInvocation.MyCommand.Path
    Write-Output "Adding this App as an exception"
}

#Update windows defender, scan and remove threats
Update-MpSignature
foreach ($path in $splittarget) {
    Start-MpScan -ScanPath "$path" -ScanType CustomScan 
}
Remove-MpThreat -ErrorAction Continue

#Make full virus scan, and full Backup on sundays
if ((Get-Date).DayOfWeek -like "Sunday") {
    Write-Output "Running Full virus scan...."
    Start-MpScan -ScanType FullScan 
    Remove-MpThreat -ErrorAction Continue 
    if ($FilePW) {
        # add multple $Destination\<archive> for multple destinaations
        $Backup = 7z a $Destination\"$date"-Fullbackup -p"$FilePW" -mhe $splittarget 
        Write-Output "Making a full backup...."
    }
    else {
        $Backup = 7z a $Destination\"$date"-Fullbackup -bd $splittarget 
        Write-Output "Making a full backup...."
    }

}
# Make incremental backup in normal days, and quick scans.
else {
    Write-Output "Running Quick virus scan...."
    Start-MpScan -ScanType QuickScan 
    Remove-MpThreat -ErrorAction Continue
    if ($FilePW) {
                # add multple -uq3r2y2z1w3 $Destination\<archive> for multple destinaations
        Write-Output "Backing up the source files......"
        $Backup = 7z u -uq3r2y2z1w3 $Destination\incremental.7z -p"$FilePW" -mhe $splittarget 
    }
    else {
        Write-Output "Backing up the source files......"
        $Backup = 7z u -uq3r2y2z1w3 $Destination\incremental.7z -bd $splittarget 
    }
  
}
# * "$?" contains the operation status of last command
# Send reports til the entered email
if ($email) {
    if ($?) {
        $logs = $Backup | Out-String
        $subject1 = "Backup Completed"

        Send-MailMessage @smtpconfig -Subject $subject1 -Body "$logs"
        
    }
    else {
        $er = $Error | Out-String
        $subject2 = "Backup Error"
        $body2 = "Something went wronge, backup is not complete $date `n `n  $er "
        Send-MailMessage @smtpconfig -Subject $subject2 -Body $body2
    }

    if ((Get-MpThreat).IsActive -ne 0) {
        $ThreatDetection = Get-MpThreatDetection | Out-String
        $subject = "Backup-Status. There is a threat that isnt removed!!"
        $body = "See the threat report $date `n `n  $ThreatDetection "
        

        Send-MailMessage @config -Subject $subject -Body $body
    }
}



# Ved ønske kan det legges en funksjon som starter ScheduledJob fra selve filen
# Det anbefales å hadrkode variablene til Target og Destination ved bruk av denne funksjonen


# param([string]$Tar = (Read-Host "Enter the files you want to backup" ) ,
#     [string]$Des = (Read-Host "Enter where you want to back them up"),
#     [string]$File = (Read-Host "Enter the password for the backup file (optional)"),
#     [string]$emai = (Read-Host "Enter your email if you want the reports (Optional)"))

# $Scriptet = {
#     bevege Scriptet her
# }

# $arguments = @(
#     $Tar,
#     $Des,
#     $files,
#     $emai
# )

# $joboption = New-ScheduledJobOption -RunElevated 
# $jobTrigger = New-JobTrigger -At 12:00am -Once -RepetitionInterval (New-TimeSpan -Minutes 1) -RepetitionDuration (New-Timespan -Minutes 5)//gjentar hver 5 min for testingsformål
# Register-ScheduledJob -Name "Backup" -Trigger $jobTrigger -ScheduledJobOption $joboption -ScriptBlock @Scriptet -ArgumentList $arguments

 



$software = "7-Zi*";
$installed = (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -Match $software })
$installed.displayname

#  check if choco is installed
if (!(Test-Path "C:\ProgramData\chocolatey\choco.exe")) {
    Write-Output "Seems Chocolatey is not installed, installing now"
    Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

if ($installed.displayname -match $software) {
    Write-Host "installed"
}

else {
    Write-Host "not-installed"
    Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}




# check if 7zip is installed
$appli = choco list --local-only | Select-Object 7zip

if ($appli -match "7zip") {

    Write-Output "It is installed"
}
else {
    Write-Output "its not"
}


$Backup = 7z u C:\Users\vnigh\OneDrive\NTNU\Programering\ar.7z -psecret -mhe C:\Users\vnigh\Documents\test


# run console as admin
Start-Process -FilePath pwsh.exe -ArgumentList { $ScriptBlock } -Verb RunAs


if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

# Your script here




Backup-ransomware@protonmail.com





# $FailMailParams = @{
#     To         = 'vnight95@gmail.com'
#     From       = 'vnight0@outlook.com'
#     Credential = New-Object System.Net.NetworkCredential("vnight0@outlook.com", "Thirst123");
#     Port       = '587'
#     SmtpServer = 'smtp-mail.outlook.com'
#     Subject    = 'Script Errors Out'
#     Body       = 'There was an error with the script!!'

# }
# Send-MailMessage $FailMailParams -UseSsl
# $backup = 7z u C:\Users\vnigh\OneDrive\NTNU\Programering\ar.7z -psecret -mhe C:\Users\vnigh\Documents\test

# if ($backup -contains "Everything is Ok") {

# $emailSmtpServer = "smtp-mail.outlook.com"
# $emailSmtpServerPort = "587"
# $emailSmtpUser = "vnight95@gmail.com"
# $emailSmtpPass = "Thirst123"




# $Credential = new System.Net.NetworkCredential("ransomwarebac@yandex.com", "backup123")

# $emailMessage = New-Object System.Net.Mail.MailMessage( "ransomwarebac@yandex.com" , "vnight95@gmail.com" )
# $emailMessage.Subject = "test" 
# $emailMessage.Body = "body"
# $emailMessage.IsBodyHTML = $true

 
# $SMTPClient = New-Object System.Net.Mail.SmtpClient("smtp.yandex.ru", 587 )
# $SMTPClient.UseDefaultCredentials = $false
# $SMTPClient.EnableSsl = $True
# $SMTPClient.Credentials = New-Object System.Net.NetworkCredential($User, $PWord);
# $SMTPClient.Send( $emailMessage )
# $SMTPClient.Timeout = 500000;


# if ((Get-MpPreference).ControlledFolderAccessProtectedFolders -notcontains $Target) {
#     foreach ($folder in $Target) {
#         # Add-MpPreference -ControlledFolderAccessProtectedFolders $folder   
#         Write-Output $folder
#     } 
# }



foreach ($path in $Target) {
    # Write-Output $path
    if ($controlledfolders -notcontains $path) {
        Write-Output $path
    }
}
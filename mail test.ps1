
$FilePW = (Read-Host "Enter the password for the backup file (optional)" -AsSecureString)

$test = ConvertFrom-SecureString -SecureString $FilePW 

    
7z u -uq3r2y2z1w3 "C:\Users\vnigh\Documents\FreshStart\incremental.7z" -p"$test" -mhe "C:\Users\vnigh\Documents\FreshStart" 
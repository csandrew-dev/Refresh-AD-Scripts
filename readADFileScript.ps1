#Powershell script to read Refresh machine  file and run commands
#Author: Andrew Schwartz
#Version: alpha 1.0
#06142023 created the intial script with name checking and comments
$VERSION = 06282023 #started this file, moves file to local and changes to ps1 file, executes, removes file.

$INFILE_PATH = "\\Test-DC\umd-its-share\ComputersToUMD-REFRESH.txt" #path to generated file
$EXCFILE_PATH = "C:\ComputersToUMD-REFRESH.ps1" #new path to run file as powershell on local machine cause can't run script without signage.

try{
    Move-Item -Path $INFILE_PATH -Destination $EXCFILE_PATH -ErrorAction Stop #moves the file and changes to .ps1 for executing
    & $EXCFILE_PATH #executes file 
    Remove-Item -Path $EXCFILE_PATH #removes file so no errors occur during the move next time.
}catch [System.Management.Automation.ItemNotFoundException]{ #catch file not found error, means no machines needed to be added to refresh
    Write-Host "File does not exist, not machines to image."
}
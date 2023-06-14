#Powershell script to check AD objects(computers) and format them into a text file
#Author: Andrew Schwartz
#Version: alpha 1.0
#06142023 created the intial script with name checking and comments
$VERSION = 06142023 #change version when updating

Write-Host "`n `n
 _____       __              _                _____     _____           _       _   
|  __ \     / _|            | |         /\   |  __ \   / ____|         (_)     | |  
| |__) |___| |_ _ __ ___ ___| |__      /  \  | |  | | | (___   ___ _ __ _ _ __ | |_ 
|  _  // _ |  _| '__/ _ / __| '_ \    / /\ \ | |  | |  \___ \ / __| '__| | '_ \| __|
| | \ |  __| | | | |  __\__ | | | |  / ____ \| |__| |  ____) | (__| |  | | |_) | |_ 
|_|  \_\___|_| |_|  \___|___|_| |_| /_/    \_|_____/  |_____/ \___|_|  |_| .__/ \__|
                                                                         | |        
                                                                         |_|        


 vrs: $VERSION
                                                                         `n `n"


$REFRESH_GROUP = UMD-REFRESH
$COMPUTER_NAME
$MENU_CHOICE
$OUTFILE_PATH = "C:\Users\Administrator\Desktop\ComputersToUMD-REFRESH.txt"

Out-File $OUTFILE_PATH #create text file with computers to be added to UMD-REFRESH to be read from for other script

do{
    Write-Host "REFRESH AD ADDING TOOL"
    Write-Host "1. Add Computers to UMD-REFRESH"
    Write-Host "2. Quit program, press 'q'"
    $MENU_CHOICE = Read-Host "You choose"
    $COMPUTER_NAME = Read-Host "Input computer name (eg. UMD-******)"
    Write-Host  "Computer name is " $COMPUTER_NAME "`n"
    
    Compare-Machine($COMPUTER_NAME, $REFRESH_GROUP)

} until($MENU_CHOICE -eq 'q')

function Compare-Machine{

    param{
        $COMPUTER_NAME
        $REFRESH_GROUP
    }

    try{
            Get-ADComputer -Identity $COMPUTER_NAME -ErrorAction Stop | Out-Null #check if computer is in AD, but doens't pipe output to screen.
            $IsInRefresh = Get-ADGroupMember -Identity $REFRESH_GROUP | Where-Object {$_.name -eq $COMPUTER_NAME} #Checks if computer is in UMD-Refresh group and store in bool
            if($IsInRefresh){
            Write-Host "`n $COMPUTER_NAME is already in refresh" -ForegroundColor Green #Informs user machine is already in refresh
            exit #exits the script
        } elseif (!$IsInRefresh){
            Write-Host "`n $COMPUTER_NAME is not in refresh" -ForegroundColor Red #Informs user machine is not in refresh
        }
    }
    catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException]{
        Write-Host "`n $COMPUTER_NAME not found" -ForegroundColor Red #Informs user machine isn't in AD or that name is incorrect
    }
}

function Write-ADFile {
    param {
        $OUTFILE_PATH
        $COMPUTER_NAME
        $REFRESH_GROUP
    }
    


}
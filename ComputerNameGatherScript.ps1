#Powershell script to check AD objects(computers) and format them into a text file
#Author: Andrew Schwartz
#Version: alpha 1.0
#06142023 created the intial script with name checking and comments

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

$VERSION = 06142023 #change version when updating
$REFRESH_GROUP = UMD-REFRESH

$OUTFILE_PATH = "C:\Users\Administrator\Desktop\ComputersToUMD-REFRESH.txt"

Out-File $OUTFILE_PATH #create text file with computers to be added to UMD-REFRESH to be read from for other script

try{
    Get-ADComputer -Identity $COMPUTER_NAME -ErrorAction Stop | Out-Null #check if computer is in AD, but doens't pipe output to screen.
    $IsInRefresh = Get-ADGroupMember -Identity $REFRESH_GROUP | Where-Object {$_.name -eq $COMPUTER_NAME} 
    if($IsInRefresh){
    Write-Host "`n $COMPUTER_NAME is already in refresh" -ForegroundColor Green #Express not found error to user/tech
} elseif (!$IsInRefresh){
    Write-Host "`n $COMPUTER_NAME is not in refresh" -ForegroundColor Red 
}else{}
}
catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException]{
    Write-Host "`n $COMPUTER_NAME not found" -ForegroundColor Red #Express not found error to user/tech
}
#Powershell script to check AD objects(computers) and format them into a text file
#Author: Andrew Schwartz
#Version: alpha 1.0
#06142023 created the intial script with name checking and comments
$VERSION = 06212023 #change version when updating

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


$REFRESH_GROUP = "UMD-REFRESH"
$MENU_CHOICE
$COMPUTER
$OUTFILE_PATH = "\\Test-DC\umd-its-share\ComputersToUMD-REFRESH.txt"
#string array for host names that need to be added to refresh

function Write-ADFile {

    param ( [string] $COMPUTER )

    Write-Host "Adding $COMPUTER `n"
    Add-Content -Path $OUTFILE_PATH -Value "ADD-ADGroupMember -Identity $REFRESH_GROUP -Members $COMPUTER"
    
}

function Compare-Machine {

    param ( [string] $COMPUTER )


    try{
            Get-ADComputer -Identity $COMPUTER -ErrorAction Stop | Out-Null #check if computer is in AD, but doens't pipe output to screen.
            $IsInRefresh = Get-ADGroupMember -Identity $REFRESH_GROUP | Where-Object {$_.name -eq $COMPUTER} #Checks if computer is in UMD-Refresh group and store in bool
           
        if($IsInRefresh){
            Write-Host "`n$COMPUTER is already in refresh!" -ForegroundColor Green #Informs user machine is already in refresh
        } elseif (!$IsInRefresh){
            Write-Host "`n$COMPUTER is not in refresh, adding..." -ForegroundColor Red #Informs user machine is not in refresh
            Write-ADFile($COMPUTER)
        }
    }
    catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException]{
        Write-Host "`n$COMPUTER not found `n" -ForegroundColor Red #Informs user machine isn't in AD or that name is incorrect
    }
}



do{
    Write-Host "REFRESH AD ADDING TOOL"
    Write-Host "1. Add Computers to UMD-REFRESH"
    Write-Host "2. Quit program, press 'q'"
    $MENU_CHOICE = Read-Host "You choose"
    switch($MENU_CHOICE){
        1{

            $HOSTNAMES = Read-Host -Prompt "Enter hostnames (separated by commas)"
            # Convert the input into an array of hostnames
            $HOSTNAMES -replace '\s', ''
            $HOSTNAMESARRAY = $HOSTNAMES -split ','

            $HOSTNAMESARRAY | ForEach-Object {
                $COMPUTER = $_
                Compare-Machine ($COMPUTER) #checks if machine name is valid
            }
            
        }
        2{
            exit #if they misundstand directions
        }
    }#close switch
    

} until($MENU_CHOICE -eq 'q')
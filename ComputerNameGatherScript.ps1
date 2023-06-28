#Powershell script to check AD objects(computers) and format them into a text file
#Author: Andrew Schwartz
#Version: alpha 1.0
#06142023 created the intial script with name checking and comments
#06282023 added the description editing
$VERSION = 06282023 #change version when updating


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


$REFRESH_GROUP = "UMD-REFRESH" #Variable for Refresh Group
$MENU_CHOICE #Menu variable for choosing option
$COMPUTER #computer name variable
$OUTFILE_PATH = "\\Test-DC\umd-its-share\ComputersToUMD-REFRESH.txt" #UNC path for machines to be added to refreshs text file on shared drive

function Write-ADFile {

    param ( [string] $COMPUTER ) #pass in computer

    Add-Content -Path $OUTFILE_PATH -Value "`$COMPUTERNAME = Get-ADComputer -Identity $COMPUTER" #writes out the get-Computer command and stores in var computer name
    Add-Content -Path $OUTFILE_PATH -Value "ADD-ADGroupMember -Identity $REFRESH_GROUP -Members `$COMPUTERNAME" #writes out the add-groupmember command with proper formatting
    
}

function Write-Description {
    
   param ( [string] $COMPUTER ) #pass in computer

   $DESCRIPTION = Read-Host -Prompt "Enter $COMPUTER's description. Follow this format: UM-D [Unit] [Department] [Building] [Room Number]" #asks for description input and stores in description var
   Add-Content -Path $OUTFILE_PATH -Value "Set-ADComputer -Identity $COMPUTER -Description `"$DESCRIPTION`"" #adds the descripting editing command to file

   Write-Host "Adding $COMPUTER, $DESCRIPTION `n" #prints out what is being "added" with name and description


} 

function Compare-Machine {

    param ( [string] $COMPUTER ) #pass in computer


    try{
            Get-ADComputer -Identity $COMPUTER -ErrorAction Stop | Out-Null #check if computer is in AD, but doens't pipe output to screen.
            $IsInRefresh = Get-ADGroupMember -Identity $REFRESH_GROUP | Where-Object {$_.name -eq $COMPUTER} #Checks if computer is in UMD-Refresh group and store in bool
           
        if($IsInRefresh){
            Write-Host "`n$COMPUTER is already in refresh!" -ForegroundColor Green #Informs user machine is already in refresh
        } elseif (!$IsInRefresh){
            Write-Host "`n$COMPUTER is not in refresh, adding..." -ForegroundColor Red #Informs user machine is not in refresh and goes through adding process
            Write-Description ($COMPUTER) #goes through description adding process, writes to file
            Write-ADFile($COMPUTER) #writes the get-computer and add-groupmember commands to file
        }
    }
    catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException]{ #error if machine doesn't exist in AD
        Write-Host "`n$COMPUTER not found, may not be in Active Directory `n" -ForegroundColor Red #Informs user machine isn't in AD or that name is incorrect
    }
}


do{
    Write-Host "REFRESH AD ADDING TOOL"
    Write-Host "1. Add Computers to UMD-REFRESH"
    Write-Host "2. Quit program, press 'q'"
    $MENU_CHOICE = Read-Host "You choose"
    switch($MENU_CHOICE){
        1{

            $HOSTNAMES = Read-Host -Prompt "Enter hostnames (separated by commas)" #asks for input of machines needed to be added e.g. 'UMD-000001, UMD-000002, ...'
            $HOSTNAMES -replace '\s', '' #removes all spaces in the string
            $HOSTNAMESARRAY = $HOSTNAMES -split ',' # Convert the input into an array of hostnames

            $HOSTNAMESARRAY | ForEach-Object { #loops through each machine 
                $COMPUTER = $_ #sets computer as current computer in array
                Compare-Machine ($COMPUTER) #checks if machine name is valid and sets file if necessary
            }
            
        }
        2{
            $MENU_CHOICE = 'q' #sets choice to 'q' so program quits
        }
    }#close switch
    

} until($MENU_CHOICE -eq 'q') #quits program

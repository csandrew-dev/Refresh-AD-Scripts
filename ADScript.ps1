#Powershell script to ADD computer object to UMD-REFRESH Security Group
#Author: Andrew Schwartz
#Version: alpha 1.0

do {

Write-Host "--Refresh AD Tools--"
Write-Host "1. Add computer to UMD-REFRESH (for imaging)"
Write-Host "2. Move computer in AD"
Write-Host "3. Quit"
$CHOICE=Read-Host "Chose a number to continue or press 'q' to quit"

#AD Query for computer
switch ($CHOICE) 
{
 1 {

$COMPUTERName = Read-Host "Input computer name (eg. UMD-******)"
Write-Host  "Computer name is " $COMPUTERName "`n"


$DESCRIPTION = Read-Host "Input computer AD description (eg. 'ML 1215')"
Write-Host  $COMPUTERName "'s description is " $DESCRIPTION ". `n"

Write-Host "Adding... `n"


$GROUP = Get-ADGroup -Identity UMD-REFRESH
$COMPUTER = Get-ADComputer -Identity $COMPUTERName

#Adding object to OU Group
ADD-ADGroupMember -Identity $GROUP -Members $COMPUTER

#Setting a description of Computer
Set-ADComputer -Identity $COMPUTER -Description $DESCRIPTION

Write-Host "Added. `n"
}
2{
#Moving computer in AD  
#feature maybe added later
}

}#close switch

}until ($CHOICE -eq 'q')

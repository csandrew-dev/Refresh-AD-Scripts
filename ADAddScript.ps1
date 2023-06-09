$COMPUTERName = Read-Host "Input computer name (eg. UMD-******)"
Write-Output "Computer name is " $COMPUTERName

$DESCRIPTION = Read-Host "Input computer AD description (eg. 'ML 1215')"
Write-Output $COMPUTERName "'s description is " $DESCRIPTION


$GROUP = Get-ADGroup -Identity UMD-REFRESH
$COMPUTER = Get-ADComputer -Identity $COMPUTERName

#Adding object to OU Group
ADD-ADGroupMember -Identity $GROUP -Members $COMPUTER

#Setting a description of Computer
Set-ADComputer -Identity $COMPUTER -Description $DESCRIPTION


Write-Host -NoNewLine 'Press any key to continue...';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
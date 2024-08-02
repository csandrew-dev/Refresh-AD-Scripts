# Powershell script to check AD objects (computers) and format them into a text file
# Author: Andrew Schwartz
# Version: alpha 1.2
# 06142023 created the initial script with name checking and comments
# 10142023 added OU information and category
# 11172023 added creation date and last logon information

param (
    [Alias("c")]
    [string]$COMPUTER_NAME
)

Write-Host "                                             
   ____    ___    ____ 
  / __ \  /   |  / __ \
 / / / / / /| | / / / /
/ /_/ / / ___ |/ /_/ / 
\___\_\/_/  |_/_____/

 vrs: $VERSION `n" -ForegroundColor DarkYellow

$VERSION = '11172023' #update version when adding improvements

try {
    $computer = Get-ADComputer -Identity $COMPUTER_NAME -Properties DistinguishedName, MemberOf, WhenCreated, LastLogonDate -ErrorAction Stop
    
    Write-Host "Computer Name:"
    Write-Host "    $COMPUTER_NAME" -ForegroundColor Cyan

    # Transform DistinguishedName to the desired format
    $distinguishedComponents = $computer.DistinguishedName -split ','
    $pathComponents = @()
    $domainComponents = @()

    # Process each component to handle the specific formatting rules.
    foreach ($component in $distinguishedComponents) {
        if ($component -like 'DC=*') {
            $domainComponents += ($component -replace 'DC=', '') + '.'
        } elseif ($component -like 'CN=*') {
            $pathComponents += ($component -replace 'CN=', '') + '/'
        } else {
            $pathComponents += ($component -replace 'OU=', '') + '/'
        }
    }

    # Reverse the domain components only and join them into the domain path.
    [Array]::Reverse($domainComponents)
    $domainPath = ($domainComponents -join '').TrimEnd('.')

    # Join the path components.
    [Array]::Reverse($pathComponents)
    $path = ($pathComponents -join '').TrimEnd('/')

    $transformedPath = "$domainPath/$path"

    Write-Host "Distinguished Name (OU Path):"
    Write-Host "    $transformedPath" -ForegroundColor Cyan
    
    # Write-Host "Creation Date: $($computer.WhenCreated)" -ForegroundColor Cyan
    # Write-Host "Last Logon Date: $($computer.LastLogonDate)" -ForegroundColor Cyan

    if ($computer.MemberOf) {
        $groups = $computer.MemberOf | ForEach-Object { Get-ADGroup -Identity $_ }

        # Create the table and convert it to a string
        $table = $groups | Select-Object @{Name="Group Name"; Expression={$_.Name}}, @{Name="Group DN"; Expression={$_.DistinguishedName}} | Format-Table -AutoSize | Out-String
        
        # Trim the leading and trailing new lines
        $table = $table.Trim()
        
        # Display the table in cyan
        Write-Host "Object Groups:"
        $table -split "`n" | ForEach-Object { Write-Host "    $_" -ForegroundColor Cyan }
    } else {
        Write-Host "No groups found" -ForegroundColor Yellow
    }

} catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException] {
    Write-Host "`n$COMPUTER_NAME not found" -ForegroundColor Red
}

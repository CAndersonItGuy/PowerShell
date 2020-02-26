function New-EndUserAdmin{
param(
[parameter(Mandatory=$True)][string]$Username,
[parameter(Mandatory=$True)][string]$ComputerName,
[parameter(Mandatory=$True)][string]$Password
)
$User = Get-ADUser -Identity $Username -Properties "Office","Department"
$office = $user.office
$Computer = Get-ADComputer -Identity $ComputerName

if ($office -like "BOSTON") {
$Street = "One Beacon Street Suite 5200"
$City = "BOSTON"
$State = "MA"
$ZIP = "02108"
$Country = "US"
}

if ($office -like "COLUMBUS") {
$Street = "250 S. High Street, Suite 300"
$City = "COLUMBUS"
$State = "OH"
$ZIP = "43215"
$Country = "US"
}

if ($office -like "HONG KONG") {
$Street = "10/F, Central Building, 1-3 Pedder Street, Central"
$City = ""
$State = ""
$ZIP = ""
$Country = ""
}

if ($office -like "LONDON") {
$Street = "230 City Road 3rd Floor"
$City = "LONDON"
$State = "UK"
$ZIP = "EC1V 2TT"
$Country = "GB"
}

if ($office -like "LOS ANGELES") {
$Street = "523 West 6th Street, Suite 300"
$City = "LOS ANGELES"
$State = "CA"
$ZIP = "90014"
$Country = "US"
}

if ($office -like "NEW YORK") {
$Street = "140 Broadway, 29th Floor"
$City = "NEW YORK"
$State = "NY"
$ZIP = "10005"
$Country = "US"
}

if ($office -like "SAN FRANCISCO") {
$Street = "88 Kearny Street Suite 900"
$City = "SAN FRANCISCO"
$State = "CA"
$ZIP = "94108"
$Country = "US"
}

if ($office -like "SEATTLE") {
$Street = "223 Yale Avenue North"
$City = "SEATTLE"
$State = "WA"
$ZIP = "98109"
$Country = "US"
}

if ($office -like "SHANGHAI") {
$Street = "Suite 2201 Wheelock Square 1717 West Nan Jing Road"
$City = "SHANGHAI"
$State = "PRC"
$ZIP = "200040"
$Country = "CN"
}

if ($office -like "PORTLAND") {
$Street = "310 SW 4th Ave"
$City = "Portland"
$State = "OR"
$ZIP = "97204"
$Country = "US"
}

$FirstName = $User.givenname
$LastName = $User.surname
$Name = "$FirstName $LastName - Admin"
$Description = "Admin account for $FirstName $LastName"
$SAM = ($User.SamAccountName + "Admin")
$OU = "OU=End-Users Local Admin,OU=Admin,OU=UserAccounts,DC=nbbj,DC=com"
$Department = $User.department

Add-ADGroupMember -Identity GPO_ComputerAllowedLocalAdmin -Members $Computer
Write-Output "Successfully added $ComputerName to GPO_ComputerAllowedLocalAdmin"

$secpasswd = ConvertTo-SecureString -String $Password -AsPlainText -Force
New-ADUser -Name $Name -GivenName $FirstName -Surname "$LastName - Admin" -DisplayName $Name -Office $Office -Description $Description -SamAccountName $SAM -AccountPassword $secpasswd -UserPrincipalName "$SAM@nbbj.com" -Enabled $True -Path $OU -Company NBBJ -Title $Description -StreetAddress $Street -City $City -State $State -PostalCode $ZIP -Country $Country -Department $Department -EmailAddress "$($User.SamAccountName)@nbbj.com"
Write-Output "Successfully created new account $SAM for $Name"

#Waiting for account to be created           
Start-Sleep 30

Add-ADGroupMember -Identity GPO_EndUserLocalAdmins -Members $SAM
Write-Output "Successfully added $SAM to GPO_EndUserLocalAdmins"

#Connecting to End Users computer and forcing it to update. Also adding admin to local admin group.

$scriptblock = 
    {
        klist -lh 0 -li 0x3e7 purge 
        Start-Process gpupdate -ArgumentList "/force" -Wait
        Add-LocalGroupMember Administrators -Member $using:SAM
        Start-Process gpupdate -ArgumentList "/force" -Wait
        Get-LocalGroupMember Administrators
    }
Invoke-Command -ComputerName $Computer.Name -ScriptBlock $scriptblock
}
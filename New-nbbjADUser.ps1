function New-NBBJADUser {
param(
[parameter(Mandatory=$True)][string]$EmployeeFirstName,
[parameter(Mandatory=$True)][string]$EmployeeLastName,
[parameter(Mandatory=$False)][string]$EmployeeDisplayName,
[parameter(Mandatory=$True)][string]$Office,
[parameter(Mandatory=$True)][string]$Telephone,
[parameter(Mandatory=$True)][string]$EmployeeTitle,
[parameter(Mandatory=$True)][string]$Department,
[parameter(Mandatory=$True)][bool]$WomansForum
)
#Initialize Variables
$FullName = ($EmployeeFirstName + " " + $EmployeeLastName)

If (!$EmployeeDisplayName) {
$EmployeeDisplayName = $FullName}

#Uses Office to populate other office variables
if ($office -like "BEIJING") {
$Street = "Room 1507 NCI Center
No 12 Jianguomenwai Avenue"
$City = "BEIJING"
$State = "PRC"
$ZIP = "100022"
$Country = "CN"
$UDrive = "\\nbbj.com\usrhome\SHA\"
}

if ($office -like "BOSTON") {
$Street = "One Beacon Street Suite 5200"
$City = "BOSTON"
$State = "MA"
$ZIP = "02108"
$Country = "US"
$UDrive = "\\nbbj.com\usrhome\BOS\"
}

if ($office -like "COLUMBUS") {
$Street = "250 S. High Street, Suite 300"
$City = "COLUMBUS"
$State = "OH"
$ZIP = "43215"
$Country = "US"
$UDrive = "\\nbbj.com\usrhome\COL\"
}

if ($office -like "HONG KONG") {
$Street = "10/F, Central Building, 1-3 Pedder Street, Central"
$City = ""
$State = ""
$ZIP = ""
$Country = ""
$UDrive = "\\nbbj.com\usrhome\SHA\"
}

if ($office -like "LONDON") {
$Street = "230 City Road 3rd Floor"
$City = "LONDON"
$State = "UK"
$ZIP = "EC1V 2TT"
$Country = "UK"
$UDrive = "\\nbbj.com\usrhome\LON\"
}

if ($office -like "LOS ANGELES") {
$Street = "523 West 6th Street, Suite 300"
$City = "LOS ANGELES"
$State = "CA"
$ZIP = "90014"
$Country = "US"
$UDrive = "\\nbbj.com\usrhome\LAX\"
}

if ($office -like "NEW YORK") {
$Street = "140 Broadway, 29th Floor"
$City = "NEW YORK"
$State = "NY"
$ZIP = "10005"
$Country = "US"
$UDrive = "\\nbbj.com\usrhome\NYC\"
}

if ($office -like "SAN FRANCISCO") {
$Street = "88 Kearny Street Suite 900"
$City = "SAN FRANCISCO"
$State = "CA"
$ZIP = "94108"
$Country = "US"
$UDrive = "\\nbbj.com\usrhome\SFO\"
}

if ($office -like "SEATTLE") {
$Street = "223 Yale Avenue North"
$City = "SEATTLE"
$State = "WA"
$ZIP = "98109"
$Country = "US"
$UDrive = "\\nbbj.com\usrhome\SEA\"
}

if ($office -like "SHANGHAI") {
$Street = "Suite 2201 Wheelock Square 1717 West Nan Jing Road"
$City = "SHANGHAI"
$State = "PRC"
$ZIP = "200040"
$Country = "CN"
$UDrive = "\\nbbj.com\usrhome\SHA\"
}

#BUild logic to error out if person with exact first name and last name already exists and then bail out.
#Checks if username is available and assigns first available
$Count = 1
$TempSAM = -join($EmployeeFirstName.Substring(0,$Count),$EmployeeLastName)
While ($(Get-ADObject -filter 'samaccountname -eq $TempSAM' -ErrorAction SilentlyContinue) -and $($count -le $EmployeeFirstName.Length))
    {
        $Count = $Count + 1 
        $TempSAM = -join($EmployeeFirstName.Substring(0,$Count),$EmployeeLastName)
     }      
            
if ($count -ge $EmployeeFirstName.length)
    {
        Write-Output "ERROR: Could not find acceptable SamAccountName."
        return 99
    }            
     Else
        {
            $UDrive = $UDrive + $TempSAM
            $TempSAM
            $UDrive
            $secpasswd = ConvertTo-SecureString -String "pa$$word1" -AsPlainText -Force
            New-ADUser -Name $FullName -GivenName $EmployeeFirstName -Surname $EmployeeLastName -DisplayName $EmployeeDisplayName -Office $Office -OfficePhone $Telephone -SamAccountName $TempSAM -AccountPassword $secpasswd -UserPrincipalName "$TempSAM@nbbj.com" -Enabled $True -Path "OU=Users,OU=UserAccounts,OU=!Migration,DC=nbbj,DC=com" -HomeDirectory $UDrive -Company NBBJ -Title $EmployeeTitle -StreetAddress $Street -City $City -State $State -PostalCode $ZIP -Country $Country -Department $Department
            Write-Output "Successfully created new account for $FUllName"
         }


}
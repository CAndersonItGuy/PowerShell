function Generate-NBBJPassword {
    <#
	.SYNOPSIS
		Generates a random password.
	.DESCRIPTION
        Simply randomly chooses one character at a time from the character list until length is met.  By default it uses
        the standard set of approved characters for a Windows password.
	.EXAMPLE
        Generate-NBBJPassword
        Generates a sixteen character password.
    .EXAMPLE
        Generate-NBBJPassword -Length 100
        Generates a 100 character password.
    .EXAMPLE
        $charList = [char[]]([char]48..[char]57)
        Generate-NBBJPassword -Length 24 -CharList $charList
        Generates a 24 character numeric password.
    .PARAMETER Length
        Length of password to be generated.
    .PARAMETER CharList
        Custom character array to include in password.
    .NOTES
        Added to Tech Services module 8/8/2018 - SC
    #>    

    Param(
    [Int32]$Length=16,
    [char[]]$CharList=([char[]]([char]33..[char]95)) + ([char[]]([char]97..[char]126))
    )
    
    $password = ""
    $i = 0
    while ($i -lt $length){$password += get-random -InputObject $charList ; $i++}
    return $password
    }

#Creates AD Account for Stargaze user
function New-StargazeUser {
[cmdletbinding()]
param(
[parameter(Mandatory=$True,ValueFromPipelineByPropertyName)][string]$FirstName,
[parameter(Mandatory=$True,ValueFromPipelineByPropertyName)][string]$LastName,
[parameter(Mandatory=$True,ValueFromPipelineByPropertyName)][string]$SAM,
[parameter(Mandatory=$False,ValueFromPipelineByPropertyName)][string]$DisplayName
)
#Initialize Variables
$FullName = ($FirstName + " " + $LastName)
$charList = ([char[]]([char]35..[char]38)) + ([char[]]([char]48..[char]57)) + ([char[]]([char]64..[char]90)) + ([char[]]([char]97..[char]122))
$Password = Generate-NBBJPassword -CharList $charList
#Names = Import-Csv "C:\Users\candersonadmin\Documents\PowerShellScripts\Names.csv"

if(!$DisplayName){
$DisplayName = $FullName
}

$UDrive = "\\nbbj.com\usrhome\NYC\" + $SAM
$secpasswd = ConvertTo-SecureString -String $Password -AsPlainText -Force

#Creates Remote mailbox and local AD account
New-RemoteMailbox -Name $FullName -FirstName $FirstName -Lastname $LastName -DisplayName $DisplayName  -SamAccountName $SAM -Password $secpasswd -UserPrincipalName "$SAM@nbbj.com"  -OnPremisesOrganizationalUnit "OU=NYC-XD,OU=Users,OU=UserAccounts,DC=nbbj,DC=com"

#Pause to allow account to be created.
Start-Sleep -Seconds 45

#Finishes configuring AD Account
Set-ADUser -Identity $SAM -Office "NEW YORK" -Description $DisplayName -Enabled $True -Company NBBJ -City "New York" -State "NY" -Country "US" -Department "NYCXD"
                            
Write-Output "Successfully created new account $SAM for $FullName"
"Username: $SAM for $Fullname created with Password: $Password" | Out-File -FilePath "C:\CreatedUsers.txt" -Append

#Sets KerberosEncryption
Set-ADUser -Identity $SAM -KerberosEncryptionType AES128,AES256

#Sets U: Drive
Set-ADUser -Identity $SAM -HomeDrive U: -HomeDirectory $UDrive

#Hides maiblox from GAL
Set-RemoteMailbox $SAM -HiddenFromAddressListsEnabled $True

#Disables ActiveSync and OWA for Devices
#Set-EOLCASMailbox -Identity $SAM -ActiveSyncEnabled $false -OWAforDevicesEnabled $false -OWAEnabled $false -confirm:$false

#Adds all groups from template
(Get-ADprincipalgroupmembership NewYorkNYCXD) | % {
    if ($_.name -ne "Domain Users") { add-adgroupmember -identity $_.distinguishedname -members $SAM
    Write-Output "Added to $_"
        }
    }
}
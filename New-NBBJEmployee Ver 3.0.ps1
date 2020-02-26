function New-NBBJEmployee{
param(
[parameter(Mandatory=$True)]
[ValidateSet("ColumbusCOL99","BostonDIG","BostonOS","HongKongDIG","HongKongHKG01","LondonDIG","LondonOS","LosAngelesOS","ShanghaiDIG","NewYorkNYCH1","ColumbusACCT","NewYorkNYCX3","NewYorkNYCXD","SeattleS41","NewYorkNYCCC","ColumbusMKTS","LosAngelesMKTS","ColumbusLegal","LondonLON01","SeattleS31","SeattleAP","NewYorkMKTS","SeattleOPS","ColumbusCOL55","LosAngelesLAX01","ShanghaiSHA01","SeattleSEA05","SeattleSEA07","SanFranciscoSFO","SanFranciscoMKTS","SeattleSEA09","SeattleSEA45","BostonAdmin","SeattleLegal","SeattleHR","SeattleOS","SanFranciscoOS","NewYorkOS","SeattleMKTS","SeattleCON01","SeattleSEAHC","ColumbusDIG","ColumbusHR","BostonBOS01","ColumbusOS")][string]$Template,
[parameter(Mandatory=$True)][string]$EmployeeFirstName,
[parameter(Mandatory=$True)][string]$EmployeeLastName,
[parameter(Mandatory=$False)][string]$EmployeeDisplayName,
[parameter(Mandatory=$True)][string]$Telephone,
[parameter(Mandatory=$False)][string]$EmployeeTitle,
[parameter(Mandatory=$True)]
[ValidateSet("BOSTON","COLUMBUS","HONG KONG","LONDON","LOS ANGELES","NEW YORK","SAN FRANCISCO","SEATTLE","SHANGHAI")][string]$Office,
[parameter(Mandatory=$True)][string]$Department,
[parameter(Mandatory=$False)][bool]$WomansForum,
[parameter(Mandatory=$False)][string]$Password,
[parameter(Mandatory=$True)][string]$Manager
)

New-NBBJRemoteMailbox -Template $Template -EmployeeFirstName $EmployeeFirstName -EmployeeLastName $EmployeeLastName -EmployeeDisplayName $EmployeeDisplayName -Office $Office -Department $Department -Telephone $Telephone -EmployeeTitle $EmployeeTitle -WomansForum $WomansForum -Password $Password -Manager $Manager

New-NBBJSkypeUser -EmployeeSAM $script:EmployeeSAM -Telephone $Telephone

}

#Creates AD Account
function New-NBBJRemoteMailbox {
param(
[parameter(Mandatory=$True)][string]$Template,
[parameter(Mandatory=$True)][string]$EmployeeFirstName,
[parameter(Mandatory=$True)][string]$EmployeeLastName,
[parameter(Mandatory=$False)][string]$EmployeeDisplayName,
[parameter(Mandatory=$True)][string]$Office,
[parameter(Mandatory=$True)][string]$Department,
[parameter(Mandatory=$True)][string]$Telephone,
[parameter(Mandatory=$False)][string]$EmployeeTitle,
[parameter(Mandatory=$False)][bool]$WomansForum,
[parameter(Mandatory=$False)][string]$Password,
[parameter(Mandatory=$False)][string]$Manager
)
#Initialize Variables
$FullName = ($EmployeeFirstName + " " + $EmployeeLastName)

If (!$Password){
    $charList = ([char[]]([char]35..[char]38)) + ([char[]]([char]48..[char]57)) + ([char[]]([char]64..[char]90)) + ([char[]]([char]97..[char]122))
    $Password = Generate-NBBJPassword -CharList $charList
    }

If (!$EmployeeDisplayName) {
    $EmployeeDisplayName = $FullName
    }

#Uses Office to populate other office variables

if ($office -like "BOSTON") {
$Street = "One Beacon Street Suite 5200"
$City = "BOSTON"
$State = "MA"
$ZIP = "02108"
$Country = "US"
$script:MailDB = "Database BOS01"
$script:RegistrarPool = "s15fepool0.nbbj.com"
$script:DialPlan = "NA-MA-Boston"
$script:CSVoicePolicy = "SIP-NA-WA-International"
$WomansForumGroup = "#Women's Forum (BOS)"
$OU = "OU=Boston,OU=Users,OU=UserAccounts,DC=nbbj,DC=com"
}

if ($office -like "COLUMBUS") {
$Street = "250 S. High Street, Suite 300"
$City = "COLUMBUS"
$State = "OH"
$ZIP = "43215"
$Country = "US"
$script:MailDB = "Database CMH02"
$script:RegistrarPool = "s15fepool0.nbbj.com"
$script:DialPlan = "NA-OH-Columbus"
$script:CSVoicePolicy = "SIP-NA-WA-International"
$WomansForumGroup = "#Women's Forum (COL)"
$OU = "OU=Columbus,OU=Users,OU=UserAccounts,DC=nbbj,DC=com"
}

if ($office -like "HONG KONG") {
$Street = "10/F, Central Building, 1-3 Pedder Street, Central"
$City = ""
$State = ""
$ZIP = ""
$Country = ""
$script:MailDB = "Database SHA01"
$script:RegistrarPool = "s15fepool0.nbbj.com"
$script:DialPlan = "CN-Shanghai"
$script:CSVoicePolicy = "SIP-NA-WA-International"
$WomansForumGroup = "#Women's Forum (SHA)"
$OU = "OU=Hong Kong,OU=Users,OU=UserAccounts,DC=nbbj,DC=com"
}

if ($office -like "LONDON") {
$Street = "230 City Road 3rd Floor"
$City = "LONDON"
$State = "UK"
$ZIP = "EC1V 2TT"
$Country = "GB"
$script:MailDB = "Database LON01"
$script:RegistrarPool = "LON-SFE-01.nbbj.com"
$script:DialPlan = "UK-London"
$script:CSVoicePolicy = "UK-London-International"
$WomansForumGroup = "#Women's Forum (LON)"
$OU = "OU=London,OU=Users,OU=UserAccounts,DC=nbbj,DC=com"
}

if ($office -like "LOS ANGELES") {
$Street = "523 West 6th Street, Suite 300"
$City = "LOS ANGELES"
$State = "CA"
$ZIP = "90014"
$Country = "US"
$script:MailDB = "Database LAX01"
$script:RegistrarPool = "s15fepool0.nbbj.com"
$script:DialPlan = "NA-CA-LosAngeles"
$script:CSVoicePolicy = "SIP-NA-WA-International"
$WomansForumGroup = "#Women's Forum (LAX)"
$OU = "OU=Los Angeles,OU=Users,OU=UserAccounts,DC=nbbj,DC=com"
}

if ($office -like "NEW YORK") {
$Street = "140 Broadway, 29th Floor"
$City = "NEW YORK"
$State = "NY"
$ZIP = "10005"
$Country = "US"
$script:MailDB = "Database NYC01"
$script:RegistrarPool = "s15fepool0.nbbj.com"
$script:DialPlan = "NA-NY-NewYork"
$script:CSVoicePolicy = "SIP-NA-WA-International"
$WomansForumGroup = "#Women's Forum (NYC)"
if ($Department -like "NYC-XD") {
    $OU = "OU=NYC-XD,OU=Users,OU=UserAccounts,DC=nbbj,DC=com"
    }
Else {
    $OU = "OU=New York,OU=Users,OU=UserAccounts,DC=nbbj,DC=com"
    }
}

if ($office -like "SAN FRANCISCO") {
$Street = "88 Kearny Street Suite 900"
$City = "SAN FRANCISCO"
$State = "CA"
$ZIP = "94108"
$Country = "US"
$script:MailDB = "Database SFO01"
$script:RegistrarPool = "s15fepool0.nbbj.com"
$script:DialPlan = "NA-CA-SanFrancisco"
$script:CSVoicePolicy = "SIP-NA-WA-International"
$WomansForumGroup = "#Women's Forum (SFO)"
$OU = "OU=San Francisco,OU=Users,OU=UserAccounts,DC=nbbj,DC=com"
}

if ($office -like "SEATTLE") {
$Street = "223 Yale Avenue North"
$City = "SEATTLE"
$State = "WA"
$ZIP = "98109"
$Country = "US"
$script:MailDB = "Database SEA01"
$script:RegistrarPool = "s15fepool0.nbbj.com"
$script:DialPlan = "NA-WA-Seattle"
$script:CSVoicePolicy = "SIP-NA-WA-International"
$WomansForumGroup = "#Women's Forum (SEA)"
$OU = "OU=Seattle,OU=Users,OU=UserAccounts,DC=nbbj,DC=com"
}

if ($office -like "SHANGHAI") {
$Street = "Suite 2201 Wheelock Square 1717 West Nan Jing Road"
$City = "SHANGHAI"
$State = "PRC"
$ZIP = "200040"
$Country = "CN"
$script:MailDB = "Database SHA01"
$script:RegistrarPool = "SHA-SFE-01.nbbj.com"
$script:DialPlan = "CN-Shanghai"
$script:CSVoicePolicy = "CN-Shanghai-International"
$WomansForumGroup = "#Women's Forum (SHA)"
$OU = "OU=Shanghai,OU=Users,OU=UserAccounts,DC=nbbj,DC=com"
}

if ($office -like "PORTLAND") {
$Street = "310 SW 4th Ave Suite 900"
$City = "Portland"
$State = "OR"
$ZIP = "97204"
$Country = "US"
$script:MailDB = "Database SEA01"
$script:RegistrarPool = "s15fepool0.nbbj.com"
$script:DialPlan = "NA-WA-Seattle"
$script:CSVoicePolicy = "SIP-NA-WA-International"
$WomansForumGroup = "#Women's Forum (SEA)"
$OU = "OU=Portland,OU=Users,OU=UserAccounts,DC=nbbj,DC=com"
}

#Formats Telephone number for AD User
If ($Telephone.Length -eq 10) { $TelphoneFormatted = '{0}.{1}.{2}' -f $Telephone.Substring(0,3),$Telephone.Substring(3,3),$Telephone.Substring(6,4)
$script:TelephoneFull = -join (1, $Telephone)
}
If ($Telephone.Length -eq 12 -and ($City -like "SHANGHAI" -or $City -like "HONG KONG")) { $TelphoneFormatted = '{0}.{1}.{2}.{3}' -f $Telephone.Substring(0,2),$Telephone.Substring(2,3),$Telephone.Substring(5,3),$Telephone.Substring(8,4)
$script:TelephoneFull = $Telephone
}
If ($Telephone.Length -eq 12 -and $City -like "LONDON") { $TelphoneFormatted = '{0}.{1}.{2}.{3}' -f $Telephone.Substring(0,2),$Telephone.Substring(2,2),$Telephone.Substring(4,4),$Telephone.Substring(8,4)
$script:TelephoneFull = $Telephone
}

#Checks if username is available and assigns first available
$Count = 1
$TempSAM = -join($EmployeeDisplayName.Substring(0,$Count),$EmployeeLastName)

<#>Debug
Write-Output "TempSAM: $TempSAM"
Write-Output "Count: $count"
Write-Output "EmployeeDisplayName: $EmployeeDisplayName"
Write-Output "EmployeeDisplayName.length = $($EmployeeDisplayName.length)"
</#>
While ($(Get-ADObject -filter 'samaccountname -eq $TempSAM' -ErrorAction SilentlyContinue) -and $($count -le $EmployeeDisplayName.Length))
    {
        #Debug
        #Write-Output "In While Loop.  TempSAM = $TempSAM.  Count = $count"
        $Count = ($Count + 1)
        $TempSAM = -join($EmployeeDisplayName.Substring(0,$Count),$EmployeeLastName)
        #Debug
        #Write-Output "end of While Loop.  TempSAM = $TempSAM.  Count = $Count"
     }      

if ($count -ge $EmployeeDisplayName.length)
    {
        Write-Output "ERROR: Could not find acceptable SamAccountName."
        return 99
    }            
     Else
        {
            #Debug
            #Write-Output "In Else branch.  TempSAM = $TempSAM"
            $secpasswd = ConvertTo-SecureString -String $Password -AsPlainText -Force

            #Creates Remote mailbox and local AD account
            New-RemoteMailbox -Name $FullName -FirstName $EmployeeFirstName -Lastname $EmployeeLastName -DisplayName $EmployeeDisplayName  -SamAccountName $TempSAM -Password $secpasswd -UserPrincipalName "$TempSAM@nbbj.com"  -OnPremisesOrganizationalUnit $OU

            #Pause to allow account to be created.
            Start-Sleep -Seconds 90

            #Finishes configuring AD Account
            Set-ADUser -Identity $TempSAM -Office $Office -Description $EmployeeDisplayName -OfficePhone $TelphoneFormatted -Enabled $True -Company "NBBJ" -Title $EmployeeTitle -StreetAddress $Street -City $City -State $State -PostalCode $ZIP -Country $Country -Department $Department

            #Enables In-Place archiving on mailbox
            Enable-RemoteMailbox -Identity $TempSAM -Archive
           
            Write-Output "Successfully created new account $TempSAM for $FullName with the Password: $Password"
            $script:EmployeeSAM = $TempSAM

            #Adds all groups from template
            (Get-ADprincipalgroupmembership $Template) | % {
            if ($_.name -ne "Domain Users") { add-adgroupmember -identity $_.distinguishedname -members $TempSAM
            Write-Output "Added to $_"
            }
            }#Adds WomanForum group if set
            If ($WomansForum -eq $True){
                Add-ADGroupMember -Identity $WomansForumGroup -Members $TempSAM
                Write-Output "Added to $WomansForumGroup"
                }

            #Sets KerberosEncryption
            Set-ADUser -Identity $TempSAM -KerberosEncryptionType AES128,AES256

            #Write-Output "Waiting 5 Min for account to finish being created"
            #Start-Sleep -Seconds 300

            Set-ADUser -Identity $TempSAM -Manager $Manager
         }


}

function New-NBBJSkypeUser {
param(
[parameter(Mandatory=$True)][string]$EmployeeSAM,
[parameter(Mandatory=$True)][string]$Telephone
)

#Checks to see that the account exists in EOL
$running = $true
while($running -eq $true){
    if($CheckUser -le '20'){
        $CheckUser++
        start-sleep -s 30
        if(Get-EOLMailbox $EmployeeSAM){
            $running = $false
        }
    }else{
    Throw "Unable to create SfB User"
    }
}

#Enables account once it is found
Enable-CsUser -Identity $EmployeeSAM -RegistrarPool $script:RegistrarPool -SipAddress sip:$EmployeeSAM@nbbj.com
Write-Output "Enabled CS User Successfully"

#Enables UM and sets PIN
Enable-EOLUMMailbox -Identity $EmployeeSAM -UMMailboxPolicy "O365-Default-DP Default Policy" -Pin 0$($Telephone.substring(6,4)) -SIPResourceIdentifier $EmployeeSAM@nbbj.com
Write-Output "Pin -"0$($Telephone.substring(6,4))
Write-Output "UM Enabled successfully"

Set-CsUser -Identity $EmployeeSAM -LineURI "tel:+$script:TelephoneFull;ext=$($Telephone.substring(6,4))" –AudioVideoDisabled $False –EnterpriseVoiceEnabled $True
Write-Output "Set-CSUser successfully"


Grant-CsDialPlan -Identity $EmployeeSAM -PolicyName $script:DialPlan
Write-Output "Enabled Dial plan"

Grant-CsVoicePolicy -Identity $EmployeeSAM -PolicyName $script:CSVoicePolicy
Write-Output "Enabled Voice policy"

#Enables ActiveSync, OWA and OWA for Devices
Set-EOLCASMailbox -Identity $EmployeeSAM -ActiveSyncEnabled $True -OWAforDevicesEnabled $True -OWAEnabled $True -confirm:$false
Write-Output "ActiveSync and OWA Enabled"
}

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
function Set-NBBJTerminated2{
param(
[parameter(Position=0)]
[string]$STRUser
)
If (!$STRUser) {
$STRUser = (Read-Host -Prompt 'Get username of terminated user') }
$User = Get-ADUser $STRUser
#Set today's date
$Date = Get-Date -format d

##AD Actions
#Disable AD account
Disable-ADAccount -Identity $User

#Displays User's phone number to make it easy to remove from IPAM.
Get-ADUser -Identity $User -Properties telephoneNumber | Select Name,telephoneNumber

#Change description to "Terminated on (today's date)" and removes OfficePhone number
Set-ADUser -Identity $User -Description "Terminated on $Date" -OfficePhone " "
        
#Move user object to terminations OU
Move-ADObject -Identity $User.DistinguishedName -TargetPath "OU=Terminations,DC=nbbj,DC=com"

#Hides user from GAL in On Prem Exchange
Start-Sleep -s 20
$User = Get-ADUser $STRUser
$objMailbox = Get-RemoteMailbox -Identity $user.DistinguishedName

Set-RemoteMailbox $User.SamaccountName -HiddenFromAddressListsEnabled $True

#Skype Actions
$SkypeUser = (Get-CsUser $STRUser)
#Remove assigned DID, Changes Telephony to "PC-to-PC Only" and unchecks Enable from Skype for Business Server.
If ($SkypeUser)
    {   
        Set-CsUser -Identity $User.DistinguishedName -LineURI "" –AudioVideoDisabled $True –RemoteCallControlTelephonyEnabled $False –EnterpriseVoiceEnabled $False -Enabled $False
        
#Revoke User Certificate (added by MM 6/19/18) 
        Revoke-CsClientCertificate -Identity $User.DistinguishedName
    }
else {Write-Output "$($User.SamAccountName) not in Skype."
    }

#Removes User from Groups
Get-ADPrincipalGroupMembership $User.SamAccountName | % {
if ($_.name -ne "Domain Users") {remove-adgroupmember -identity $_ -member $User -Confirm:$False
    Write-Output "Removed from $_"
    }
}
#Adds user to Steve's group for disabled mailbox backup
Add-ADGroupMember -Identity Temporary_DisabledUsersMailboxBackup -Members $User
Write-Output "Added to Temporary_DisabledUsersMailboxBackup Group"

#Adds user to group that protects it from automated deletion
Add-ADGroupMember -Identity automation_protectedfromdisabledelete -Members $User
Write-Output "Added to automation_protectedfromdisabledelete Group"

#Sleep to let changes settle
Start-Sleep -Seconds 90

#Writes AD Outputs
Write-Output "Account Summary:"
Write-Output "AD Account Enabled: $($User.Enabled)"
Write-Output "$($User.SamAccountName) description set to Terminated on $($Date)"

#Writes Exchange Outputs
Write-Output "$($user.DistinguishedName): Hidden from GAL: $($objMailbox.HiddenFromAddressListsEnabled)"
Write-Output "UM Enabled: $($objMailbox.UMEnabled)"
Write-Output "ActiveSync Enabled: $($objMailboxCAS.ActiveSyncEnabled) `n OWA for Devices Enabled: $($objMailboxCAS.OWAforDevicesEnabled) `n OWA Enabled: $($objMailboxCAS.OWAEnabled)"

#Writes Skype Outputs
Write-Output "Line URI: $($Skypeuser.LineURI) `n AudioVideo Disabled: $($Skypeuser.AudioVideoDisabled) `n RemoteCallControlTelephoney Enabled: $($Skypeuser.RemoteCallControlTelephonyEnabled) `n EnterpriseVoice Enabled: $($Skypeuser.EnterpriseVoiceEnabled) `n Enabled: $($Skypeuser.Enabled)"
Write-Output "Revoked CsClient Certificate for $($User.SamAccountName)"
}
function Set-NBBJOOO {
param(
[parameter(Mandatory=$True)][string]$User,
[parameter(Mandatory=$True)][string]$Contact
)

$UserName = (Get-ADUser $User).Name
$ContactName = (Get-ADUser $Contact).Name
$ContactMailbox = (Get-EOLmailbox $Contact).UserPrincipalName

Set-EOLMailboxAutoReplyConfiguration -Identity $User -AutoReplyState Enabled -InternalMessage "Thank you for your email. $UserName is no longer with NBBJ.  For assistance with an active project or a new project opportunity, please contact $ContactName at $ContactMailbox." -ExternalMessage "Thank you for your email. $UserName is no longer with NBBJ.  For assistance with an active project or a new project opportunity, please contact $ContactName at $ContactMailbox."

}
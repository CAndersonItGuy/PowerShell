function Set-StarGaze365Permission{
param(
[parameter(Mandatory=$True)][string]$User
)

Set-MsolUser -UserPrincipalName $User -UsageLocation "US"
Set-MsolUserLicense -UserPrincipalName $User -AddLicenses nbbj4:ENTERPRISEPACK,nbbj4:EMS

}
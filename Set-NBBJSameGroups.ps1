function Set-NBBJSameGroups {
param(
[parameter(Mandatory=$True)][string]$ReferenceAccount,
[parameter(Mandatory=$True)][string]$TargetAccount
)

$Groups = Get-ADPrincipalGroupMembership -Identity $ReferenceAccount 

foreach ($Group in $Groups) {
        Add-ADGroupMember -Identity $Group -Members $TargetAccount
        Write-Output "$TargetAccount added to $group"
        }
}
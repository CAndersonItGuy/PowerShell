$Names = Import-Csv "C:\Users\candersonadmin\Documents\PowerShellScripts\Names.csv"


ForEach ($Name in $Names) {
    $FirstName = $Name.FirstName
    $LastName = $Name.Lastname
    $nameFilter = -join($FirstName.Substring(0,1),$LastName)
    If (Get-ADUser -filter 'SAMAccountName -eq $nameFilter' -ErrorAction SilentlyContinue) {
    Write-Output "$NameFilter is already in use by existing employee"
    "$nameFilter,$FirstName,$LastName" | Out-File -FilePath "C:\Users\candersonadmin\Documents\PowerShellScripts\Conflicts.csv" -Append
    } Else {
     Write-Output "$NameFilter is available"
     "$NameFilter,$FirstName,$LastName" | Out-File -FilePath "C:\Users\candersonadmin\Documents\PowerShellScripts\Good2go.csv" -Append
    }
}
function Get-NBBJExt{
    param(
    [parameter(Mandatory=$True)][string]$Ext
    )
    $filter = "LineURI -like `"*$Ext`""
    Get-CsUser -Filter $filter
    }
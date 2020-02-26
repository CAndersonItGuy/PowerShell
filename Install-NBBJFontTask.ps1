$fontFolder = "C:\NBBJFonts"
$DateForFile = Get-Date -Format "yyyyMMdd_"
$Log = "c:\windows\ccm\logs\" + $DateForFile + "FontInstall.log"
$installPath = "C:\Program Files\NBBJFontsInstaller"
$registryPathFlag = "HKLM:\Software\NBBJ\InstallFlags"

if(!(Test-Path $installPath))
{
    New-Item -Path "C:\Program Files\" -Name "NBBJFontsInstaller" -ItemType "directory"
    Write-Output "NBBJFontsInstaller folder is missing. Creating it now."
    
}

if(!(Test-Path $fontFolder))
{
    New-Item -Path "C:\" -Name "NBBJFonts" -ItemType "directory"
    Write-Output "NBBJFonts folder is missing. Creating it now."
    
}

$dateForFile = Get-Date -Format "yyyyMMdd_"
$logPath = "c:\windows\ccm\logs\$dateForFile" + "Script_Install-NBBJFonts.log"
Write-Output "$(Get-Date -format "[HH:mm:ss]") Beginning script NBBJFontInstaller against path $fontFolder" | Tee-Object -FilePath $logPath -append
Write-Output "$(Get-Date -format "[HH:mm:ss]") Attempting to fix permissions." | Tee-Object -FilePath $logPath -append
$acl = Get-Acl -Path $fontFolder
$UserRule = New-Object System.Security.AccessControl.FileSystemAccessRule("Authenticated Users","Modify", "ContainerInherit, ObjectInherit", "None", "Allow")
$acl.SetAccessRuleProtection($True,$False) #Break inheritance, don't copy existing perms.
$acl.AddAccessRule($UserRule)
Set-Acl $fontFolder $acl
Write-Output "$(Get-Date -format "[HH:mm:ss]") Attempt complete.  Permissions after attempt:" | Tee-Object -FilePath $logPath -append
Write-Output $(Get-Acl $servicePath).access

Write-Output "$(Get-DateHeader) Attempting Scheduled Task Install." | Tee-Object -FilePath $Log
        $TaskName = "Install NBBJ Fonts"
        $XmlName = ".\InstallNBBJFonts.xml"
        if (schtasks /query | where {$_ -like "*$taskname*"}) #If task already exists, delete it.
            {
                Write-Output "$(Get-DateHeader)Existing task named `"$taskname`" found.  Deleting and recreating." | Tee-Object -FilePath $Log
                schtasks /delete /tn $taskName /F
            }
        schtasks /create /xml $xmlName /tn $taskName #create task

if (!(Test-Path $registryPathFlag))
        {New-Item -Path $registryPathFlag -Force} # Check if InstallFlags path exists and creates if not.
    New-ItemProperty -Path $registryPathFlag -Name "NBBJFontInstallDate" -Value $(Get-Date -Format "yyyyMMdd") -PropertyType DWORD -Force
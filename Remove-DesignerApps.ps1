$prod = get-wmiobject win32_product
$prod | select vendor, caption, version | sort vendor, caption, version | ft
$prod | where {$_.vendor -like "autodesk*"} | % {$_.uninstall()}
$prod | where {$_.vendor -like "robert*"} | % {$_.uninstall()}
$prod | where {$_.vendor -like "unifi*"} | % {$_.uninstall()}
$prod | where {$_.vendor -like "ideate*"} | % {$_.uninstall()}
$prod | where {$_.vendor -like "blue*"} | % {$_.uninstall()}
$prod | where {$_.vendor -like "adobe*"} | % {$_.uninstall()}
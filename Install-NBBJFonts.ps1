$fontFolder = "C:\NBBJFonts"
$padVal = 20
$installLabel = "Installing Font".PadRight($padVal," ")
$openType = "(Open Type)"
$regPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"
$objShell = New-Object -ComObject Shell.Application
if(!(Test-Path $fontFolder))
{
    Write-Warning "$fontFolder - Not Found"
}
else
{
    $objFolder = $objShell.namespace($fontFolder)
 
        Try{
            $destination = "c:\Windows\Fonts"
            foreach ($file in $objFolder.items())
            {
                $fileType = $($objFolder.getDetailsOf($file, 2))
                if(($fileType -eq "OpenType font file") -or ($fileType -eq "TrueType font file")) {
                    $fontName = $($objFolder.getDetailsOf($File, 21))
                    $regKeyName = $fontName,$openType -join " "
                    $regKeyValue = $file.path.split('\')[$file.path.split('\').count -1]
                    Write-Output "$installLabel : $regKeyValue"
                    Copy-Item $file.Path  $destination
                    New-ItemProperty -Path $regPath -Name $regKeyname -Value $regKeyValue -PropertyType String -Force
                    }
             }
            
        }
        catch{
            Write-Warning "$errorLabel : $regKeyValue did not install successfully"
        }
    
}
# Outputs a line of a DirectoryInfo or FileInfo

function FileInfo {
    param (
        [Parameter(Mandatory=$True,Position=1)]
        $Item
    )

    $ParentName = $Item.PSParentPath.Replace("Microsoft.PowerShell.Core\FileSystem::", "")

    If ($Script:LastParentName -ne $ParentName) {
       $Color = $GetChildItemColorTable.File['Directory']
       $ParentName = $Item.PSParentPath.Replace("Microsoft.PowerShell.Core\FileSystem::", "")

       Write-Host
       Write-Host "    Directory: " -noNewLine -ForegroundColor $global:GetChildItemColorTable.Match.Default
       Write-Host " $($ParentName)`n" -ForegroundColor $Color

       For ($l=1; $l -lt $GetChildItemColorVerticalSpace; $l++) {
           Write-Host ""
       }

       Write-Host "Mode                LastWriteTime     Length Name" -ForegroundColor $global:GetChildItemColorTable.Match.LineNumber
       Write-Host "----                -------------     ------ ----" -ForegroundColor $global:GetChildItemColorTable.Match.Line
    }

    $Color = Get-FileColor $Item

    Write-Color-LS $Color $Item

    $Script:LastParentName = $ParentName
}

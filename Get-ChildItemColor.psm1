Add-Type -assemblyname System.ServiceProcess

$PsColorResources = @(
    "./private/CutString.ps1",
    "./private/FileInfo.ps1",
    "./private/LengthInBufferCell.ps1",
    "./private/MatchInfo.ps1",
    "./private/ProcessInfo.ps1",
    "./private/PSColorHelper.ps1",
    "./private/ServiceController.ps1",
    "./private/Write-Color-LS.ps1",
    "./private/Write-Color-Service.ps1",
    "./private/Write-FileLength.ps1",
    "./public/Get-ChildItemColor.ps1",
    "./public/Get-ChildItemColorFormatWide.ps1",
    "./public/Get-ChildItemColorTable.ps1",
    "./public/Get-FileColor.ps1",
    "./public/Out-Default.ps1"
    )

#Dotsource all the resources.
ForEach ($resource in $PsColorResources) {
    . (Join-Path -Path $PSScriptRoot -ChildPath $resource)
}

$script:showHeader=$true
$OriginalForegroundColor = $Host.UI.RawUI.ForegroundColor
if ([System.Enum]::IsDefined([System.ConsoleColor], 1) -eq "False") { $OriginalForegroundColor = "Gray" }

$Global:GetChildItemColorVerticalSpace = 1

Get-ChildItemColorTable

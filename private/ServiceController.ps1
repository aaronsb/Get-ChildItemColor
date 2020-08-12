# Outputs a line of a ServiceController
function ServiceController {
    param (
        [Parameter(Mandatory=$True,Position=1)]
        $Service
    )

    if($script:showHeader)
    {
       Write-Host
       Write-Host "Status   Name               DisplayName"
       $script:showHeader=$false
    }

    if ($Service.Status -eq 'Stopped')
    {
        Write-Color-Service $Global:GetChildItemColorTable.Service["Stopped"] $Service
    }
    elseif ($Service.Status -eq 'Running')
    {
        Write-Color-Service $Global:GetChildItemColorTable.Service["Running"] $Service
    }
    else {
        Write-Color-Service $Global:GetChildItemColorTable.Service["Default"] $Service
    }
}

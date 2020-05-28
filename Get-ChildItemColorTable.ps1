
Function Get-ChildItemColorTable {
    [CmdletBinding()]
    Param([switch]$ResetDefaults,[switch]$ShowColors)

    if ($ShowColors) {
        if ($global:GetChildItemColorTable) {
            Write-Host "----------  File Objects   ----------"
            ForEach ($Item in $global:GetChildItemColorTable.File.Keys) {
                Write-Host ("$Item : " + $global:GetChildItemColorTable.File.$Item) -ForegroundColor $global:GetChildItemColorTable.File.$Item
            }
            Write-Host "----------   Formatting    ----------"
            ForEach ($Item in $global:GetChildItemColorTable.Match.Keys) {
                Write-Host ("$Item : " + $global:GetChildItemColorTable.Match.$Item) -ForegroundColor $global:GetChildItemColorTable.Match.$Item
            }
            Write-Host "---------- Service Status  ----------"
            ForEach ($Item in $global:GetChildItemColorTable.Service.Keys) {
                Write-Host ("$Item : " + $global:GetChildItemColorTable.Service.$Item) -ForegroundColor $global:GetChildItemColorTable.Service.$Item
            }
        }
    }
    $UserExtensionMapPath = (Join-Path -Path (gci $profile).DirectoryName -ChildPath "ExtensionMap.json")
    $UserTypeMapPath = (Join-Path -Path (gci $profile).DirectoryName -ChildPath "TypeMap.json")
    
    $ExtensionMapPath = (Join-Path -Path $PSScriptRoot -ChildPath "ExtensionMap.json")
    $TypeMapPath = (Join-Path -Path $PSScriptRoot -ChildPath "TypeMap.json")
    
    if ($ResetDefaults) {
        Write-Warning "Restting user profile mappings to default."
        Copy-Item $ExtensionMapPath $UserExtensionMapPath
        Copy-Item $TypeMapPath $UserTypeMapPath
    }
    if (Test-Path $UserExtensionMapPath) {
        Write-Verbose "Using user profile extension map."
        $ExtensionMapPath = $UserExtensionMapPath
    }
    else {
        Write-Warning "User profile extension map path not found, creating default template."
        Copy-Item $ExtensionMapPath $UserExtensionMapPath 
    }

    if (Test-Path $UserTypeMapPath) {
        Write-Verbose "Using user profile type map."
        $ExtensionMapPath = $UserExtensionMapPath
    }
    else {
        Write-Warning "User profile type map path not found, creating default template."
        Copy-Item $TypeMapPath $UserTypeMapPath 
    }


    
    if (Test-Path $ExtensionMapPath){
        $Global:GetChildItemColorExtensions = @{}
        (Get-Content $ExtensionMapPath | ConvertFrom-Json).psobject.properties | ForEach-Object { $global:GetChildItemColorExtensions[$_.Name] = $_.Value }
        Write-Verbose "Loaded Extension Map"
    }

    if (Test-Path $TypeMapPath){
        $TypeMap = @{}
        (Get-Content $TypeMapPath | ConvertFrom-Json).psobject.properties | ForEach-Object { $TypeMap[$_.Name] = $_.Value }
        Write-Verbose "Loaded Type Map"
    }
    Write-Verbose "Resetting Color Table"
    $Global:GetChildItemColorTable = @{
        File = @{ Default = $OriginalForegroundColor }
        Service = @{ Default = $OriginalForegroundColor }
        Match = @{ Default = $TypeMap.Type.Format.Default }
    }

    $GetChildItemColorTable.File.Add('Directory', $TypeMap.Type.Meta.Directory)
    $GetChildItemColorTable.File.Add('Symlink', $TypeMap.Type.Meta.Symlink) 

    ForEach ($Type in $GetChildItemColorExtensions.Keys) {
        ForEach ($Color in ($TypeMap.Type.File.$Type)) {
            ForEach ($Extension in $GetChildItemColorExtensions.$Type) {
                $GetChildItemColorTable.File.Add($Extension, $Color)
            }
        }
    }
    
    $GetChildItemColorTable.Service.Add('Running', $TypeMap.Type.Service.Running)
    $GetChildItemColorTable.Service.Add('Stopped', $TypeMap.Type.Service.Stopped)

    $GetChildItemColorTable.Match.Add('Path', $TypeMap.Type.Format.Path)
    $GetChildItemColorTable.Match.Add('LineNumber', $TypeMap.Type.Format.LineNumber)
    $GetChildItemColorTable.Match.Add('Line', $TypeMap.Type.Format.Line)

}


Export-ModuleMember Get-ChildItemColorTable
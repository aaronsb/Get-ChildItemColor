
Function Get-ChildItemColorTable {
    $UserExtensionMapPath = (Join-Path -Path (gci $profile).DirectoryName -ChildPath "ExtensionMap.json")
    $UserTypeMapPath = (Join-Path -Path (gci $profile).DirectoryName -ChildPath "TypeMap.json")
    
    $ExtensionMapPath = (Join-Path -Path $PSScriptRoot -ChildPath "ExtensionMap.json")
    $TypeMapPath = (Join-Path -Path $PSScriptRoot -ChildPath "TypeMap.json")
    
    if ($UserExtensionMapPath) {
        Write-Warning "Using user profile extension map"
        $ExtensionMapPath = $UserExtensionMapPath
    }
    else {
        Write-Warning "User profile extension map path not found, creating default template."
        Copy-Item $UserExtensionMapPath $ExtensionMapPath
    }

    if ($UserTypeMapPath) {
        Write-Warning "Using user profile type map"
        $ExtensionMapPath = $UserExtensionMapPath
    }
    else {
        Write-Warning "User profile type map path not found, creating default template."
        Copy-Item $UserTypeMapPath $TypeMapPath
    }


    
    if (Test-Path $ExtensionMapPath){
        $Global:GetChildItemColorExtensions = @{}
        (Get-Content $ExtensionMapPath | ConvertFrom-Json).psobject.properties | ForEach-Object { $global:GetChildItemColorExtensions[$_.Name] = $_.Value }
        Write-Warning "Loaded ExtensionMap"
    }

    if (Test-Path $TypeMapPath){
        $ColorMap = @{}
        (Get-Content $TypeMapPath | ConvertFrom-Json).psobject.properties | ForEach-Object { $ColorMap[$_.Name] = $_.Value }
        Write-Warning "Loaded TypeMap"
    }
    Write-Warning "Resetting Color Table"
    $Global:GetChildItemColorTable = @{
        File = @{ Default = $OriginalForegroundColor }
        Service = @{ Default = $OriginalForegroundColor }
        Match = @{ Default = $OriginalForegroundColor }
    }

    $GetChildItemColorTable.File.Add('Directory', $ColorMap.Type.Meta.Directory)
    $GetChildItemColorTable.File.Add('Symlink', $ColorMap.Type.Meta.Symlink) 

    ForEach ($Type in $GetChildItemColorExtensions.Keys) {
        ForEach ($Color in ($ColorMap.Type.File.$Type)) {
            ForEach ($Extension in $GetChildItemColorExtensions.$Type) {
                $GetChildItemColorTable.File.Add($Extension, $Color)
            }
        }
    }
    
    $GetChildItemColorTable.Service.Add('Running', "DarkGreen")
    $GetChildItemColorTable.Service.Add('Stopped', "DarkRed")

    $GetChildItemColorTable.Match.Add('Path', "Cyan")
    $GetChildItemColorTable.Match.Add('LineNumber', "Yellow")
    $GetChildItemColorTable.Match.Add('Line', $OriginalForegroundColor)
}


Export-ModuleMember Get-ChildItemColorTable
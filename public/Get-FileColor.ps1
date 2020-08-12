Function Get-FileColor($Item) {
    $Key = 'Default'
    #add a readonly handler here?
    if ([bool]($Item.Attributes -band [IO.FileAttributes]::ReparsePoint)) {
        $Key = 'Symlink'
    } Else {
        If ($Item.GetType().Name -eq 'DirectoryInfo') {
            $Key = 'Directory'
        } Else {
           If ($Item.PSobject.Properties.Name -contains "Extension") {
               If ($GetChildItemColorTable.File.ContainsKey($Item.Extension)) {
                    $Key = $Item.Extension
                }
            }
        }
    }

    $Color = $GetChildItemColorTable.File[$Key]
    Return $Color
}
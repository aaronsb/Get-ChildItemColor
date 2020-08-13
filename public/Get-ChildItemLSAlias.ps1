Function Get-ChildItemLSAlias {
    Param(
        [string]$Path = ""
    )
    $FilteredArgs = [System.Collections.ArrayList]@()
    $i = 0
    $ListMode = $false
    $Reverse = $false
    $SortModes = [System.Collections.ArrayList]@()
    if ($Args)
    {
        do {
            foreach ($Option in ($Args[$i].ToCharArray() -replace "-")) {
                switch -CaseSensitive ($Option)
                {
                    'a' {[void]$FilteredArgs.Add("-Force")}

                    'all' {[void]$FilteredArgs.Add("-Force")}
                    
                    'B' {[void]$FilteredArgs.Add('-Exclude *~')}

                    'd' {[void]$FilteredArgs.Add("-Directory")}

                    'directory' {[void]$FilteredArgs.Add("-Directory")}
                    
                    'force' {[void]$FilteredArgs.Add("-Force")}

                    'l' {$ListMode = $true}

                    'R' {[void]$FilteredArgs.Add("-Recurse")}

                    'recursive' {[void]$FilteredArgs.Add("-Recurse")}

                    'r' {$Reverse = $true}
                    
                    'S' {[void]$SortModes.Add("Length")}

                    't' {[void]$SortModes.Add("LastWriteTime")}
                    
                    'u' {[void]$SortModes.Add("LastAccessTime")}

                    'v' {[void]$SortModes.Add("FileVersion")}

                    'X' {[void]$SortModes.Add("Extension")}

                    Default {Write-Verbose ("Untranslated Argument " + $option)}
                }
            }
            $i++
        } until ($i -ge $Args.Count)
    }
    


    #I get it that -l is list mode and has modifiers
    #Trying to list wide sorted by modified/accessed/whatever is really corner case
    #and not supported by the Get-ChildItemColorFormatWide format anyway.
    if ($ListMode -eq $true) {
        if ($Reverse -eq $false) {
            Get-ChildItemColor -Path $Path ($FilteredArgs -Join " ") | Sort-Object $SortModes
        }
        else {
            Get-ChildItemColor -Path $Path ($FilteredArgs -Join " ") | Sort-Object $SortModes | Sort-Object -Property Name -Descending
        }
    }
    else {
        if ($Reverse -eq $false) {
            Get-ChildItemColorFormatWide -Path $Path ($FilteredArgs -Join " ") | Sort-Object $SortModes
        }
        else {
            Get-ChildItemColorFormatWide -Path $Path ($FilteredArgs -Join " ") | Sort-Object $SortModes | Sort-Object -Property Name -Descending
        }
    }
}
        

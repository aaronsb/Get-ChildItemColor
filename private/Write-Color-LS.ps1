function Write-Color-LS
{
    param ([string]$Color = "White", $Item)

    Write-host ("{0,-7} {1,25} {2,10} {3}" -f $Item.mode, ([String]::Format("{0,10}  {1,8}", $Item.LastWriteTime.ToString("d"), $Item.LastWriteTime.ToString("t"))), (Write-FileLength $Item.length), $Item.name) -ForegroundColor $Color
}
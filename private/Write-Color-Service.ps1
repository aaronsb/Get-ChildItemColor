function Write-Color-Service
{
    param ([string]$Color = "White", $service)

    Write-host ("{0,-8}" -f $_.Status) -ForegroundColor $Color -noNewLine
    Write-host (" {0,-18} {1,-39}" -f (CutString $_.Name 18), (CutString $_.DisplayName 38)) -ForegroundColor "white"
}
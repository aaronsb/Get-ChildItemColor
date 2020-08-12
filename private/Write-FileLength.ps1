# Helper method to write file length in a more human readable format
function Write-FileLength
{
    Param ($Length)

    If ($Length -eq $null) {
        Return ""
    } ElseIf ($Length -ge 1GB) {
        Return ($Length / 1GB).ToString("F") + 'GB'
    } ElseIf ($Length -ge 1MB) {
        Return ($Length / 1MB).ToString("F") + 'MB'
    } ElseIf ($Length -ge 1KB) {
        Return ($Length / 1KB).ToString("F") + 'KB'
    }

    Return $Length.ToString() + '  '
}
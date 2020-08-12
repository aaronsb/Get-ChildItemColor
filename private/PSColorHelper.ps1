function LengthInBufferCells
{
    param ([string]$Str)

    $len = 0
    ForEach ($c in $Str.ToCharArray())
    {
        $len += LengthInBufferCell($c)
    }
    Return $len
}




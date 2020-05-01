cls
$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath
$gpos = Get-GPO -all | select DisplayName, Description, GPOStatus | sort-object DisplayName
$array = @()

foreach ($gpo in $gpos){ 
    
    $OUTGPO = [PSCustomObject] @{
        'Name' = $gpo.DisplayName
        'Enabled' = $gpo.GPOStatus
        'Description' = $gpo.Description
    }
    Write-host "Processing " -NoNewline
    Write-host $OUTGPO.Name -ForegroundColor Yellow
    $array += $OUTGPO
}

$array | Sort name | Out-Gridview -Title "Group Policies" -OutputMode Multiple

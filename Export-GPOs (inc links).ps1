Clear-Host
$domain = Get-ADDomain | Select-Object -ExpandProperty DistinguishedName
$Searcher = New-Object -TypeName System.DirectoryServices.DirectorySearcher
$Searcher.SearchRoot = "LDAP://$domain"
$Searcher.SearchScope = "subtree"
$Searcher.Filter = "(objectClass=organizationalUnit)"
$Searcher.PropertiesToLoad.Add('Distinguishedname') | Out-Null
$LDAP_OUs = $Searcher.FindAll()
$OUs = $LDAP_OUs.properties.distinguishedname
$array = @()
$gpos = $OUs | ForEach-Object { (Get-GPInheritance -Target $_).GPOlinks } | Select-Object DisplayName, Enabled, Target
​
foreach ($gpo in $gpos) {
    $Comment = Get-GPO -Name $gpo.displayname | Select-Object -ExpandProperty Description
    $OUTGPO = [PSCustomObject] @{
        'Name' = $gpo.DisplayName
        'Enabled' = $GPO.Enabled
        'Description' = $comment
        'Target' = $gpo.Target
    }
    $array += $OUTGPO
}
​
$array | Sort-Object Name | Out-GridView -Title "Group Policy Report" -OutputMode Multiple

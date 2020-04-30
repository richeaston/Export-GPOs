CLS
$domain = Get-ADDomain | select -ExpandProperty DistinguishedName
$Searcher = New-Object -TypeName System.DirectoryServices.DirectorySearcher
$Searcher.SearchRoot = "LDAP://$domain"
$Searcher.SearchScope = "subtree"
$Searcher.Filter = "(objectClass=organizationalUnit)"
$Searcher.PropertiesToLoad.Add('Distinguishedname') | Out-Null
$LDAP_OUs = $Searcher.FindAll()
$OUs = $LDAP_OUs.properties.distinguishedname
$array = @()
$gpos = $OUs | foreach { (Get-GPInheritance -Target $_).GPOlinks } | Select DisplayName, Enabled, Target
​
foreach ($gpo in $gpos) {
    $Comment = Get-GPO -Name $gpo.displayname | select -ExpandProperty Description
    $OUTGPO = [PSCustomObject] @{
        'Name' = $gpo.DisplayName
        'Enabled' = $GPO.Enabled
        'Description' = $comment
        'Target' = $gpo.Target
    }
    $array += $OUTGPO
}
​
$array | sort Name | Out-GridView -Title "Group Policy Report" -OutputMode Multiple

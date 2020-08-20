# purpose for this script to read group membership of all the user belongs to old domain and and update the same group membership in new domain as well.
$olddomainname = "newazuretest.tk"
$Newdomainname = "azuredomain.ml"

#get all users from old domain.
$users = Get-AzureADUser | where-object { $_.userprincipalname -match "$olddomainname"}

foreach( $user in $users)

{

$userid = $user.UserPrincipalName
$userdisplayname = $user.DisplayName

$sourcegroups = Get-AzureADUserMembership -ObjectId "$userid" -All $true
$sourceobj =$sourcegroups | Select-Object objectid

$targetgroups = Get-AzureADUserMembership -ObjectId "$userdisplayname@$Newdomainname" -All $true

$targetobj =$targetgroups| Select-Object objectid

$sourcegroupcount = $sourceobj.count

$missingsGroups = Compare-Object -ReferenceObject $targetobj -IncludeEqual $sourceobj | where-object { $_.Sideindicator -eq "=>"}


for ($i=0; $i -lt $missingsGroups.count; $i++)
{
$groupobjectid= $missingsGroups[$i].InputObject.ObjectId
Add-AzureADGroupMember -ObjectId "$groupobjectid" -RefObjectId "$userdisplayname@$Newdomainname"

}

}

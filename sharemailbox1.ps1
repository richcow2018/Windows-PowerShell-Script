$DL = Get-DistributionGroupMember cscemail@asiainspection.com | Select-Object -ExpandProperty Name 
ForEach ($Member in $DL ) 
{
Add-MailboxPermission -Identity cscemail@asiainspection.com  -User $DL -AccessRights ReadPermission -InheritanceType All
}
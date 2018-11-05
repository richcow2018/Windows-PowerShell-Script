$users = 'gaven.xu@abc.com', 'lewis.zhang@abc.com', 'bonnie.wang@abc.com', 'terry.lin@abc.com'

ForEach ($user in $users) {

    Add-MailboxPermission `
        -Identity costco-bom-contact@abc.com `
        -User $user `
        -AccessRights ReadPermission `
        -InheritanceType All 
}
}
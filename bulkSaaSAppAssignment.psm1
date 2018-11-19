#--------------------------------------------------------------------
# Dot source support scripts
#--------------------------------------------------------------------
$script:ScriptPath = $MyInvocation.MyCommand.Path
$script:ScriptDir  = Split-Path -Parent $ScriptPath
write-host "Importing Module bulkSaaSAppAssignment"
. $ScriptDir\bulkSaaSAppAssignment.ps1
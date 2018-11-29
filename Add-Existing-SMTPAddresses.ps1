<#
Original Author: Paul Cunningham
Editted by: Jimmy Chu
Date: @5Nov2018
.EXAMPLE
.\Add-SMTPAddresses.ps1 -Domain office365bootcamp.com
This will perform a test pass for adding the new alias@office365bootcamp.com as a secondary email address
to all mailboxes. Use the log file to evaluate the outcome before you re-run with the -Commit switch.

.EXAMPLE
.\Add-SMTPAddresses.ps1 -Domain office365bootcamp.com -MakePrimary
This will perform a test pass for adding the new alias@office365bootcamp.com as a primary email address
to all mailboxes. Use the log file to evaluate the outcome before you re-run with the -Commit switch.

.EXAMPLE
.\Add-SMTPAddresses.ps1 -Domain office365bootcamp.com -MakePrimary -Commit
This will add the new alias@office365bootcamp.com as a primary email address
to all mailboxes.

.EXAMPLE
change the current primary into secondard and update the domain after -MakePrimary into primary 
 .\Add-Existing-SMTPAddresses.ps1 -MakePrimary qima.com -Commit

#>

#requires -version 2

	
[CmdletBinding()]
param (
	
	[Parameter( Mandatory=$true )]
	[string]$Domain,

    [Parameter( Mandatory=$false )]
    [switch]$Commit,

    [Parameter( Mandatory=$false )]
    [switch]$MakePrimary

	)



#...................................
# Variables
#...................................

$myDir = Split-Path -Parent $MyInvocation.MyCommand.Path

$logfile = "$myDir\Add-SMTPAddresses.log"


#...................................
# Functions
#...................................

#This function is used to write the log file
Function Write-Logfile()
{
	param( $logentry )
	$timestamp = Get-Date -DisplayHint Time
	"$timestamp $logentry" | Out-File $logfile -Append
}


#...................................
# Script
#...................................

#Check if new domain exists in Office 365 tenant

$chkdom = Get-AcceptedDomain $domain

if (!($chkdom))
{
    Write-Warning "You must add the new domain name to your Office 365 tenant first."
    EXIT
}

#Get the list of mailboxes in the Office 365 tenant
$Mailboxes = @(Get-Mailbox test.test1)  ## specify single user
## $Mailboxes = @(Get-Mailbox -ResultSize Unlimited)  ## all users
 
Foreach ($Mailbox in $Mailboxes)
{

    Write-Host "******* Processing: $mailbox"
    Write-Logfile "******* Processing: $mailbox"

    $NewAddress = $null
	$tempNewAddress = $Mailbox.Alias + "@$Domain"

    #If -MakePrimary is used the new address is made the primary SMTP address.
    #Otherwise it is only added as a secondary email address.
    if ($MakePrimary)
    {
        $NewAddress = "SMTP:" + $Mailbox.Alias + "@$Domain"
    }
    else
    {
	
        $NewAddress = "smtp:" + $Mailbox.Alias + "@$Domain"
		#$LowAlias = $Mailbox.PrimarySmtpAddress.ToLower()
		#$RealAlias = $LowAlias.Replace("@qima.com", "@$Domain")
		#$NewAddress = "smtp:" + $RealAlias
		#$NewAddress = $Mailbox.Alias + "@$Domain"
    }

    #Write the current email addresses for the mailbox to the log file
    Write-Logfile ""
    Write-Logfile "Current new addresses: $NewAddress"
    
    #$addresses = @($emailbox | Select -Expand EmailAddresses)
	
	$addresses = @($mailbox | Select-Object -Expand EmailAddresses | ? {$_ -ne $NewAddress })
	$addresses1 = @($mailbox | Select-Object -Expand PrimarySmtpAddress | ? {$_ -ne $NewAddress })
    
    Write-Logfile ""
    Write-Logfile "Current addresses: $addresses"
	Write-Logfile ""
    Write-Logfile "Current temp addresses: $TempAddresses"
	
    foreach ($address in $addresses)
    {
		Write-LogFile ""
        Write-Logfile "address loop is $address"
    }
	
	  foreach ($TempAddresses in $addresses1)
    {
		Write-LogFile ""
        Write-Logfile "temp address loop is $TempAddresses"
    }

    #If -MakePrimary is used the existing primary is changed to a secondary
     if ($MakePrimary)
    {
        Write-LogFile ""
        Write-Logfile "Converting current primary address to secondary"
        $addresses = $addresses.Replace("SMTP","smtp")
		Write-LogFile ""
		Write-LogFile "address is $addresses"
    } 

    #Add the new email address to the list of addresses
    Write-Logfile ""
    Write-Logfile "New email address to add is $NewAddress"

    #$addresses += $NewAddress
	Write-Logfile ""
    Write-Logfile "New and old email address  is $addresses"
	Write-Logfile ""
    Write-Logfile "New and temp email address  is $TempAddresses and  $tempNewAddress"
	
    #You must use the -Commit switch for the script to make any changes
    if ($Commit)
    {
        Write-LogFile ""
        Write-LogFile "Committing new addresses:"
        foreach ($address in $addresses)
        {
			Write-Logfile ""
            Write-Logfile "commiting old address $address"
			Write-Logfile "commiting new address $NewAddress"
			Write-Logfile "milabox alias $Mailbox.Alias"
			
			
			
        }
		
		Set-MsolUserPrincipalName -UserPrincipalName $TempAddresses -NewUserPrincipalName $tempNewAddress
        Set-Mailbox -Identity  $Mailbox.Alias -EmailAddresses $addresses    
		Set-Mailbox -Identity  $Mailbox.Alias -EmailAddresses $NewAddress  
		
		#Set-MsolUserPrincipalName -UserPrincipalName $TempAddresses -NewUserPrincipalName $tempNewAddress
		#Set-DistributionGroup -Identity $Mailbox.Alias -EmailAddresses $addresses  		
    }
    else
    {
        Write-LogFile ""
        Write-LogFile "New addresses:"
        foreach ($address in $addresses)
        {
            Write-Logfile $address
        }
        Write-LogFile "Changes not committed, re-run the script with the -Commit switch when you're ready to apply the changes."
        Write-Warning "No changes made due to -Commit switch not being specified."
    }

	Write-LogFile ""
	
    Write-Logfile "Completed"
}

#...................................
# Finished
#...................................

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
$Mailboxes = @(Get-Mailbox -ResultSize Unlimited -Filter {RecipientTypeDetails -eq "sharedmailbox"})  #sharedmailbox
#$Mailboxes = @(Get-DistributionGroup -ResultSize Unlimited)  #groupmail
 
Foreach ($Mailbox in $Mailboxes)
{

    Write-Host "******* Processing: $mailbox"
    Write-Logfile "******* Processing: $mailbox"

    $NewAddress = $null

    #If -MakePrimary is used the new address is made the primary SMTP address.
    #Otherwise it is only added as a secondary email address.
    if ($MakePrimary)
    {
        $NewAddress = "SMTP:" + $Mailbox.Alias + "@$Domain"
    }
    else
    {
	
        #$NewAddress = "smtp:" + $Mailbox.Alias + "@$Domain"
		$LowAlias = $Mailbox.PrimarySmtpAddress.ToLower()
		$RealAlias = $LowAlias.Replace("@abc.com", "@$Domain")
		$NewAddress = "smtp:" + $RealAlias
		#$NewAddress = $Mailbox.Alias + "@$Domain"
    }

    #Write the current email addresses for the mailbox to the log file
    Write-Logfile ""
    Write-Logfile "Current addresses:"
    
    $addresses = @($mailbox | Select -Expand EmailAddresses)

    foreach ($address in $addresses)
    {
        Write-Logfile $address
    }

    #If -MakePrimary is used the existing primary is changed to a secondary
     if ($MakePrimary)
    {
        Write-LogFile ""
        Write-Logfile "Converting current primary address to secondary"
        $addresses = $addresses.Replace("SMTP","smtp")
    } 

    #Add the new email address to the list of addresses
    Write-Logfile ""
    Write-Logfile "New email address to add is $newaddress"

    $addresses += $NewAddress

    #You must use the -Commit switch for the script to make any changes
    if ($Commit)
    {
        Write-LogFile ""
        Write-LogFile "Committing new addresses:"
        foreach ($address in $addresses)
        {
            Write-Logfile $address
        }
        Set-Mailbox -Identity $Mailbox.Alias -EmailAddresses $addresses    
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

    Write-Logfile ""
}

#...................................
# Finished
#...................................

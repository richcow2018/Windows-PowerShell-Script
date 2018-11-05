$UserCredential = Get-Credential
Connect-msolservice -Credential $msolcred
Get-PSSession | Remove-PSSession 
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
#Import the session 
Import-PSSession $Session -AllowClobber | Out-Null 
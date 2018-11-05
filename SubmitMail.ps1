###############################################################################

###########Define Variables########

$fromaddress = "user.name@abc.com"
$toaddress = "user.name@abc.com"
$emailSmtpServerPort = "587"
$Subject = "ACtion Required"
$body = "Hi... please find attached the AI Customer - Registrations Daily Report from Oracle. Kindly Check."
$attachment = "D:\Users\user.name\Downloads\fasdfasdfas.zip"
$passwd = "fvgqqkhhnxthjdjb"
#$cred = new-object -typename System.Management.Automation.PSCredential -ArgumentList "user.name@abc.com", $passwd
$SMTPAuthUsername = "user.name@abc"
$SMTPAuthPassword = "sdfasdfsafasdf"
$smtpserver = "smtp.office365.com"



####################################

$message = new-object System.Net.Mail.MailMessage
$message.From = $fromaddress
$message.To.Add($toaddress)
#$message.CC.Add($CCaddress)
#$message.Bcc.Add($bccaddress)
$message.IsBodyHtml = $True
$message.Subject = $Subject
$attach = new-object Net.Mail.Attachment($attachment)
$message.Attachments.Add($attach)
$message.body = $body
$smtp = new-object Net.Mail.SmtpClient($smtpserver, $emailSmtpServerPort)
#$smtp.Credentials = New-Object System.Net.NetworkCredential($cred) 
$smtp.Credentials = New-Object System.Net.NetworkCredential("$SMTPAuthUsername", "$SMTPAuthPassword") 
$smtp.EnableSsl = $False
$smtp.Send($message)


#################################################################################





<#
EmailFrom = "<user@domain.tld>"
$EmailTo = "<user@domain.tld>"
$EmailSubject = "<email subject"  
  
$SMTPServer = "smtphost.domain.tld"
$SMTPAuthUsername = "username"
$SMTPAuthPassword = "password"

$emailattachment = "<full path to attachment file>"

function send_email {
$mailmessage = New-Object system.net.mail.mailmessage 
$mailmessage.from = ($emailfrom) 
$mailmessage.To.add($emailto)
$mailmessage.Subject = $emailsubject
$mailmessage.Body = $emailbody

$attachment = New-Object System.Net.Mail.Attachment($emailattachment, 'text/plain')
  $mailmessage.Attachments.Add($attachment)


#$mailmessage.IsBodyHTML = $true
$SMTPClient = New-Object Net.Mail.SmtpClient($SmtpServer, 25)  
$SMTPClient.Credentials = New-Object System.Net.NetworkCredential("$SMTPAuthUsername", "$SMTPAuthPassword") 
$SMTPClient.Send($mailmessage)
}




$passwd = cat sec.txt | convertto-securestring
#$passwd = "fsdfasdfs"
$cred = new-object -typename System.Management.Automation.PSCredential -ArgumentList "itsender@abc.com", $passwd
#$cred = new-object -typename System.Management.Automation.PSCredential -ArgumentList "user.name@abc.com", $passwd
$smtpserver = "smtp.office365.com"

# Email Variable Details
#$SendFrom = "user.name@abc.com"
$SendFrom = "itsender@abc.com"
$SendTo = "user.name@abc.com"
# $SendBcc = "jitesh.pillai@abc.com"
$EmailSubject = "AI Customer - Registrations (Daily)"
$Body = "Hi... please find attached the AI Customer - Registrations Daily Report from Oracle. Kindly Check."
$attachment = "C:\AI_Customer_Registration\sadfasdfs.zip"
$RetryPause = 300
send-MailMessage -To $SendTo -Subject $EmailSubject -Body $Body -SmtpServer $smtpserver -From $SendFrom -Bcc $SendBcc -UseSsl -credential $cred -BodyAsHtml -Attachments $attachment -EA Stop
#>






## This program is to generate a traceroute result report and send it to me
## 5 July 2018 created by Jimmy Chu
## filename: traceroute.bat


$EmailTo = "user.name@abc.com" 
      $EmailFrom = "abc@gmail.com"  
      $Subject = "traceroute result"  
      $Body = "Enclosed traceroute result"  
      $SMTPServer = "smtp.gmail.com" 
      $filenameAndPath = "traceroute-result.txt"  
      $SMTPMessage = New-Object System.Net.Mail.MailMessage($EmailFrom,$EmailTo,$Subject,$Body)
      $attachment = New-Object System.Net.Mail.Attachment($filenameAndPath)
      $SMTPMessage.Attachments.Add($attachment)
      $SMTPClient = New-Object Net.Mail.SmtpClient($SmtpServer, 587) 
      $SMTPClient.EnableSsl = $true 
      $SMTPClient.Credentials = New-Object System.Net.NetworkCredential("abc@gmail.com", "password");   
      $SMTPClient.Send($SMTPMessage)
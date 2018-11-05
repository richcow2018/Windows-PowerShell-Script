

powershell.exe -ExecutionPolicy Bypass -Command
Test-NetConnection hk4.asiainspection.com -TraceRoute  | Out-File "mybackup $(get-date -f yyyy-MM-dd-hh-mm).txt" -NoClobber -Append

Test-NetConnection hk4.asiainspection.com -TraceRoute | Select -ExpandProperty TraceRoute | % { Resolve-DnsName $_ -type PTR -ErrorAction SilentlyContinue }  | Out-File "mybackup $(get-date -f yyyy-MM-dd-hh-mm).txt" -NoClobber -Append

Test-NetConnection hk6.asiainspection.com -TraceRoute  | Out-File "mybackup $(get-date -f yyyy-MM-dd-hh-mm).txt" -NoClobber -Append

Test-NetConnection hk6.asiainspection.com -TraceRoute | Select -ExpandProperty TraceRoute | % { Resolve-DnsName $_ -type PTR -ErrorAction SilentlyContinue } | Out-File "mybackup $(get-date -f yyyy-MM-dd-hh-mm).txt" -NoClobber -Append


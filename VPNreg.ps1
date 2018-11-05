$registryPath = "HKLM:\SYSTEM\CurrentControlSet\Services\PolicyAgent"

$regName = "Version"

$regValue = "1"

$VpnName = "vpnnametemp"

$serverIP = "192.168.0.0"

$L2tpPass = "password"

powershell.exe -ExecutionPolicy Bypass -Command "New-ItemProperty -Path $registryPath -Name $regName -Value $regValue -PropertyType DWORD -Force | Out-Null"

powershell.exe -ExecutionPolicy Bypass -Command "Add-VpnConnection -Name $VpnName -ServerAddress $serverIP -L2tpPsk $L2tpPass -Force -RememberCredential -PassThru"
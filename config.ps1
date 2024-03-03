function Get-NetworkAdapterInfo {
    $adapter = Get-NetAdapter -Name $adapter
    $adapterInfo = @{
        'Model' = $adapter.InterfaceDescription
        'Physical link' = $adapter.MediaConnectionState
        'Speed' = $adapter.LinkSpeed
        'Full Duplex' = $adapter.FullDuplex
    }
    $adapterInfo
}

function Set-NetworkAdapterDHCP {
	netsh interface ip set address $adapter dhcp
	netsh interface ip set dns $adapter dhcp

	netsh interface ip show config $adapter
	Write-Host "Network adapter configured using DHCP"
}

function Set-NetworkAdapterStatic {
	netsh interface ip set address $adapter static address=$ip mask=$mask gateway=$gateway 
	netsh interface ip set dnsservers $adapter static $dns primary no

	Timeout /T 5

	netsh interface ip show config $adapter
	Write-Host "Network adapter configured statically"
}

$adapter = "Ethernet"
$action = Read-Host "Choose an action: 
1. Get network adapter information
2. Configure network adapter using DHCP
3. Configure network adapter statically
choice"

if ($action -eq '1') { Get-NetworkAdapterInfo }
elseif ($action -eq '2') { Set-NetworkAdapterDHCP }
elseif ($action -eq '3') {
        $ip = Read-Host "Enter the IP address"
        $mask = Read-Host "Enter mask"
        $gateway = Read-Host "Enter the gateway"
        $dns = Read-Host "Enter the DNS server address"
        Set-NetworkAdapterStatic -InterfaceAlias $InterfaceAlias -IPAddress $IPAddress -SubnetMask $SubnetMask -Gateway $Gateway -DNS $DNS
    }
else { Write-Host "No such command" }

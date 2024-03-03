@echo off
chcp 65001
setlocal enabledelayedexpansion

set /p choice=Choose the configuration method (1 - automatic, 2 - manual): 

set adapter=Ethernet

if %choice% equ 1 (
	netsh interface ip set address %adapter% dhcp
	netsh interface ip set dns %adapter% dhcp

	netsh interface ip show config %adapter%
	echo Network adapter configured using DHCP

	goto :exit

) else if %choice% equ 2 (
	set /p ip=Enter the IP address: 
	set /p mask=Enter mask: 
	set /p gateway=Enter the gateway: 
	set /p dns=Enter the DNS server address: 

	netsh interface ip set address !adapter! static !ip! !mask! !gateway! 
	netsh interface ip set dnsservers !adapter! static !dns! primary no

	timeout /t 5 /nobreak

	netsh interface ip show config !adapter!
	echo Network adapter configured statically

	goto :exit
) else (
	echo No such command
)

:exit
pause
Import-Module BitsTransfer
#download ENS Threat Prevention. Udpate the ENS-CC.txt file and $modules variable to install additional ENS Modules
New-Item -Path "C:\Windows\Temp\ENS-ATM\" -ItemType "directory"
Import-Csv ENS-CC.txt | Start-BitsTransfer 

#Install ENS
$setupENS = 'C:\Windows\Temp\ENS-ATM\setupEP.exe'
$modules = 'ADDLOCAL="tp"'
$ensInstall = [System.Diagnostics.Process]::Start($setupENS, $modules)
$ensInstall.WaitForExit()
#cleanup 
Remove-Item -path 'C:\Windows\Temp\ENS-ATM\' -recurse
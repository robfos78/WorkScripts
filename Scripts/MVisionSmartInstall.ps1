################################################
#Download Smart Installer from the MVision
################################################
#$url ="https://ui-mcafee.mvision.mcafee.com/ComputerMgmt/agentPackageDownload/McAfeeSmartInstall.download?token=<token from URL>"
#$destination = "c:\windows\temp\McAfeeSmartInstall.exe"
#Invoke-WebRequest -Uri $url -OutFile $destination 
#Start-Process -Filepath $destination -ArgumentList "-s"

#################################################
#Install Smart Installer with Proxy
#################################################
$SmartInstaller = 'SmartInstaller.exe'
$ProxySettings = '-a "proxy.domain.com" -p "port" -s'

$SInstaller = [System.Diagnostics.Process]::Start($SmartInstaller, $ProxySettings)
$SInstaller.WaitForExit()

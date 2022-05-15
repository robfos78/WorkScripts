Import-Module -Name PSWorkflow
Import-Module -Name ScheduledTasks

function epr { 
	$url ="https://"
	$destination = "C:\Windows\Temp\temp\epr.exe"
	Invoke-WebRequest -Uri $url -OutFile $destination 
	$eprArg = "--accepteula --ALL"
	$adminCLI = [System.Diagnostics.Process]::Start($destination, $eprArg)
    $adminCLI.WaitForExit()
}
function createTaskAgent {
	'$url ="https://"' | Out-File -FilePath C:\Windows\Temp\Install_Agent.ps1
	'$destination = "C:\Windows\Temp\temp\McAfeeSmartInstall.exe"' | Out-File -FilePath C:\Windows\Temp\Install_Agent.ps1 -Append
	'Invoke-WebRequest -Uri $url -OutFile $destination' | Out-File -FilePath C:\Windows\Temp\Install_Agent.ps1 -Append
	'$agentArg = "-s"' | Out-File -FilePath C:\Windows\Temp\Install_Agent.ps1 -Append
	'$adminCLI = [System.Diagnostics.Process]::Start($destination, $agentArg)' | Out-File -FilePath C:\Windows\Temp\Install_Agent.ps1 -Append
    '$adminCLI.WaitForExit()' | Out-File -FilePath C:\Windows\Temp\Install_Agent.ps1 -Append
	'$psRun = "C:\Windows\Temp\System32\WindowsPowerShell\v1.0\powershell.exe"' | Out-File -FilePath C:\Windows\Temp\Install_Agent.ps1 -Append
	'$ensTask = "-ExecutionPolicy Bypass -File  C:\Windows\Temp\temp\Install_ENS.ps1"' | Out-File -FilePath C:\Windows\Temp\Install_Agent.ps1 -Append
	'$adminCLI = [System.Diagnostics.Process]::Start($ensTask, $ensTask)' | Out-File -FilePath C:\Windows\Temp\Install_Agent.ps1 -Append
    '$adminCLI.WaitForExit()' | Out-File -FilePath C:\Windows\Temp\Install_Agent.ps1 -Append
}
function createTaskENS {
	'$url ="https://"' | Out-File -FilePath C:\Windows\Temp\Install_ENS.ps1.ps1
	'$destination = "C:\Windows\Temp\temp\ENS.zip"' | Out-File -FilePath C:\Windows\Temp\Install_ENS.ps1 -Append
	'Invoke-WebRequest -Uri $url -OutFile $destination' | Out-File -FilePath C:\Windows\Temp\Install_ENS.ps1 -Append
	'New-Item -Path "C:\Windows\Temp\Temp" -Name "ENS-Install" -ItemType "directory"' | Out-File -FilePath C:\Windows\Temp\Install_ENS.ps1 -Append
	'Expand-Archive -LiteralPath $destination -DestinationPath C:\Windows\Temp\Temp\ENS-Install' | Out-File -FilePath C:\Windows\Temp\Install_ENS.ps1 -Append
	'ensRun = "C:\Windows\Temp\Temp\ENS-Install\setupEP.exe"' | Out-File -FilePath C:\Windows\Temp\Install_ENS.ps1 -Append
	'$ensArg = "ADDLOCAL="' | Out-File -FilePath C:\Windows\Temp\Install_ENS.ps1 -Append
	'$ensArg += """"' | Out-File -FilePath C:\Windows\Temp\Install_ENS.ps1 -Append
	'$ensArg += "tp,atp,fw"' | Out-File -FilePath C:\Windows\Temp\Install_ENS.ps1 -Append
	'$ensArg += """"' | Out-File -FilePath C:\Windows\Temp\Install_ENS.ps1 -Append
	'$adminCLI = [System.Diagnostics.Process]::Start($ensRun, $ensArg)' | Out-File -FilePath C:\Windows\Temp\Install_ENS.ps1 -Append
    '$adminCLI.WaitForExit()' | Out-File -FilePath C:\Windows\Temp\Install_ENS.ps1 -Append
	'$psRun = "C:\Windows\Temp\System32\WindowsPowerShell\v1.0\powershell.exe"' | Out-File -FilePath C:\Windows\Temp\Install_ENS.ps1 -Append
	'$edrTask = "-ExecutionPolicy Bypass -File  C:\Windows\Temp\temp\Install_EDR.ps1"' | Out-File -FilePath C:\Windows\Temp\Install_ENS.ps1 -Append
	'$adminCLI = [System.Diagnostics.Process]::Start($ensTask, $edrTask)' | Out-File -FilePath C:\Windows\Temp\Install_ENS.ps1 -Append
    '$adminCLI.WaitForExit()' | Out-File -FilePath C:\Windows\Temp\Install_ENS.ps1 -Append	
}
function createTaskEDR {
	'$url ="https://"' | Out-File -FilePath C:\Windows\Temp\Install_EDR.ps1
	'$destination = "C:\Windows\Temp\temp\edr.exe"' | Out-File -FilePath C:\Windows\Temp\Install_EDR.ps1 -Append
	'Invoke-WebRequest -Uri $url -OutFile $destination' | Out-File -FilePath C:\Windows\Temp\Install_EDR.ps1 -Append
	'New-Item -Path "C:\Windows\Temp\Temp" -Name "EDR-Install" -ItemType "directory"' | Out-File -FilePath C:\Windows\Temp\Install_EDR.ps1 -Append
	'Expand-Archive -LiteralPath $destination -DestinationPath C:\Windows\Temp\EDR-Install' | Out-File -FilePath C:\Windows\Temp\Install_EDR.ps1 -Append
	'$edrRun = "C:\Windows\Temp\temp\EDR\MVEDRSetup_x64.exe"' | Out-File -FilePath C:\Windows\Temp\Install_EDR.ps1 -Append
	'$edrArg = "/install /quiet"' | Out-File -FilePath C:\Windows\Temp\Install_EDR.ps1 -Append
	'$adminCLI = [System.Diagnostics.Process]::Start($edrRun, $edrArg)' | Out-File -FilePath C:\Windows\Temp\Install_EDR.ps1 -Append
    '$adminCLI.WaitForExit()' | Out-File -FilePath C:\Windows\Temp\Install_EDR.ps1 -Append
	'Unregister-ScheduledTask reinstallMcAfee -Confirm:$false' | Out-File -FilePath C:\Windows\Temp\Install_EDR.ps1 -Append
}
function createTask{
$scriptPath = 'C:\Windows\Temp\Install_Agent.ps1'
$principle = New-ScheduledTaskPrincipal -UserId "NT Authority\SYSTEM"
$action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-executionpolicy bypass -noprofile -file $scriptPath"
$trigger = New-ScheduledTaskTrigger -AtStartup 
$settings = New-ScheduledTaskSettingsSet
$task = New-ScheduledTask -Action $action -Trigger $trigger -Settings $settings -Principal $principle
Register-ScheduledTask reinstallMcAfee -InputObject $task
}
workflow reinstallMcAfeeWF {
epr
	
createTaskAgent

createTaskENS

createTaskEDR

createTask

Restart-Computer -force
}

reinstallMcAfeeWF
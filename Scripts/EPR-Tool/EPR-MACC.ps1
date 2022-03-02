Import-Module -Name PSWorkflow
Import-Module -Name ScheduledTasks


function disableMACC {
# Check for current mode of MACC 
$swinParm = 'HKLM:\SYSTEM\CurrentControlSet\Services\swin\Parameters'
$RTEMode = Get-ItemProperty -path $swinParm | Select-Object -ExpandProperty RTEMode 
#Get the status of the SC Service
$scRun = Get-Service -Name scsrvc
$scRunStat = $scRun.Status

 
 
    # Test for App Control not in disabled mode 
    If ($RTEMode -ne 0) { 
	    
        #Test if SC Service is running
		If ($scRunStat -contains "Running") {
 
            # Unlock CLI and put into disable mode
            $recover = "recover -z solidcore" 
            $sadminCLI = [System.Diagnostics.Process]::Start("sadmin.exe", $recover)
            $sadminCLI.WaitForExit()
            $sadminCLI = [System.Diagnostics.Process]::Start("sadmin.exe", "disable")
            $sadminCLI.WaitForExit()
 
		    }
        Else{
            Set-ItemProperty -Path $swinParm -Name "RTEMode" -Value '0'
            Set-ItemProperty -Path $swinParm -Name "RTEModeOnReboot" -Value '0'
            }
     }
}
function writeJob {
"& sc.exe stop 'scsrvc' >  C:\Windows\Temp\epr-tool-task.txt" | Out-File -FilePath C:\Windows\MACC_DeleteKey.ps1
"& sc.exe delete 'scsrvc' >  C:\Windows\Temp\epr-tool-task.txt" | Out-File -FilePath C:\Windows\MACC_DeleteKey.ps1 -Append
"& sc.exe delete 'swin' >  C:\Windows\Temp\epr-tool-task.txt" | Out-File -FilePath C:\Windows\MACC_DeleteKey.ps1 -Append
'& "C:\Program Files\McAfee\Agent\x86\mctray.exe" "unloadplugin=scormcpl.dll" >  C:\Windows\Temp\epr-tool-task.txt' | Out-File -FilePath C:\Windows\MACC_DeleteKey.ps1 -Append
'& del "C:\WINDOWS\system32\drivers\swin.sys" >  C:\Windows\Temp\epr-tool-task.txt' | Out-File -FilePath C:\Windows\MACC_DeleteKey.ps1 -Append

'$vol = GET-WMIOBJECT win32_logicaldisk' | Out-File -FilePath C:\Windows\MACC_DeleteKey.ps1 -Append
'foreach ($path in $vol) {Join-Path -Path $vol.DeviceID -ChildPath "Solidcore" | Remove-Item -force -recurse} >  C:\Windows\Temp\epr-tool-task.txt' | Out-File -FilePath C:\Windows\MACC_DeleteKey.ps1 -Append

"Remove-Item 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\McAfee\Solidifier' -Force -Recurse >  C:\Windows\Temp\epr-tool-task.txt" | Out-File -FilePath C:\Windows\MACC_DeleteKey.ps1 -Append
"Remove-Item  'HKLM\SYSTEM\CurrentControlSet\services\swin' -Force -Recurse >  C:\Windows\Temp\epr-tool-task.txt" | Out-File -FilePath C:\Windows\MACC_DeleteKey.ps1 -Append
"Remove-Item 'HKLM:\SOFTWARE\Wow6432Node\McAfee\Agent\Applications\SOLIDCOR5000_WIN' -Force -Recurse >  C:\Windows\Temp\epr-tool-task.txt" | Out-File -FilePath C:\Windows\MACC_DeleteKey.ps1 -Append
"Remove-Item 'HKLM:\SOFTWARE\Network Associates\ePolicy Orchestrator\Application Plugins\SOLIDCOR5000_WIN'-Force -Recurse >  C:\Windows\Temp\epr-tool-task.txt" | Out-File -FilePath C:\Windows\MACC_DeleteKey.ps1 -Append
"Remove-Item 'HKLM:\SOFTWARE\Wow6432Node\Network Associates\ePolicy Orchestrator\Application Plugins\SOLIDCOR5000_WIN' -Force -Recurse >  C:\Windows\Temp\epr-tool-task.txt" | Out-File -FilePath C:\Windows\MACC_DeleteKey.ps1 -Append
"Remove-Item 'HKLM:\SOFTWARE\Classes\Installer\Features\4E9BD2348836F234A9BD168E87F25439' -Force -Recurse >  C:\Windows\Temp\epr-tool-task.txt" | Out-File -FilePath C:\Windows\MACC_DeleteKey.ps1 -Append
"Remove-Item 'HKLM:\SOFTWARE\Classes\Installer\Products\4E9BD2348836F234A9BD168E87F25439' -Force -Recurse >  C:\Windows\Temp\epr-tool-task.txt" | Out-File -FilePath C:\Windows\MACC_DeleteKey.ps1 -Append
'Remove-Item "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{432DB9E4-6388-432F-9ADB-61E8782F4593}" /f >  C:\Windows\Temp\epr-tool-task.txt' | Out-File -FilePath C:\Windows\MACC_DeleteKey.ps1 -Append
"Start-Sleep -s 15" | Out-File -FilePath C:\Windows\MACC_DeleteKey.ps1 -Append
'Remove-Item  "C:\ProgramData\McAfee\Solidcore" -force -recurse' | Out-File -FilePath C:\Windows\MACC_DeleteKey.ps1 -Append
'Remove-Item "C:\Program Files\McAfee\Solidcore" -force -recurse' | Out-File -FilePath C:\Windows\MACC_DeleteKey.ps1 -Append
'Unregister-ScheduledTask deleteMacc -Confirm:$false' | Out-File -FilePath C:\Windows\MACC_DeleteKey.ps1 -Append
}

function createJob{
 
$scriptPath = 'C:\Windows\MACC_DeleteKey.ps1'
$principle = New-ScheduledTaskPrincipal -UserId "NT Authority\SYSTEM"
$action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-executionpolicy bypass -noprofile -file $scriptPath"
$trigger = New-ScheduledTaskTrigger -AtStartup 
$settings = New-ScheduledTaskSettingsSet
$task = New-ScheduledTask -Action $action -Trigger $trigger -Settings $settings -Principal $principle
Register-ScheduledTask deleteMacc -InputObject $task
}

workflow removeMACC {
disableMACC	
	
writeJob

createJob

Restart-Computer -force
}

removeMACC
& sc.exe stop 'scsrvc'
& sc.exe delete 'scsrvc'
& sc.exe delete 'swin'
& "C:\Program files\Mcafee\Agent\x86\Mctray.exe" -ArgumentList unloadplugin=scormcpl.dll
& del 'C:\WINDOWS\system32\drivers\swin.sys'


$drive = GET-WMIOBJECT win32_logicaldisk 
foreach ($path in $drive) {Join-Path -Path $drive.DeviceID -ChildPath "Solidcore" | Remove-Item -force -recurse}

Remove-Item 'C:\Program Files\McAfee\Solidcore' -force -recurse
Remove-Item 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\McAfee\Solidifier' -Force -Recurse
Remove-Item  'C:\ProgramData\McAfee\Solidcore' -Force -Recurse
Remove-Item  'HKLM\SYSTEM\CurrentControlSet\services\swin' -Force -Recurse
Remove-Item 'HKLM:\SOFTWARE\Wow6432Node\McAfee\Agent\Applications\SOLIDCOR5000_WIN' -Force -Recurse
Remove-Item 'HKLM:\SOFTWARE\Network Associates\ePolicy Orchestrator\Application Plugins\SOLIDCOR5000_WIN'-Force -Recurse
Remove-Item 'HKLM:\SOFTWARE\Wow6432Node\Network Associates\ePolicy Orchestrator\Application Plugins\SOLIDCOR5000_WIN' -Force -Recurse
Remove-Item 'HKLM:\SOFTWARE\Classes\Installer\Features\4E9BD2348836F234A9BD168E87F25439' -Force -Recurse
Remove-Item 'HKLM:\SOFTWARE\Classes\Installer\Products\4E9BD2348836F234A9BD168E87F25439' -Force -Recurse

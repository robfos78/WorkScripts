$TestRegPath = Get-ItemProperty -path 'HKLM:\SYSTEM\CurrentControlSet\Services\swin\Parameters' | Select-Object -ExpandProperty RTEMode 
 
# Test that variable is not null 
If ($TestRegPath) { 
 
    # Test for App Control not in disable mode 
    If ($TestRegPath -ne 0) { 
 
        # Unlock CLi 
        $Recover = "recover -z solidcore" 
        $installStatement = [System.Diagnostics.Process]::Start("sadmin.exe", $Recover) 
        $installStatement.WaitForExit() 
 
        # Check if MACC is enabled or observe 
        If (($TestRegPath -eq 1) -or ($TestRegPath -eq 3)) { 
            If ($TestRegPath -eq 1) { 
                # MAC is enabled 
                $BeginUpdate = "bu" 
                $installStatement = [System.Diagnostics.Process]::Start("sadmin.exe", $BeginUpdate) 
                $installStatement.WaitForExit() 
            } Else { 
                # MACC is in observe 
                $BeginUpdate = "bu" 
                $installStatement = [System.Diagnostics.Process]::Start("sadmin.exe", "eo") 
                $installStatement.WaitForExit() 
                $installStatement = [System.Diagnostics.Process]::Start("sadmin.exe", $BeginUpdate) 
                $installStatement.WaitForExit() 
            } 
        }
	#Restart Solidcore Service 
	$installStatement = [System.Diagnostics.Process]::Start("net stop scsrvc") 
    $installStatement.WaitForExit() 
	$installStatement = [System.Diagnostics.Process]::Start("net start scsrvc") 
    $installStatement.WaitForExit()

	
	#End Update Mode
	$EndUpdate = "eu"
	$installStatement = [System.Diagnostics.Process]::Start("sadmin.exe", $EndUpdate) 
    $installStatement.WaitForExit() 
	
	#Lockdown CLI
	$lockdown = "lockdown"
	$installStatement = [System.Diagnostics.Process]::Start("sadmin.exe", $lockdown)
	$installStatement.WaitForExit() 
	
    } 
}

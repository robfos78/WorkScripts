
Function Write-Log($message) {
    $logfile = "C:\windows\Temp\McAfeeLogs\McAfee_ENS_Repair_All_Modules.0.log"
    $date = Get-Date -Format G

    if (!(Test-Path $logfile)) {
        New-Item -Path $logfile -ItemType "File"
    }
    Write-Host "[$date] $message" -ForegroundColor DarkYellow
    Write-Output "[$date] $message" | Out-File $logfile -Append
}


$ENS_Plat = (Get-ItemProperty -ea silentlycontinue -path 'HKLM:\SOFTWARE\McAfee\Endpoint\Modules\Endpoint Security Platform').InstallDIR
$ENS_Plat32 = (Get-ItemProperty -ea silentlycontinue -path 'HKLM:\SOFTWARE\McAfee\Endpoint\Common').szInstallDir32
$ENS_TP = (Get-ItemProperty -ea silentlycontinue -path 'HKLM:\SOFTWARE\McAfee\Endpoint\Modules\Threat Prevention').InstallDIR
$ENS_FW = (Get-ItemProperty -ea silentlycontinue -path 'HKLM:\SOFTWARE\McAfee\Endpoint\Modules\Firewall').InstallDIR
$ENS_ATP = (Get-ItemProperty -ea silentlycontinue -path 'HKLM:\SOFTWARE\McAfee\Endpoint\Modules\Adaptive Threat Protection').InstallDIR 
$MA = (Get-ItemProperty -ea silentlycontinue -path 'HKLM:\SOFTWARE\McAfee\Agent').InstallPath

$arg = $("/fam " + "/log" + '"C:\windows\Temp\McAfeeLogs\ENS_Repair\"')

#Repair Binaries
$ENS_PlatRP = "repairCache\setupCC.exe"
$ENS_TPRP = "repairCache\setupTP.exe"
$ENS_FWRP = "repairCache\setupFW.exe"
$ENS_ATPRP = "repairCache\setupATP.exe"

    Write-Log "*************************************************************************************************"
    Write-Log "*                                       Beginning Install                                       *"
    Write-Log "*************************************************************************************************"

#ENS Platform Repair

if (-not $ENS_Plat)
{Write-Log "ENS Plat Not Installed or Not Found"
} 
Else {
    Write-Log "Found $ENS_Plat."
    Write-Log "Running $ENS_Plat\$ENS_PlatRP -ArgumentList $arg -Wait -PassThru -NoNewWindow"
       
    $ENSPlat_p1a = Start-Process $ENS_Plat\$ENS_PlatRP -ArgumentList $arg -Wait -PassThru -NoNewWindow -ea SilentlyContinue
    $ENSPlat_p1a.WaitForExit()
                  
    Write-Log "Command finished with Exit Code: $($ENSPlat_p1a.ExitCode)"

    if( $ENSPlat_p1a.ExitCode -eq 3010) {
	Write-Log "Command executed successfully"
    Write-Log "Repaired Endpoint Security Platform" 
	Write-Log "Reboot Required"
    $ENSPLAT = 3010
} else {
Write-Log "Failed To Repair Endpoint Security Platform"
Write-Log "Command finished with Exit Code: $($ENSPlat_p1a.ExitCode)"
Write-Log "Please see logs in C:\windows\temp\mcafeelogs\ENS_Repair\ or try Ripper Removal"
}
$ENSPlat_p1a = $null
}



#ENS Threat Prevention Repair

if (-not $ENS_TP)
{Write-Log "ENS TP Not Installed or Not Found"
$ENSTP = "Not Found"
} 
Else {
    Write-Log "Found $ENS_TP."
    Write-Log "Running $ENS_TP\$ENS_TPRP -ArgumentList $arg -Wait -PassThru -NoNewWindow"
       
    $ENSTP_p1a = Start-Process $ENS_TP\$ENS_TPRP -ArgumentList $arg -Wait -PassThru -NoNewWindow -ea SilentlyContinue
    $ENSTP_p1a.WaitForExit()
                  
    Write-Log "Command finished with Exit Code: $($ENSTP_p1a.ExitCode)"

    if( $ENSTP_p1a.ExitCode -eq 3010) {
	Write-Log "Command executed successfully"
    Write-Log "Repaired Endpoint Security Threat Prevention" 
	Write-Log "Reboot Required"
} else {
Write-Log "Failed To Repair Endpoint Security Threat Prevention"
Write-Log "Command finished with Exit Code: $($ENSTP_p1a.ExitCode)"
Write-Log "Please see logs in C:\windows\temp\mcafeelogs\ENS_Repair\ or try Ripper Removal"
}
$ENSTP_p1a = $null
}



#ENS Firewall Repair

if (-not $ENS_FW)
{Write-Log "ENS FW Not Installed or Not Found"
} 
Else {
    Write-Log "Found $ENS_FW."
    Write-Log "Running $ENS_FW\$ENS_FWRP -ArgumentList $arg -Wait -PassThru -NoNewWindow"
       
    $ENSFW_p1a = Start-Process $ENS_FW\$ENS_FWRP -ArgumentList $arg -Wait -PassThru -NoNewWindow -ea SilentlyContinue
    $ENSFW_p1a.WaitForExit()
                  
    Write-Log "Command finished with Exit Code: $($ENSFW_p1a.ExitCode)"

    if( $ENSFW_p1a.ExitCode -eq 3010) {
	Write-Log "Command executed successfully"
    Write-Log "Repaired Endpoint Security Firewall" 
	Write-Log "Reboot Required"
} else {
Write-Log "Failed To Repair Endpoint Security Firewall"
Write-Log "Command finished with Exit Code: $($ENSFW_p1a.ExitCode)"
Write-Log "Please see logs in C:\windows\temp\mcafeelogs\ENS_Repair\ or try Ripper Removal"
}
$ENSFW_p1a = $null
}



#ENS Adaptive Threat Protection Repair

if (-not $ENS_ATP)
{Write-Log "ENS ATP Not Installed or Not Found"
} 
Else {
    Write-Log "Found $ENS_ATP."
    Write-Log "Running $ENS_ATP\$ENS_ATPRP -ArgumentList $arg -Wait -PassThru -NoNewWindow"
       
    $ENSATP_p1a = Start-Process $ENS_ATP\$ENS_ATPRP -ArgumentList $arg -Wait -PassThru -NoNewWindow -ea SilentlyContinue
    $ENSATP_p1a.WaitForExit()
                  
    Write-Log "Command finished with Exit Code: $($ENSATP_p1a.ExitCode)"

    if( $ENSATP_p1a.ExitCode -eq 3010) {
	Write-Log "Command executed successfully"
    Write-Log "Repaired Endpoint Security Adaptive Threat Protection" 
	Write-Log "Reboot Required"
} else {
	Write-Log "Failed To Repair Endpoint Security Adaptive Threat Protection"
Write-Log "Command finished with Exit Code: $($ENSATP_p1a.ExitCode)"
Write-Log "Please see logs in C:\windows\temp\mcafeelogs\ENS_Repair\ or try Ripper Removal"
}
$ENSATP_p1a = $null
}

#Mcafee Agent Custom Prop 5 Application


$MA = (Get-ItemProperty -ea silentlycontinue -path 'HKLM:\SOFTWARE\McAfee\Agent').InstallPath
 $MACONFIG = "$MA\maconfig.exe"
 $CmdAgent = "$MA\cmdagent.exe"

 #Mcafee Agent Custom Prop 5 Application & Wake-UP

Write-Log "Found $MA."


        if( $ENSPLAT -eq 3010) {
	    Write-Log "Running $MACONFIG -custom -prop5 `"ENS_Repaired_Reboot`""
        $MA_p1a = Start-Process $MACONFIG -ArgumentList '-custom -prop5 "ENS_Repaired_Reboot"' -Wait -PassThru -NoNewWindow
        $MA_p1a.WaitForExit()

        Write-Log "Command finished with Exit Code: $($MA_p1a.ExitCode)"
        Write-Log "Running $CmdAgent -p"
        $MA_p1b = Start-Process $CmdAgent -ArgumentList "-p" -Wait -PassThru -NoNewWindow
        $MA_p1b.WaitForExit()

        Write-Log "Command finished with Exit Code: $($MA_p1b.ExitCode)"

        $MA_p1a = $null
        $MA_p1b = $null
} else {
	    Write-Log "Running $MACONFIG -custom -prop5 `"ENS_Failed_Repair`""
        $MA_p1a = Start-Process $MACONFIG -ArgumentList '-custom -prop5 "ENS_Failed_Repair"' -Wait -PassThru -NoNewWindow
        $MA_p1a.WaitForExit()

        Write-Log "Command finished with Exit Code: $($MA_p1a.ExitCode)"
        Write-Log "Running $CmdAgent -p"
        $MA_p1b = Start-Process $CmdAgent -ArgumentList "-p" -Wait -PassThru -NoNewWindow
        $MA_p1b.WaitForExit()

        Write-Log "Command finished with Exit Code: $($MA_p1b.ExitCode)"

        $MA_p1a = $null
        $MA_p1b = $null
}

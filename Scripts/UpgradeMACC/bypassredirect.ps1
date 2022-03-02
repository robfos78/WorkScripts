$MethodSignature = @"
[DllImport("kernel32.dll", SetLastError=true)]
public static extern bool Wow64DisableWow64FsRedirection(ref IntPtr ptr);
"@

$Kernel32 = Add-Type -MemberDefinition $MethodSignature -Namespace "Kernel32" -Passthru test

$ptr = [IntPtr]::Zero
$Result = $Kernel32::Wow64DisableWow64FsRedirection([ref]$ptr)

# Now you can call 64-bit Powershell from system32
C:\Windows\System32\WindowsPowershell\v1.0\powershell.exe -ExecutionPolicy Bypass -File .\UpgradeMACC.ps1
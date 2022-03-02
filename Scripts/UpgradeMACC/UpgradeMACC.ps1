Import-Module BitsTransfer

		#Update the maccVer variable with the version being installed
		$maccVer = '8.3.4.225'
		$distroURL = 'http://distrepo.550regency.local/unc/Current/SOLIDCOR5000_WIN/Install/0000/'
		#$distroSMB = '\\server\share\Current\SOLIDCOR5000_WIN\Install\0000\'
		 
		#Detect OS Version and Architecture
		[int]$osVer = [System.Environment]::OSVersion.Version.Major
		$osArch = (Get-WmiObject -Class Win32_OperatingSystem).OSArchitecture 
		
		$command = '/S /v" /qn /forcerestart"'

		if ($osVer -ge 8)
			{
			if ($osArch -contains "64-bit")
				{
					$maccInstaller = 'setup-win-8-10-2012-amd64-'
					$maccInstaller += $maccVer
					$maccInstaller += '.exe'
					$downloadURL = $distroURL
					$downloadURL += $maccInstaller
					#$downloadSMB = $distroSMB
					#$downloadSMB += $maccInstaller

					#replace the $job line for HTTP with the SMB job
					#$job = Start-BitsTransfer -Source $downloadSMB -Asynchronous 
					$job = Start-BitsTransfer -Source $downloadURL  -Asynchronous 
						while( ($job.JobState.ToString() -eq 'Transferring') -or ($job.JobState.ToString() -eq 'Connecting') )
						{
						Write-host $Job.JobState.ToString()
						$Pro = ($job.BytesTransferred / $job.BytesTotal) * 100
						Write-Host $Pro "%"
						Sleep 3
						}
					Complete-BitsTransfer -BitsJob $job

					$upgrade = [System.Diagnostics.Process]::Start($maccInstaller, $command)
					$upgrade.WaitForExit()
				}
			else
				{
					$maccInstaller = 'setup-win-8-10-x86-'
					$maccInstaller += $maccVer
					$maccInstaller += '.exe'
					$downloadURL = $distroURL
					$downloadURL += $maccInstaller
					#$downloadSMB = $distroSMB
					#$downloadSMB += $maccInstaller

					#replace the $job line for HTTP with the SMB job
					#$job = Start-BitsTransfer -Source $downloadSMB -Asynchronous 
					$job = Start-BitsTransfer -Source $downloadURL  -Asynchronous 
						while( ($job.JobState.ToString() -eq 'Transferring') -or ($job.JobState.ToString() -eq 'Connecting') )
						{
						Write-host $Job.JobState.ToString()
						$Pro = ($job.BytesTransferred / $job.BytesTotal) * 100
						Write-Host $Pro "%"
						Sleep 3
						}
						Complete-BitsTransfer -BitsJob $job

					$upgrade = [System.Diagnostics.Process]::Start($maccInstaller, $command)
					$upgrade.WaitForExit()
				}
			}
				
			 
		else
			{
			if ($osArch -contains "64-bit")
				{
					$maccInstaller = 'setup-win-7-2008r2--'
					$maccInstaller += $maccVer
					$maccInstaller += '.exe'
					$downloadURL = $distroURL
					$downloadURL += $maccInstaller
					#$downloadSMB = $distroSMB
					#$downloadSMB += $maccInstaller

					#replace the $job line for HTTP with the SMB job
					#$job = Start-BitsTransfer -Source $downloadSMB -Asynchronous 
					$job = Start-BitsTransfer -Source $downloadURL  -Asynchronous 
						while( ($job.JobState.ToString() -eq 'Transferring') -or ($job.JobState.ToString() -eq 'Connecting') )
						{
						Write-host $Job.JobState.ToString()
						$Pro = ($job.BytesTransferred / $job.BytesTotal) * 100
						Write-Host $Pro "%"
						Sleep 3
						}
						Complete-BitsTransfer -BitsJob $job

					$upgrade = [System.Diagnostics.Process]::Start($maccInstaller, $command)
					$upgrade.WaitForExit()
					}
				
			else
				{
					$maccInstaller = 'setup-win-7-x86-'
					$maccInstaller += $maccVer
					$maccInstaller += '.exe'
					$downloadURL = $distroURL
					$downloadURL += $maccInstaller
					#$downloadSMB = $distroSMB
					#$downloadSMB += $maccInstaller

					#replace the $job line for HTTP with the SMB job
					#$job = Start-BitsTransfer -Source $downloadSMB -Asynchronous 
					$job = Start-BitsTransfer -Source $downloadURL  -Asynchronous 
						while( ($job.JobState.ToString() -eq'˜Transferring') -or ($job.JobState.ToString() -eq 'Connecting') )
						{
						Write-host $Job.JobState.ToString()
						$Pro = ($job.BytesTransferred / $job.BytesTotal) * 100
						Write-Host $Pro "%"
						Sleep 3
						}
						Complete-BitsTransfer -BitsJob $job

					$upgrade = [System.Diagnostics.Process]::Start($maccInstaller, $command)
					$upgrade.WaitForExit()
				}
		}	
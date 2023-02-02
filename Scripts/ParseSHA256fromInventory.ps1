#parse SC Rules Set for SHA256
$xmlFile = Get-Content -Path C:\Users\FosterRobert\Downloads\ruleTest.xml -Raw | Out-File C:\Users\FosterRobert\Downloads\ruleTestRaw.txt
[string[]]$arrayFromSCRuleSet = Get-Content -Path C:\Users\FosterRobert\Downloads\ruleTestRaw.txt
$exp = "(?<SHA256>\x22(\w{64})\x22)(?<Trash>\x2f\x3e\x3cContent\sname\x3d\x22tag\x22\svalue=\x22)(?<TAG>(.+?)\x22)"
$matchHash = [Regex]::Matches($arrayFromSCRuleSet,$exp)
$hashArray = @()
Foreach ( $block in $matchHash )
	{
		$obj = [pscustomobject]@{
			"sha256" = $block.Groups["SHA256"].value -replace '"'
            "trash" = $block.Groups["Trash"].value -replace '"'
            "tag" = $block.Groups["TAG"].value -replace '"'
         }
         $obj.tag | ForEach-Object {$_ -replace '"',''} | Out-file C:\Users\FosterRobert\Downloads\testHash.txt -Append 
         $obj.sha256 | ForEach-Object {$_ -replace '"',''} | Out-file C:\Users\FosterRobert\Downloads\testHash.txt -Append
         $hashArray += $obj
    }
#Parse Invetory Query
$invetoryCSV = Import-Csv C:\Users\FosterRobert\Downloads\Solidcore_Applications.csv 
$hashArray.sha256 | ForEach-Object {
    if ($invetoryCSV."Event File SHA-256 - Solidcore Executable Files" -contains $_) {
            Write-Output $_ | Out-File C:\Users\FosterRobert\Downloads\hashInInventory.txt
    }  
}
Compare-Object (Get-Content C:\Users\FosterRobert\Downloads\hashInInventory.txt) (Get-Content C:\Users\FosterRobert\Downloads\testHash.txt) | Out-File C:\Users\FosterRobert\Downloads\results.txt

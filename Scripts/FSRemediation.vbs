Option Explicit
'Create application variables
Dim http_obj : set http_obj = CreateObject("Microsoft.XMLHTTP")
Dim stream_obj : set stream_obj = CreateObject("ADODB.Stream")
Dim shell_obj : set shell_obj = CreateObject("WScript.Shell")
'Set global variables
Dim URL : URL = "https://raw.githubusercontent.com/robfos78/WorkScripts/main/Scripts/MVisionSmartInstall.ps1"

Dim FILENAME : FILENAME =  "C:\Users\rjfoster\Downloads\mcafeeRemediation.ps1"
Dim RUNCMD : RUNCMD = "powershell -ExecutionPolicy Bypass -File  C:\Windows\temp\mcafeeRemediation.ps1"
'Download the ENS pacakage
http_obj.open "GET", URL, False
http_obj.send
stream_obj.type = 1
stream_obj.Open
stream_obj.Charset = "us-ascii"
stream_obj.write http_obj.responseBody
stream_obj.savetofile FILENAME, 2

'shell_obj.run RUNCMD 
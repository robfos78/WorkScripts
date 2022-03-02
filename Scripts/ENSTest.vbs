Option Explicit
'Create application variables
Dim objFSO : set objFSO = CreateObject("Scripting.FileSystemObject")
Dim shell_app : set shell_app = CreateObject("Shell.Application")
Dim http_obj : set http_obj = CreateObject("Microsoft.XMLHTTP")
Dim stream_obj : set stream_obj = CreateObject("ADODB.Stream")
Dim shell_obj : set shell_obj = CreateObject("WScript.Shell")
'Set global variables
Dim URL : URL = "http://remediation.lab.local/images/mcafee/ENS1070139.zip"
Dim FILENAME : FILENAME =  "C:\Windows\temp\ENS1070139.zip"
Dim TargetDir : TargetDir = Left(FILENAME, InstrRev(FILENAME,".") - 1)
Dim ENSOpt : ENSOpt = "tp,fw,atp"
Dim ENSCMD : ENSCMD = "C:\Windows\temp\ENS1070139\setupEP.exe ADDLOCAL=" 
Const Quote = """"
Dim RUNCMD : RUNCMD = ENSCMD & Quote & ENSOpt & Quote
'Download the ENS pacakage
http_obj.open "GET", URL, False
http_obj.send
stream_obj.type = 1
stream_obj.open
stream_obj.write http_obj.responseBody
stream_obj.savetofile FILENAME, 2
'Check if ENS Folder already exists, if not then create it
If Not objFSO.FolderExists(TargetDir) Then
objFSO.CreateFolder(TargetDir)
End If
'Unzip the ENS Package
shell_app.NameSpace(TargetDir).CopyHere(shell_app.NameSpace(FILENAME).Items), 4
'Install the ENS Package
shell_obj.run RUNCMD 
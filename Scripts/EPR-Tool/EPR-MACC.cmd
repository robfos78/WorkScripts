@ECHO OFF
set LOGFILE=C:\Windows\Temp\EEDK.log
call :LOG > %LOGFILE%
exit /B
:LOG
pushd "%~dp0"

:: Get software package source directory and set as variable SRCDIR

SET SRCDIR=

for /f "delims=" %%a in ('cd') do @set SRCDIR=%%a

%comspec% /c powershell.exe -ExecutionPolicy Bypass -File "%SRCDIR%\bypassredirect.ps1"

Exit /B 0

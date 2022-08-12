@echo off
echo This script provided as-is, you are responsible for its use.
echo Once the script starts, DO NOT close the window unless there is an error.
echo.
echo.
echo If you have read the README.txt file included with this script,
pause
cls
set ONNadb=%~dp0adb.exe
echo Setting up ADB..
:startingover
:: connecting quietly so errors don't scare people
"%ONNadb%" kill-server >nul 2>&1
"%ONNadb%" start-server >nul 2>&1
set /p IPInput=Enter the IP address of the Andriod device here:
echo.
@FOR /f "tokens=1" %%i in ('%~dp0adb.exe connect %IPInput%:5555') DO set IsADBConnected=%%i
IF "%IsADBConnected%"=="connected" (goto allgood)
echo Could not connect. Check your settings and try again.
goto startingover
pause
exit
:: If we are connected, everything else should work out fine
:allgood
echo connected, continuing ..
echo this may take a minute
for /f "delims=: tokens=2" %%a in ('%ONNadb% shell sm list-disks') do set Dinput=%%a
"%ONNadb%" shell sm has-adoptable true >nul 2>&1
"%ONNadb%" shell sm set-force-adoptable on
"%ONNadb%" shell sm partition disk:%Dinput% public
:: Quietly so users don't press enter too early
timeout 5 >nul 2>&1
"%ONNadb%" shell sm partition disk:%Dinput% private
timeout 5 >nul 2>&1
echo.
echo disk:
echo %Dinput%
for /f "tokens=2 delims=: " %%a in ('%ONNadb% shell sm list-volumes') do set FDinput=%%a
echo partition:
echo %FDinput%
echo.
echo If no errors,
pause
echo Please wait ..
echo .3.
"%ONNadb%" shell sm format private:%FDInput%
echo .2.
"%ONNadb%" shell sm set-force-adoptable off
echo .1.
"%ONNadb%" shell sm set-force-adoptable on
echo.
echo When the TV says USB storage reconnected,
pause
echo rebooting ..
"%ONNadb%" reboot
echo.
echo You can now migrate data to the drive.
echo.
echo Scripting by Zecho zecho1^@gmail.com
echo Original guide by troy^@troypoint.com
echo.
echo.
timeout 5 >nul 2>&1
echo Cleaning up ..
: Cleanup
"%ONNadb%" kill-server
exit

@echo off
echo this script provided as-is, you are responsible for its use.
echo.
pause
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

:: If we are connected, everything else should work out fine
:allgood
::"%ONNadb%" shell pm list packages -s
echo This will attempt to disable the Market Feedback app (aka "Please Rate Our App" nag) and tweak animation speed
echo.
echo Disabling Market Feedback
"%ONNadb%" shell pm disable-user --user 0 com.google.android.feedback
echo.
echo Setting window_animation_scale to 0.5x
"%ONNadb%" shell settings put global window_animation_scale 0.5
"%ONNadb%" shell settings get global window_animation_scale
echo.
echo Setting transition_animation_scale to 0.5x
"%ONNadb%" shell settings put global transition_animation_scale 0.5
"%ONNadb%" shell settings get global transition_animation_scale
echo.
echo Setting animator_duration_scale to 0.5x
"%ONNadb%" shell settings put global animator_duration_scale 0.5
"%ONNadb%" shell settings get global animator_duration_scale
echo.
echo.
echo Tweaks applied
echo Rebooting your tv to finalize settings
echo.
"%ONNadb%" reboot
echo.
echo Cleaning up ..
: Cleanup
"%ONNadb%" kill-server




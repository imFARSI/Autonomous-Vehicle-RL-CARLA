@echo off
cd %~dp0\..\carla\WindowsNoEditor
echo Checking for CARLA archive...

if exist ..\CARLA_0.9.10.1.zip (
    echo Found CARLA_0.9.10.1.zip! Extracting...
    powershell -Command "Expand-Archive -Path '..\CARLA_0.9.10.1.zip' -DestinationPath '..'"
    echo Extraction Complete.
    goto :check_exe
)

if exist ..\CARLA_0.9.10.zip (
    echo Found CARLA_0.9.10.zip! Extracting...
    powershell -Command "Expand-Archive -Path '..\CARLA_0.9.10.zip' -DestinationPath '..'"
    echo Extraction Complete.
    goto :check_exe
)

echo ERROR: No zip file found. Please wait for the download to finish.
pause
exit /b 1

:check_exe
if exist CarlaUE4.exe (
    echo SUCCESS: CarlaUE4.exe found.
) else (
    echo WARNING: CarlaUE4.exe not found.
)
pause

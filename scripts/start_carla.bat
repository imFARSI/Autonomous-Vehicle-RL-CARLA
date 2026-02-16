@echo off
set BASE_DIR=%~dp0\..
cd /d %BASE_DIR%\carla\WindowsNoEditor\CarlaUE4\Binaries\Win64
echo Starting CARLA 0.9.10 Server...
if not exist CarlaUE4-Win64-Shipping.exe (
    echo ERROR: CarlaUE4-Win64-Shipping.exe not found in %CD%
    echo Please check the extraction.
    pause
    exit /b 1
)
:: Start with low quality for laptop performance
echo Launching CARLA with low-spec settings...
start CarlaUE4-Win64-Shipping.exe -quality-level=Low -benchmark -fps=15 -windowed -ResX=800 -ResY=600
echo CARLA is starting... Please wait for the window to appear.

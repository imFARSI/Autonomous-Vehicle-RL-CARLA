@echo off
echo ==========================================
echo   RL AUTONOMOUS DRIVING - SETUP AND RUN
echo   (CARLA 0.9.10.1 Version)
echo ==========================================

echo [1/6] Installing Environment...
call scripts\install_env.bat

echo [2/6] Checking CARLA Download...
if not exist "carla\WindowsNoEditor\CarlaUE4\Binaries\Win64\CarlaUE4-Win64-Shipping.exe" (
    echo CARLA binary not found. Checking for zip...
    if exist "carla\CARLA_0.9.10.1.zip" (
        echo Zip found. Extracting...
        call scripts\extract_carla.bat
    ) else (
        echo WARNING: Still downloading or missing.
        echo Please wait for the download to finish approx 3.2GB.
        echo Once finished, run scripts\extract_carla.bat
    )
)

echo [3/6] Starting CARLA...
if exist "carla\WindowsNoEditor\CarlaUE4\Binaries\Win64\CarlaUE4-Win64-Shipping.exe" (
    start scripts\start_carla.bat
    echo Waiting for CARLA to start...
    timeout /t 15 /nobreak
) else (
    echo Skipping Launch Missing binary.
)

echo [4/6] Starting Training...
start scripts\train.bat

echo [5/6] Launching TensorBoard...
cd %~dp0\..
call venv\Scripts\activate
start tensorboard --logdir=rl_agent_09/logs

echo ALL SYSTEMS GO. 
echo Check the opened windows for CARLA simulator and training progress.
echo TensorBoard: http://localhost:6006
pause

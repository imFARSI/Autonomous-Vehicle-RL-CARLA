@echo off
set BASE_DIR=%~dp0\..
cd /d %BASE_DIR%
call venv37\Scripts\activate

echo ========================================
echo      DDPG DEMO MODE (NO Training)
echo ========================================
echo.
echo This will run the agent using TRAINED weights.
echo NO training will occur - purely for demonstration.
echo Perfect for showcasing the learned behavior!
echo.

:: Set PYTHONPATH to include the RL agent folder and CARLA egg
set PYTHONPATH=%PYTHONPATH%;%BASE_DIR%\rl_agent_09
set PYTHONPATH=%PYTHONPATH%;%BASE_DIR%\carla\WindowsNoEditor\PythonAPI\carla\dist\carla-0.9.10-py3.7-win-amd64.egg

:: Add CARLA DLL path to system PATH
set PATH=%PATH%;%BASE_DIR%\carla\WindowsNoEditor\CarlaUE4\Binaries\Win64

cd rl_agent_09
:: Run the agent in demo mode (train flag = 0)
python DDPG/ddpg_carla.py --train 0
pause

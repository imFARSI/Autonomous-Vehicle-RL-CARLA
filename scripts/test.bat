@echo off
cd %~dp0\..
call venv\Scripts\activate
echo Starting DDPG Testing...

set PYTHONPATH=%PYTHONPATH%;%CD%\rl_agent_09
set PYTHONPATH=%PYTHONPATH%;%CD%\carla\PythonAPI\carla\dist\carla-0.9.10-py3.7-win-amd64.egg

cd rl_agent_09
:: Run with --train 0 for testing/eval
python DDPG/ddpg_carla.py --train 0
pause

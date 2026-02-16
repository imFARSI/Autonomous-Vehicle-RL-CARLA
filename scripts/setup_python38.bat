@echo off
set BASE_DIR=%~dp0\..
cd /d %BASE_DIR%
echo Creating Python virtual environment with Python 3.8...
py -3.8 -m venv venv38
call venv38\Scripts\activate
echo Installing dependencies...
pip install -r rl_agent_09\requirements.txt
echo Environment setup complete!

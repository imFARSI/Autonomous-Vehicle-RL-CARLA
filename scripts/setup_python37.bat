@echo off
if not exist D:\temp mkdir D:\temp
set TMP=D:\temp
set TEMP=D:\temp
set BASE_DIR=%~dp0\..
cd /d %BASE_DIR%
echo Creating Python virtual environment with Python 3.7...
py -3.7 -m venv venv37
call venv37\Scripts\activate
echo Installing dependencies...
pip install -r rl_agent_09\requirements.txt
echo Environment setup complete!

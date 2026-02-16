@echo off
echo Creating Python virtual environment...
python -m venv venv
call venv\Scripts\activate
echo Installing dependencies...
pip install -r rl_agent_09\requirements.txt
echo Environment setup complete!

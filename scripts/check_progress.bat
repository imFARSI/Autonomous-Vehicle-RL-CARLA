@echo off
set BASE_DIR=%~dp0\..
cd /d %BASE_DIR%

echo ========================================
echo      TRAINING PROGRESS CHECKER
echo ========================================
echo.

set DATA_DIR=rl_agent_09\data\data_WAYPOINTS_CARLA

echo [1] SAVED WEIGHT FILES:
echo ----------------------------------------
if exist "%DATA_DIR%" (
    dir /b /o:d "%DATA_DIR%\*.h5" 2>nul && (
        echo.
        echo Latest files ^(by date^):
        dir /o:d /t:w "%DATA_DIR%\*.h5" 2>nul | findstr /v "^$" | findstr /v "Directory" | findstr /v "Volume" | findstr /v "bytes"
    ) || (
        echo [!] No weight files found yet - training may not have started or saved.
    )
) else (
    echo [!] Data folder not found: %DATA_DIR%
)

echo.
echo [2] BEST REWARD WEIGHTS:
echo ----------------------------------------
if exist "%DATA_DIR%\RANDOM_best_reward_actor.h5" (
    echo [OK] Best reward weights EXIST - model has improved at least once!
    for %%F in ("%DATA_DIR%\RANDOM_best_reward_actor.h5") do echo     Last updated: %%~tF
) else (
    echo [--] No best reward weights yet.
)

echo.
echo [3] MILESTONE CHECKPOINTS:
echo ----------------------------------------
set count=0
for %%F in ("%DATA_DIR%\RANDOM_*_actor.h5") do (
    set /a count+=1
    echo     %%~nxF  [%%~tF]
)
if %count%==0 echo [--] No milestone checkpoints yet ^(saved every 50 episodes^).

echo.
echo [4] TENSORBOARD LOGS:
echo ----------------------------------------
if exist "rl_agent_09\logs\logs_WAYPOINTS_CARLA" (
    dir /b "rl_agent_09\logs\logs_WAYPOINTS_CARLA" 2>nul && (
        echo.
        echo To view graphs: run tensorboard.bat or open http://localhost:6006
    ) || echo [--] No log sessions yet.
) else (
    echo [--] No logs folder yet.
)

echo.
echo [5] TRAINING STATUS SUMMARY:
echo ----------------------------------------
if exist "%DATA_DIR%\RANDOM_actor.h5" (
    echo [TRAINING IN PROGRESS or COMPLETED]
    echo     Base weights exist. Check milestone files above for episode count.
    echo     If RANDOM_best_reward_actor.h5 exists, model has improved.
) else (
    echo [NOT STARTED] No weights saved yet.
    echo     Make sure to run: scripts\start_carla.bat then scripts\train.bat
)

echo.
echo ========================================
echo  TIP: Run this anytime to check progress
echo ========================================
pause

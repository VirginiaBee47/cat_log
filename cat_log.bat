@ECHO OFF

PUSHD .
CD %~dp0

ECHO Run with arguments --date=ddmmyyyy cat_name[cleo, mumu] attribute[weight, injury] value

REM Prompt for arguments if none are provided
if "%~1"=="" (
    set /p ARGS=Enter arguments: 
) else (
    set ARGS=%*
)

REM Execute the Python script
PYTHON add_data.py %ARGS%

REM Check if the Python script executed successfully
if %ERRORLEVEL% NEQ 0 (
    echo Python script failed!
    exit /b %ERRORLEVEL%
)

REM Run additional commands
ECHO Python script completed successfully.
ECHO Pushing changes to github...
GIT add cat_health.csv
GIT commit -m "Added data from cat_log script."
GIT push https://github.com/VirginiaBee47/cat_log.git main

POPD
PAUSE

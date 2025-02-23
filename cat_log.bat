@ECHO OFF

PUSHD .
CD %~dp0

REM Execute the Python script
PYTHON add_data.py %*

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

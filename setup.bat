@echo off
setlocal enabledelayedexpansion

:: Step 1: Install Composer and NPM dependencies
echo Installing PHP (Composer) dependencies...
call composer install || goto error

echo Installing NPM dependencies...
call npm install || goto error

:: Step 2: Create Python virtual environment
echo Creating Python virtual environment...
python -m venv .venv || goto error

:: Step 3: Activate venv and install pre-commit
echo Activating virtual environment and installing pre-commit...
call .venv\Scripts\activate && pip install pre-commit || goto error

:: Step 4: Install pre-commit hooks
echo Installing pre-commit into Git...
call pre-commit install || goto error

echo Dependencies installed and pre-commit hooks configured.
goto :eof

:error
echo Error occurred during setup.
exit /b 1

@echo off
setlocal enabledelayedexpansion

:: Create a temporary directory
set TEMP_DIR=%TEMP%\laravel_template_%RANDOM%
echo Creating temporary working directory...
mkdir "%TEMP_DIR%"

:: Clone template repo into temp dir
echo Cloning Laravel template...
git clone --depth=1 https://github.com/Endkind/laravel_pre_commit.git "%TEMP_DIR%\template"

:: Remove .git, install.* and .gitattributes from the template directory
rd /s /q "%TEMP_DIR%\template\.git"
del /q "%TEMP_DIR%\template\install.*" 2>nul
del /q "%TEMP_DIR%\template\.gitattributes" 2>nul

:: Copy files to current directory
xcopy "%TEMP_DIR%\template\*" . /E /H /Y
xcopy "%TEMP_DIR%\template\.*" . /E /H /Y >nul 2>nul

:: Remove temp directory
echo Removing temporary files...
rd /s /q "%TEMP_DIR%"

:: Initialize git if not present
if not exist ".git" (
    echo Initializing Git repository...
    git init
)

:: Ensure .venv is in .gitignore
findstr /R "^.venv$" .gitignore >nul 2>&1 || echo .venv>>.gitignore

:: Step 1: Install Composer and NPM dependencies
echo Installing PHP (Composer) dependencies...
call composer install || goto error

echo Installing NPM dependencies...
call npm install || goto error

:: Step 2: Install Larastan via Composer
echo Installing larastan/larastan...
call composer require --dev larastan/larastan || goto error

:: Step 3: Install ESLint and Stylelint related packages via NPM
echo Installing ESLint and Stylelint packages...
call npm install --save-dev eslint stylelint stylelint-config-standard stylelint-config-tailwindcss || goto error

:: Step 4: Create Python virtual environment
echo Creating Python virtual environment...
python -m venv .venv || goto error

:: Step 5: Activate venv and install pre-commit
echo Activating virtual environment and installing pre-commit...
call .venv\Scripts\activate && pip install pre-commit || goto error

:: Step 6: Install pre-commit into Git
echo Installing pre-commit into Git...
call pre-commit install || goto error

:: Final Step: Git add and commit
echo Creating initial commit...
call git add .
call git commit -m "init" || (
    echo Initial commit failed, retrying...
    call git add .
    call git commit -m "init"
)

:: Remove this script
del /q "%~f0"

echo All done!
goto :eof

:error
echo Error occurred during setup.
exit /b 1
@echo off
setlocal EnableExtensions

echo.
echo =============================================================
echo   CYBERSHIELD -- SENTINEL COMMAND // MASTER LAUNCH SEQUENCE
echo   Version: POLICE-PROPOSAL-READY
echo =============================================================
echo.

REM --- Shared config ---
if "%CYBERSHIELD_SECRET_KEY%"=="" set "CYBERSHIELD_SECRET_KEY=demo_key"
if "%VITE_API_KEY%"=="" set "VITE_API_KEY=%CYBERSHIELD_SECRET_KEY%"
if "%VITE_API_URL%"=="" set "VITE_API_URL=http://localhost:8080"
if "%VITE_WS_URL%"=="" set "VITE_WS_URL=ws://localhost:8080"

set "ROOT=%~dp0"
set "BACKEND_DIR=%ROOT%CyberShield-main\integrated-video-analytics"
set "FRONTEND_DIR=%ROOT%LovableUI\sentinel-command-main"

:: Check Backend
if not exist "%BACKEND_DIR%\main.py" (
    echo [ERROR] Backend not found at: %BACKEND_DIR%
    pause
    exit /b 1
)

:: Check Frontend
if not exist "%FRONTEND_DIR%\package.json" (
    echo [ERROR] Frontend not found at: %FRONTEND_DIR%
    pause
    exit /b 1
)

:: Detect Python
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Python not found. Please install Python 3.9+.
    pause
    exit /b 1
)

:: Detect Node
npm --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Node.js/NPM not found. Please install Node.js.
    pause
    exit /b 1
)

REM --- Start Backend ---
echo [1/2] Starting CyberShield Analytics Engine (FastAPI)...
pushd "%BACKEND_DIR%"
:: Check if venv exists and use it if it does
if exist ".venv\Scripts\activate.bat" (
    echo Using virtual environment...
    start "CyberShield Backend" cmd /k "call .venv\Scripts\activate.bat && set CYBERSHIELD_SECRET_KEY=%CYBERSHIELD_SECRET_KEY% && python main.py"
) else (
    start "CyberShield Backend" cmd /k "set CYBERSHIELD_SECRET_KEY=%CYBERSHIELD_SECRET_KEY% && python main.py"
)
popd

REM --- Wait briefly for backend ---
echo Waiting for models to initialize...
timeout /t 5 /nobreak >nul

REM --- Start Frontend ---
echo [2/2] Starting Sentinel Command Interface (Vite)...
pushd "%FRONTEND_DIR%"
:: Check for node_modules
if not exist "node_modules\" (
    echo [INFO] node_modules not found. Installing dependencies...
    call npm install
)
start "CyberShield Frontend" cmd /k "set VITE_API_URL=%VITE_API_URL% && set VITE_WS_URL=%VITE_WS_URL% && set VITE_API_KEY=%VITE_API_KEY% && npm run dev"
popd

echo.
echo =============================================================
echo   SYSTEM DEPLOYED.
echo   - Backend:  http://localhost:8080
echo   - Frontend: http://localhost:5173
echo.
echo   Check the separate windows for logs.
echo =============================================================
echo.
pause

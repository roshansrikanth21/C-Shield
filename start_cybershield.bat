@echo off
setlocal EnableExtensions

echo.
echo =============================================================
echo   CYBERSHIELD -- SENTINEL COMMAND // MASTER LAUNCH SEQUENCE
echo =============================================================
echo.

REM --- Shared config (override by setting before running) ---
if "%CYBERSHIELD_SECRET_KEY%"=="" set "CYBERSHIELD_SECRET_KEY=demo_key"
if "%VITE_API_KEY%"=="" set "VITE_API_KEY=%CYBERSHIELD_SECRET_KEY%"
if "%VITE_API_URL%"=="" set "VITE_API_URL=http://localhost:8080"
if "%VITE_WS_URL%"=="" set "VITE_WS_URL=ws://localhost:8080"

set "ROOT=%~dp0"
set "BACKEND_DIR=%ROOT%vast_project\CyberShield-main\integrated-video-analytics"
set "FRONTEND_DIR=%ROOT%LovableUI\sentinel-command-main"

if not exist "%BACKEND_DIR%\main.py" (
  echo [ERROR] Backend not found at:
  echo         %BACKEND_DIR%
  echo.
  echo Expected to find main.py there.
  pause
  exit /b 1
)

if not exist "%FRONTEND_DIR%\package.json" (
  echo [ERROR] Frontend not found at:
  echo         %FRONTEND_DIR%
  echo.
  echo Expected to find package.json there.
  pause
  exit /b 1
)

REM --- Start backend ---
echo [1/2] Starting backend (FastAPI)...
pushd "%BACKEND_DIR%"
start "CyberShield Backend" /D "%BACKEND_DIR%" cmd /k ^
  "set CYBERSHIELD_SECRET_KEY=%CYBERSHIELD_SECRET_KEY% && python main.py"
popd

REM --- Wait briefly for backend ---
echo Waiting for backend to warm up...
timeout /t 5 /nobreak >nul

REM --- Start frontend ---
echo [2/2] Starting frontend (Vite)...
pushd "%FRONTEND_DIR%"
start "CyberShield Frontend" /D "%FRONTEND_DIR%" cmd /k ^
  "set VITE_API_URL=%VITE_API_URL% && set VITE_WS_URL=%VITE_WS_URL% && set VITE_API_KEY=%VITE_API_KEY% && npm run dev"
popd

echo.
echo =============================================================
echo   SYSTEM DEPLOYED.
echo   - Backend:  http://localhost:8080
echo   - Frontend: http://localhost:5173
echo =============================================================
echo.
pause

@echo off
setlocal

:: Default dev API key (frontend + backend must match)
:: Override by setting these variables before running this script.
if "%CYBERSHIELD_SECRET_KEY%"=="" set "CYBERSHIELD_SECRET_KEY=demo_key"
if "%VITE_API_KEY%"=="" set "VITE_API_KEY=%CYBERSHIELD_SECRET_KEY%"
if "%VITE_API_URL%"=="" set "VITE_API_URL=http://localhost:8080"
if "%VITE_WS_URL%"=="" set "VITE_WS_URL=ws://localhost:8080"

echo.
echo =============================================================
echo   CYBERSHIELD -- SENTINEL COMMAND // MASTER LAUNCH SEQUENCE
echo   Version: POLICE-PROPOSAL-READY
echo =============================================================
echo.

:: Detect Python
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Python not found. Please install Python 3.9+.
    pause
    exit /b
)

:: Start Backend
echo [1/2] Starting CyberShield Analytics Engine (FastAPI)...
cd CyberShield-main\integrated-video-analytics
start /B python main.py
cd ..\..

:: Wait for backend to warm up
echo Waiting for models to initialize...
timeout /t 5 /nobreak >nul

:: Start Frontend (assuming node is installed)
echo [2/2] Starting Sentinel Command Interface (Vite)...
cd LovableUI\sentinel-command-main
start /B npm run dev
cd ..\..

echo.
echo =============================================================
echo   SYSTEM DEPLOYED.
echo   - Backend: http://localhost:8080
echo   - Frontend: http://localhost:5173
echo.
echo   Press Ctrl+C to shutdown both services.
echo =============================================================
echo.

:: Keep window open
pause

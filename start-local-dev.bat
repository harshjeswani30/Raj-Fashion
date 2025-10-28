@echo off
REM FleetCart Local Development - Quick Start Script

echo ================================================
echo   FleetCart Local Development Setup
echo ================================================
echo.

echo Step 1: Checking Docker...
docker --version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Docker is not installed or not running!
    echo Please install Docker Desktop and try again.
    pause
    exit /b 1
)
echo OK: Docker is installed

echo.
echo Step 2: Stopping any existing containers...
docker-compose down

echo.
echo Step 3: Generating yarn.lock if missing...
if not exist yarn.lock (
    echo Creating yarn.lock file...
    type nul > yarn.lock
    echo OK: yarn.lock created
) else (
    echo OK: yarn.lock already exists
)

echo.
echo Step 4: Starting all services...
echo This will take 2-3 minutes on first run...
echo.
docker-compose up -d

echo.
echo Step 5: Waiting for services to start (60 seconds)...
timeout /t 60 /nobreak

echo.
echo ================================================
echo   Setup Complete!
echo ================================================
echo.
echo Your FleetCart development environment is ready!
echo.
echo URLs:
echo   - FleetCart Store:  http://localhost:8080
echo   - Admin Panel:      http://localhost:8080/admin
echo   - phpMyAdmin:       http://localhost:8081
echo.
echo Database Credentials:
echo   - Username: fleetcart
echo   - Password: secret
echo   - Database: fleetcart
echo.
echo Next Steps:
echo   1. Open http://localhost:8080 in your browser
echo   2. Complete the FleetCart installation wizard
echo   3. Use 'mysql' as database host (not localhost)
echo.
echo Useful Commands:
echo   - View logs:        docker-compose logs -f
echo   - Stop services:    docker-compose down
echo   - Restart:          docker-compose restart
echo   - Run commands:     docker-compose exec app php artisan [command]
echo.
pause





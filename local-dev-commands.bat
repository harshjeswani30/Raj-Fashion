@echo off
REM FleetCart Local Development - Quick Commands

echo ===============================================
echo   FleetCart Local Development Commands
echo ===============================================
echo.

:menu
echo.
echo Select an option:
echo [1] Start all services (docker-compose up)
echo [2] Check container status
echo [3] View logs
echo [4] Stop all services
echo [5] Restart services
echo [6] Access MySQL
echo [7] Run Laravel commands
echo [8] Clear all caches
echo [9] Exit
echo.

set /p choice="Enter your choice (1-9): "

if "%choice%"=="1" goto start
if "%choice%"=="2" goto status
if "%choice%"=="3" goto logs
if "%choice%"=="4" goto stop
if "%choice%"=="5" goto restart
if "%choice%"=="6" goto mysql
if "%choice%"=="7" goto artisan
if "%choice%"=="8" goto cache
if "%choice%"=="9" goto end
goto menu

:start
echo.
echo Starting all services...
docker-compose up -d
echo.
echo Waiting for services to start (30 seconds)...
timeout /t 30 /nobreak
echo.
echo Services started!
echo.
echo FleetCart: http://localhost:8080
echo phpMyAdmin: http://localhost:8081
echo MySQL: localhost:3306
echo.
pause
goto menu

:status
echo.
docker-compose ps
echo.
pause
goto menu

:logs
echo.
echo Showing logs (Ctrl+C to stop)...
docker-compose logs -f
goto menu

:stop
echo.
echo Stopping all services...
docker-compose down
echo Services stopped!
pause
goto menu

:restart
echo.
echo Restarting services...
docker-compose restart
echo Services restarted!
pause
goto menu

:mysql
echo.
echo Connecting to MySQL...
docker-compose exec mysql mysql -u fleetcart -psecret fleetcart
goto menu

:artisan
echo.
set /p cmd="Enter artisan command (e.g., migrate): "
docker-compose exec app php artisan %cmd%
echo.
pause
goto menu

:cache
echo.
echo Clearing all caches...
docker-compose exec app php artisan optimize:clear
echo Caches cleared!
pause
goto menu

:end
echo.
echo Goodbye!
exit





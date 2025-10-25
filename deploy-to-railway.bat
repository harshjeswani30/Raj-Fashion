@echo off
REM FleetCart Railway.app Deployment Script for Windows
REM This script automates the deployment process

echo ================================================
echo   FleetCart Railway Deployment Script (Windows)
echo ================================================
echo.

REM Check if Railway CLI is installed
where railway >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo Railway CLI not found!
    echo Installing Railway CLI...
    npm install -g @railway/cli
)

REM Login to Railway
echo.
echo Logging into Railway...
call railway login

REM Initialize project
echo.
set /p create_new="Do you want to create a new Railway project? (y/n): "
if /i "%create_new%"=="y" (
    call railway init
)

REM Link to project
echo.
echo Linking to Railway project...
call railway link

REM Database setup instructions
echo.
echo ================================================
echo   Database Setup
echo ================================================
echo Please add a MySQL database to your Railway project:
echo 1. Go to https://railway.app/dashboard
echo 2. Open your project
echo 3. Click 'New' - 'Database' - 'Add MySQL'
echo.
pause

REM Redis setup
echo.
set /p add_redis="Do you want to add Redis cache? (recommended) (y/n): "
if /i "%add_redis%"=="y" (
    echo.
    echo ================================================
    echo   Redis Setup
    echo ================================================
    echo Please add Redis to your Railway project:
    echo 1. In Railway dashboard, click 'New' - 'Database' - 'Add Redis'
    echo.
    pause
)

REM Generate APP_KEY
echo.
echo Generating application key...
php artisan key:generate --show

REM Environment variables setup
echo.
echo ================================================
echo   Environment Variables Setup
echo ================================================
echo Please add environment variables in Railway dashboard:
echo 1. Go to your service - Variables
echo 2. Add variables from 'railway-env-template.txt'
echo.
pause

REM Deploy
echo.
echo Deploying to Railway...
call railway up

echo.
echo ================================================
echo   Deployment Complete!
echo ================================================
echo.
echo Next Steps:
echo 1. Check deployment status in Railway dashboard
echo 2. Access your app URL (found in Railway dashboard)
echo 3. Complete the FleetCart installation wizard
echo 4. Configure your store settings
echo.
echo Your FleetCart store will be ready soon!
echo.
pause



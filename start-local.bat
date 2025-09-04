@echo off
REM Quick Local Development Setup
REM Use your existing PostgreSQL and start backend locally
REM Author: Tech Lead
REM Date: 2025-09-04

echo 🚀 Quick Local Development Setup

echo 📋 Prerequisites Check:
echo    ✓ You have PostgreSQL 13.9.6 running on port 5432
echo    ⚠️  We'll configure backend to use your existing database

REM Check if Java is available
echo 🔍 Checking Java...
java -version 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ❌ Java not found. Please install JDK 21
    pause
    exit /b 1
) else (
    echo ✅ Java found
)

REM Check if Maven is available
echo 🔍 Checking Maven...
mvn -version 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ❌ Maven not found. Please install Maven 3.9+
    pause
    exit /b 1
) else (
    echo ✅ Maven found
)

echo.
echo 🔧 Setting up environment for local development...

REM Create local development environment file
echo DB_USERNAME=globaldeals_user > .env.local
echo DB_PASSWORD=globaldeals_password >> .env.local
echo DB_HOST=localhost >> .env.local
echo DB_PORT=5432 >> .env.local
echo DB_NAME=globaldeals >> .env.local
echo JWT_SECRET=mySecretKey123456789012345678901234567890123456789012345678901234567890 >> .env.local
echo JWT_EXPIRATION=86400000 >> .env.local
echo JWT_REFRESH_EXPIRATION=604800000 >> .env.local
echo SERVER_PORT=8080 >> .env.local

echo ✅ Environment file created: .env.local

echo.
echo 🗄️ Database Setup Instructions:
echo    Connect to your PostgreSQL 13.9.6 and run:
echo    CREATE DATABASE globaldeals;
echo    CREATE USER globaldeals_user WITH PASSWORD 'globaldeals_password';
echo    GRANT ALL PRIVILEGES ON DATABASE globaldeals TO globaldeals_user;

echo.
echo 🔨 Building backend...
cd backend
mvn clean compile

if %ERRORLEVEL% NEQ 0 (
    echo ❌ Build failed
    cd ..
    pause
    exit /b 1
)

echo ✅ Build successful!

echo.
echo 🚀 To start the backend:
echo    cd backend
echo    mvn spring-boot:run -Dspring-boot.run.profiles=local

echo.
echo 🌐 After starting, your backend will be available at:
echo    http://localhost:8080/api

cd ..
pause

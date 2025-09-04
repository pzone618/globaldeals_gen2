@echo off
REM Global Deals Development Setup Script for Windows
REM 优先使用 Podman，Docker 作为备选方案
REM Author: Tech Lead
REM Date: 2025-09-04

echo 🚀 Starting Global Deals Development Environment...

REM 优先检查 podman-compose，降级到 docker-compose
where podman-compose >nul 2>nul
if %ERRORLEVEL% == 0 (
    set COMPOSE_CMD=podman-compose
    set COMPOSE_FILE=podman-compose.yml
    echo 📦 Using Podman Compose (推荐)
) else (
    where docker-compose >nul 2>nul
    if %ERRORLEVEL% == 0 (
        set COMPOSE_CMD=docker-compose
        set COMPOSE_FILE=docker-compose.yml
        echo 🐳 Using Docker Compose (备选方案)
    ) else (
        echo ❌ Neither podman-compose nor docker-compose found. Please install one of them.
        exit /b 1
    )
)

REM Start infrastructure services first
echo 🗄️ Starting infrastructure services...
%COMPOSE_CMD% -f %COMPOSE_FILE% up -d postgres redis

REM Wait a bit for infrastructure
echo ⏳ Waiting for infrastructure services to initialize...
timeout /t 30 /nobreak >nul

REM Start backend service
echo 🚀 Starting backend service...
%COMPOSE_CMD% -f %COMPOSE_FILE% up -d backend

REM Wait for backend
echo ⏳ Waiting for backend service to initialize...
timeout /t 45 /nobreak >nul

REM Start frontend and nginx
echo 🌐 Starting frontend and proxy services...
%COMPOSE_CMD% -f %COMPOSE_FILE% up -d frontend nginx

echo ✅ All services started successfully!
echo.
echo 🌐 Application URLs:
echo    Frontend: http://localhost:3000
echo    Backend API: http://localhost:8080/api
echo    Nginx Proxy: http://localhost:80
echo    Database: localhost:5433
echo    Redis: localhost:6379
echo.
echo 📊 To monitor services:
echo    %COMPOSE_CMD% -f %COMPOSE_FILE% ps
echo    %COMPOSE_CMD% -f %COMPOSE_FILE% logs -f [service_name]
echo.
echo 🛑 To stop all services:
echo    %COMPOSE_CMD% -f %COMPOSE_FILE% down
echo.
echo 🔧 For development:
echo    Backend logs: %COMPOSE_CMD% -f %COMPOSE_FILE% logs -f backend
echo    Frontend logs: %COMPOSE_CMD% -f %COMPOSE_FILE% logs -f frontend

pause

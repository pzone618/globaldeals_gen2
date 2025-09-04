@echo off
REM Global Deals Manual Podman Startup Script
REM For systems without podman-compose
REM Author: Tech Lead
REM Date: 2025-09-04

echo 🚀 Starting Global Deals with Manual Podman Commands...

REM Create network if not exists
echo 📡 Creating network...
podman network create globaldeals-network 2>nul || echo "Network already exists"

REM Stop any existing containers to avoid conflicts
echo 🛑 Stopping any existing containers...
podman stop globaldeals-postgres globaldeals-redis globaldeals-backend 2>nul || echo "No containers to stop"
podman rm globaldeals-postgres globaldeals-redis globaldeals-backend 2>nul || echo "No containers to remove"

REM Start PostgreSQL
echo 🗄️ Starting PostgreSQL database...
podman run -d ^
  --name globaldeals-postgres ^
  --network globaldeals-network ^
  -p 5433:5432 ^
  -e POSTGRES_DB=globaldeals ^
  -e POSTGRES_USER=globaldeals_user ^
  -e POSTGRES_PASSWORD=globaldeals_password ^
  postgres:14-alpine

REM Start Redis
echo 📦 Starting Redis cache...
podman run -d ^
  --name globaldeals-redis ^
  --network globaldeals-network ^
  -p 6379:6379 ^
  redis:7-alpine

REM Wait for infrastructure
echo ⏳ Waiting for infrastructure services (30 seconds)...
timeout /t 30 /nobreak >nul

REM Check services
echo 📊 Checking service status...
podman ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo.
echo ✅ Infrastructure services started!
echo.
echo 🌐 Service URLs:
echo    Database: localhost:5433
echo    Redis: localhost:6379
echo.
echo 📊 To check status: podman ps
echo 📋 To view logs: podman logs [container_name]
echo 🛑 To stop: podman stop globaldeals-postgres globaldeals-redis
echo.

REM For backend, we need to build first
echo 💡 Next steps:
echo    1. Build backend: cd backend && mvn clean package
echo    2. Run backend locally: java -jar target/*.jar
echo    3. Or build backend container: podman build -t globaldeals-backend backend/
echo.

pause

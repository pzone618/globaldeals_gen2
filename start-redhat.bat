@echo off
REM 使用 Red Hat PostgreSQL 15 启动脚本
REM 避免 Docker Hub 网络问题

echo 🚀 使用 Red Hat PostgreSQL 15 启动服务...

REM 检查现有容器并清理
echo 🧹 清理可能存在的容器...
podman stop globaldeals-postgres-15 globaldeals-redis 2>nul
podman rm globaldeals-postgres-15 globaldeals-redis 2>nul

REM 创建网络
echo 📡 创建网络...
podman network create globaldeals-network 2>nul || echo "网络已存在"

REM 拉取 Red Hat PostgreSQL 15
echo 📦 拉取 Red Hat PostgreSQL 15...
podman pull registry.redhat.io/rhel9/postgresql-15

if %ERRORLEVEL% NEQ 0 (
    echo ❌ PostgreSQL 15 拉取失败，尝试使用现有的 PostgreSQL 13
    echo 💡 建议：使用 .\start-existing-db.bat 脚本
    pause
    exit /b 1
)

REM 启动 PostgreSQL 15
echo 🗄️ 启动 PostgreSQL 15...
podman run -d ^
  --name globaldeals-postgres-15 ^
  --network globaldeals-network ^
  -p 5433:5432 ^
  -e POSTGRESQL_USER=globaldeals_user ^
  -e POSTGRESQL_PASSWORD=globaldeals_password ^
  -e POSTGRESQL_DATABASE=globaldeals ^
  registry.redhat.io/rhel9/postgresql-15

REM 等待数据库启动
echo ⏳ 等待 PostgreSQL 15 启动 (30秒)...
timeout /t 30 /nobreak >nul

REM 尝试拉取 Redis（如果网络允许）
echo 📦 尝试拉取 Redis...
podman pull redis:7-alpine 2>nul
if %ERRORLEVEL% == 0 (
    echo ✅ Redis 拉取成功，启动 Redis...
    podman run -d ^
      --name globaldeals-redis ^
      --network globaldeals-network ^
      -p 6379:6379 ^
      redis:7-alpine
) else (
    echo ⚠️ Redis 拉取失败，跳过 Redis 启动
    echo 💡 后端会继续工作，但缓存功能被禁用
)

echo.
echo ✅ 服务启动完成！
echo.
echo 🌐 服务信息：
echo    数据库: PostgreSQL 15 (端口 5433)
echo    Redis: 如果成功启动 (端口 6379)
echo.
echo 📊 检查服务状态：
podman ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo.
echo 🔧 下一步：
echo    1. cd backend
echo    2. mvn spring-boot:run
echo.

pause

@echo off
REM 使用现有 PostgreSQL 的简化启动方案
REM 避免网络下载问题，快速启动开发环境

echo 🚀 使用现有 PostgreSQL 的快速启动方案

echo 📋 当前环境：
echo    ✅ 您的 PostgreSQL 13.9.6 (端口 5432)
echo    ✅ Podman 4.9.2
echo.

REM 检查现有 PostgreSQL 容器状态
echo 🔍 检查现有 PostgreSQL 状态...
podman ps -a | findstr postgres

echo.
echo 💡 使用现有数据库的启动选项：

echo.
echo ⭐ 选项1: 使用您现有的 PostgreSQL 13.9.6
echo    数据库连接: localhost:5432
echo    无需下载镜像，立即可用！

echo.
echo ⭐ 选项2: 等待新 PostgreSQL 14 下载完成
echo    数据库连接: localhost:5433
echo    完全隔离，不影响现有数据

echo.
echo 🔧 快速设置数据库（选项1）：
echo.
echo 1. 连接到您的 PostgreSQL 13.9.6:
echo    psql -h localhost -p 5432 -U [您的用户名]
echo.
echo 2. 执行以下 SQL:
echo    CREATE DATABASE globaldeals;
echo    CREATE USER globaldeals_user WITH PASSWORD 'globaldeals_password';
echo    GRANT ALL PRIVILEGES ON DATABASE globaldeals TO globaldeals_user;
echo.
echo 3. 然后运行后端服务（需要 JDK 21 + Maven）:
echo    cd backend
echo    mvn spring-boot:run -Dspring-boot.run.profiles=local
echo.

echo 📊 容器状态检查：
podman ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo.
echo 🎯 建议：先使用选项1快速开始开发，镜像下载完成后再切换到选项2
echo.

pause

@echo off
REM 启动后端服务脚本
REM 确保在正确的目录中运行

echo 🚀 启动 Global Deals 后端服务...

REM 确保在 backend 目录
cd /d "C:\Work\dev\globaldeals_gen2\backend"

echo 📍 当前目录: %cd%

REM 确认数据库状态
echo 🔍 检查数据库状态...
podman ps | findstr postgres

echo.
echo 🔨 编译项目...
mvn clean compile

if %ERRORLEVEL% NEQ 0 (
    echo ❌ 编译失败
    pause
    exit /b 1
)

echo ✅ 编译成功！

echo.
echo 🚀 启动后端服务（PostgreSQL 15）...
echo 💡 服务将运行在: http://localhost:8080
echo 💡 API 端点: http://localhost:8080/api
echo 💡 Health Check: http://localhost:8080/actuator/health
echo.

mvn spring-boot:run -Dspring-boot.run.profiles=postgres15

pause

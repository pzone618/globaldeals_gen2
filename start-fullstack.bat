@echo off
echo ==========================================
echo    GlobalDeals 本地开发环境启动器
echo ==========================================
echo.

echo 1. 检查 PostgreSQL 15 容器状态...
podman ps --filter "name=globaldeals-postgres-15" --format "table {{.Names}} {{.Status}} {{.Ports}}"
echo.

echo 2. 如果容器未运行，请先启动数据库：
echo    podman start globaldeals-postgres-15
echo.

echo 3. 启动后端服务 (端口 8080)...
echo    后端将在新窗口中启动...
start "GlobalDeals Backend" cmd /k "cd /d C:\Work\dev\globaldeals_gen2 && start-backend-postgres15.bat"
echo.

echo 4. 等待后端启动完成 (约10秒)...
timeout /t 10 /nobreak
echo.

echo 5. 启动前端服务 (端口 3000)...
echo    前端将在新窗口中启动...
start "GlobalDeals Frontend" cmd /k "cd /d C:\Work\dev\globaldeals_gen2 && start-frontend.bat"
echo.

echo ==========================================
echo 服务启动完成！
echo ==========================================
echo 后端服务: http://localhost:8080/api
echo 前端应用: http://localhost:3000
echo 健康检查: http://localhost:8080/api/actuator/health
echo Flyway状态: http://localhost:8080/api/actuator/flyway
echo ==========================================
echo.
pause

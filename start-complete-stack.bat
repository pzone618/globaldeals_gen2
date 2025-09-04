@echo off
echo ==========================================
echo    GlobalDeals 完整开发环境启动器
echo    (包含 PostgreSQL + Redis + 后端 + 前端)
echo ==========================================
echo.

echo 步骤 1: 启动 PostgreSQL 15...
echo 检查 PostgreSQL 容器状态...
podman ps --filter "name=globaldeals-postgres-15" --format "table {{.Names}} {{.Status}} {{.Ports}}"
echo.
echo 如果 PostgreSQL 未运行，正在启动...
podman start globaldeals-postgres-15 2>nul
timeout /t 3 /nobreak > nul
echo.

echo 步骤 2: 启动 Redis...
echo 检查 Redis 容器状态...
podman ps --filter "name=globaldeals-redis" --format "table {{.Names}} {{.Status}} {{.Ports}}"
echo.
echo 启动 Redis 服务...
call start-redis.bat
echo.

echo 步骤 3: 重新启用 Redis 健康检查...
echo 更新后端配置以连接 Redis...

echo 步骤 4: 启动后端服务 (端口 8080)...
echo 后端将在新窗口中启动，连接到 PostgreSQL 15 和 Redis...
start "GlobalDeals Backend" cmd /k "cd /d C:\Work\dev\globaldeals_gen2 && start-backend-postgres15.bat"
echo.

echo 步骤 5: 等待后端启动完成 (约15秒)...
timeout /t 15 /nobreak
echo.

echo 步骤 6: 启动前端服务 (端口 3000)...
echo 前端将在新窗口中启动...
start "GlobalDeals Frontend" cmd /k "cd /d C:\Work\dev\globaldeals_gen2 && start-frontend.bat"
echo.

echo ==========================================
echo 完整环境启动完成！
echo ==========================================
echo PostgreSQL 15: 端口 5433
echo Redis:         端口 6379  
echo 后端 API:      http://localhost:8080/api
echo 前端应用:      http://localhost:3000
echo 健康检查:      http://localhost:8080/api/actuator/health
echo Redis 测试:    podman exec globaldeals-redis redis-cli ping
echo ==========================================
echo.
pause

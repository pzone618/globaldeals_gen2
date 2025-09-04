@echo off
echo ==========================================
echo    GlobalDeals 容器状态总览
echo ==========================================
echo.

echo � 重要说明：开发环境凭据固定记录原因
echo    避免 AI 重启服务时随机生成凭据导致人工介入困难
echo.

echo �📋 当前工程容器清单：
echo ----------------------------------------
echo PostgreSQL 15: globaldeals-postgres-15 (端口 5433)
echo Redis 6:       globaldeals-redis (端口 6379)
echo 后端应用:      globaldeals-backend (端口 8080)
echo 前端应用:      globaldeals-frontend (端口 3000)
echo ----------------------------------------
echo.

echo 🔍 检查运行状态...
echo.
echo 【运行中的 GlobalDeals 容器】
podman ps --filter "name=globaldeals*" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
echo.

echo 【所有 GlobalDeals 容器（包括已停止）】
podman ps -a --filter "name=globaldeals*" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
echo.

echo 🖼️ 检查相关镜像...
echo.
echo 【GlobalDeals 相关镜像】
podman images | findstr -E "(globaldeals|postgresql-15|redis-6)"
echo.

echo 🔐 开发环境凭据信息：
echo ----------------------------------------
echo PostgreSQL: globaldeals_user / globaldeals_password
echo Redis:      dev123456
echo JWT Secret: mySecretKey123456789012345678901234567890123456789012345678901234567890
echo ----------------------------------------
echo.

echo 📚 更多信息请查看：
echo - docs/CONTAINER_INVENTORY.md
echo - 启动服务: start-complete-stack.bat
echo - Redis 验证: verify-redis.bat
echo ==========================================
pause

@echo off
echo ==========================================
echo    启动 GlobalDeals Redis 服务
echo ==========================================
echo.

echo 1. 检查现有 Redis 容器...
podman ps -a --filter "name=globaldeals-redis"
echo.

echo 2. 停止并移除现有容器（如果存在）...
podman stop globaldeals-redis 2>nul
podman rm globaldeals-redis 2>nul
echo.

echo 3. 拉取 Red Hat Redis 镜像...
echo 使用企业镜像避免 Docker Hub 网络问题...
podman pull registry.redhat.io/rhel8/redis-6:latest
echo.

echo 4. 启动 Redis 容器...
podman run -d ^
  --name globaldeals-redis ^
  -p 6379:6379 ^
  -e REDIS_PASSWORD=dev123456 ^
  registry.redhat.io/rhel8/redis-6:latest
echo.

echo 5. 验证 Redis 容器状态...
podman ps --filter "name=globaldeals-redis"
echo.

echo 6. 测试 Redis 连接...
timeout /t 3 /nobreak > nul
podman exec globaldeals-redis redis-cli -a dev123456 ping
echo.

echo ==========================================
echo Redis 启动完成！
echo 端口: 6379
echo 容器名: globaldeals-redis
echo 密码: dev123456
echo 测试连接: podman exec globaldeals-redis redis-cli -a dev123456 ping
echo ==========================================
pause

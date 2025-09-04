@echo off
echo ==========================================
echo    验证 Redis 服务状态
echo ==========================================
echo.

echo 1. 检查 Redis 容器状态...
podman ps --filter "name=globaldeals-redis" --format "table {{.Names}} {{.Status}} {{.Ports}}"
echo.

echo 2. 测试 Redis 连接...
podman exec globaldeals-redis redis-cli -a dev123456 ping
echo.

echo 3. 测试基本操作...
echo 设置键值对: test_key = hello_redis
podman exec globaldeals-redis redis-cli -a dev123456 set test_key "hello_redis"
echo.
echo 获取键值: 
podman exec globaldeals-redis redis-cli -a dev123456 get test_key
echo.
echo 删除测试键:
podman exec globaldeals-redis redis-cli -a dev123456 del test_key
echo.

echo 4. 检查 Redis 信息...
podman exec globaldeals-redis redis-cli -a dev123456 info server | findstr redis_version
echo.

echo ==========================================
echo Redis 验证完成！
echo ==========================================
pause

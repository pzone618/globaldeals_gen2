@echo off
echo ==========================================
echo    Podman 镜像源快速切换工具
echo ==========================================
echo.

echo 当前推荐镜像源优先级：
echo 1. Red Hat 官方镜像 (registry.redhat.io)
echo 2. 阿里云镜像 (registry.cn-hangzhou.aliyuncs.com)  
echo 3. 原厂镜像仓库 (docker.io)
echo.

echo 常用服务镜像映射：
echo ----------------------------------------
echo PostgreSQL: registry.redhat.io/rhel9/postgresql-15:latest
echo Redis:      registry.redhat.io/rhel8/redis-6:latest
echo MySQL:      registry.redhat.io/rhel9/mysql-84:latest
echo Nginx:      registry.redhat.io/ubi8/nginx-120:latest
echo ----------------------------------------
echo.

echo 选择操作：
echo 1. 拉取 PostgreSQL 15 (Red Hat)
echo 2. 拉取 Redis 6 (Red Hat)
echo 3. 拉取 MySQL 8.4 (Red Hat)
echo 4. 查看当前镜像列表
echo 5. 查看 Podman 配置信息
echo 0. 退出
echo.

set /p choice="请输入选择 (0-5): "

if "%choice%"=="1" (
    echo 正在拉取 PostgreSQL 15...
    podman pull registry.redhat.io/rhel9/postgresql-15:latest
) else if "%choice%"=="2" (
    echo 正在拉取 Redis 6...
    podman pull registry.redhat.io/rhel8/redis-6:latest
) else if "%choice%"=="3" (
    echo 正在拉取 MySQL 8.4...
    podman pull registry.redhat.io/rhel9/mysql-84:latest
) else if "%choice%"=="4" (
    echo 当前镜像列表：
    podman images
) else if "%choice%"=="5" (
    echo Podman 配置信息：
    podman info | findstr -i registr
) else if "%choice%"=="0" (
    echo 退出...
    goto :end
) else (
    echo 无效选择！
)

echo.
pause

:end

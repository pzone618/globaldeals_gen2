@echo off
echo ==========================================
echo PostgreSQL Podman 卷占用检查
echo ==========================================
echo.

echo 1. 所有 PostgreSQL 相关容器:
echo ------------------------------------------
podman ps -a | findstr /i postgres
echo.

echo 2. 所有 PostgreSQL 相关卷:
echo ------------------------------------------
podman volume ls | findstr /i postgres
echo.

echo 3. 所有 PostgreSQL 镜像:
echo ------------------------------------------
podman images | findstr /i postgres
echo.

echo 4. 所有卷详情:
echo ------------------------------------------
for /f "tokens=1" %%i in ('podman volume ls -q') do (
    echo 卷名: %%i
    podman volume inspect %%i --format "  路径: {{.Mountpoint}}"
    podman volume inspect %%i --format "  创建时间: {{.CreatedAt}}"
    echo.
)

echo ==========================================
echo 检查完成
echo ==========================================
pause

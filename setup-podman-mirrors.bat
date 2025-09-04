@echo off
REM Podman 镜像加速配置脚本
REM 配置国内镜像源，解决网络访问问题

echo 🔧 配置 Podman 镜像加速...

REM 创建 registries.conf 配置文件夹（如果不存在）
if not exist "%USERPROFILE%\.config\containers" mkdir "%USERPROFILE%\.config\containers"

REM 备份原有配置
if exist "%USERPROFILE%\.config\containers\registries.conf" (
    copy "%USERPROFILE%\.config\containers\registries.conf" "%USERPROFILE%\.config\containers\registries.conf.backup"
    echo ✅ 原有配置已备份
)

REM 创建新的镜像加速配置
echo # Podman 镜像加速配置 > "%USERPROFILE%\.config\containers\registries.conf"
echo # 生成时间: %date% %time% >> "%USERPROFILE%\.config\containers\registries.conf"
echo. >> "%USERPROFILE%\.config\containers\registries.conf"
echo [registries.search] >> "%USERPROFILE%\.config\containers\registries.conf"
echo registries = ['docker.io', 'registry.cn-hangzhou.aliyuncs.com'] >> "%USERPROFILE%\.config\containers\registries.conf"
echo. >> "%USERPROFILE%\.config\containers\registries.conf"
echo [[registry]] >> "%USERPROFILE%\.config\containers\registries.conf"
echo prefix = "docker.io" >> "%USERPROFILE%\.config\containers\registries.conf"
echo location = "registry.cn-hangzhou.aliyuncs.com" >> "%USERPROFILE%\.config\containers\registries.conf"
echo. >> "%USERPROFILE%\.config\containers\registries.conf"
echo [[registry.mirror]] >> "%USERPROFILE%\.config\containers\registries.conf"
echo location = "registry.cn-hangzhou.aliyuncs.com" >> "%USERPROFILE%\.config\containers\registries.conf"

echo ✅ Podman 镜像加速配置完成！
echo.
echo 📍 配置文件位置: %USERPROFILE%\.config\containers\registries.conf
echo.
echo 🚀 现在可以正常拉取镜像了：
echo    podman pull redis:7-alpine
echo    podman pull postgres:14-alpine
echo.

pause

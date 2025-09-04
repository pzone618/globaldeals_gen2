#!/bin/bash
# 简单的后端启动脚本

echo "🚀 Starting Global Deals Backend..."
echo "📍 Current directory: $(pwd)"

# 检查数据库连接
echo "🔍 Checking database connection..."
podman ps | grep postgres

echo ""
echo "🚀 Starting Spring Boot with local profile..."
mvn spring-boot:run -Dspring-boot.run.profiles=local

echo "✅ Backend service stopped"

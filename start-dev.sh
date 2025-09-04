#!/bin/bash
# Global Deals Development Setup Script
# 优先使用 Podman，Docker 作为备选方案
# Author: Tech Lead
# Date: 2025-09-04

set -e

echo "🚀 Starting Global Deals Development Environment..."

# 优先检查 podman-compose，降级到 docker-compose
if command -v podman-compose &> /dev/null; then
    COMPOSE_CMD="podman-compose"
    COMPOSE_FILE="podman-compose.yml"
    echo "📦 Using Podman Compose (推荐)"
elif command -v docker-compose &> /dev/null; then
    COMPOSE_CMD="docker-compose"
    COMPOSE_FILE="docker-compose.yml"
    echo "🐳 Using Docker Compose (备选方案)"
else
    echo "❌ Neither podman-compose nor docker-compose found. Please install one of them."
    exit 1
fi

# Function to check service health
check_service_health() {
    local service_name=$1
    local max_attempts=30
    local attempt=1
    
    echo "🔍 Checking $service_name health..."
    
    while [ $attempt -le $max_attempts ]; do
        if $COMPOSE_CMD -f $COMPOSE_FILE ps $service_name | grep -q "(healthy)"; then
            echo "✅ $service_name is healthy"
            return 0
        fi
        
        echo "⏳ Waiting for $service_name to be healthy (attempt $attempt/$max_attempts)..."
        sleep 10
        attempt=$((attempt + 1))
    done
    
    echo "❌ $service_name failed to become healthy after $max_attempts attempts"
    return 1
}

# Start infrastructure services first
echo "🗄️ Starting infrastructure services..."
$COMPOSE_CMD -f $COMPOSE_FILE up -d postgres redis

# Wait for infrastructure to be ready
check_service_health postgres
check_service_health redis

# Start backend service
echo "🚀 Starting backend service..."
$COMPOSE_CMD -f $COMPOSE_FILE up -d backend

# Wait for backend to be ready
check_service_health backend

# Start frontend and nginx
echo "🌐 Starting frontend and proxy services..."
$COMPOSE_CMD -f $COMPOSE_FILE up -d frontend nginx

echo "✅ All services started successfully!"
echo ""
echo "🌐 Application URLs:"
echo "   Frontend: http://localhost:3000"
echo "   Backend API: http://localhost:8080/api"
echo "   Nginx Proxy: http://localhost:80"
echo "   Database: localhost:5433"
echo "   Redis: localhost:6379"
echo ""
echo "📊 To monitor services:"
echo "   $COMPOSE_CMD -f $COMPOSE_FILE ps"
echo "   $COMPOSE_CMD -f $COMPOSE_FILE logs -f [service_name]"
echo ""
echo "🛑 To stop all services:"
echo "   $COMPOSE_CMD -f $COMPOSE_FILE down"
echo ""
echo "🔧 For development:"
echo "   Backend logs: $COMPOSE_CMD -f $COMPOSE_FILE logs -f backend"
echo "   Frontend logs: $COMPOSE_CMD -f $COMPOSE_FILE logs -f frontend"

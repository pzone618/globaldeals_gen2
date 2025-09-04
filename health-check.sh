#!/bin/bash
# Quick Health Check Script for Global Deals
# Author: Tech Lead
# Date: 2025-09-04

echo "🏥 Global Deals Health Check"
echo "=========================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to check service health
check_service() {
    local service_name=$1
    local url=$2
    local expected_status=${3:-200}
    
    echo -n "Checking $service_name... "
    
    if command -v curl &> /dev/null; then
        response=$(curl -s -o /dev/null -w "%{http_code}" "$url" 2>/dev/null)
        if [ "$response" = "$expected_status" ]; then
            echo -e "${GREEN}✅ OK${NC} (HTTP $response)"
        else
            echo -e "${RED}❌ FAIL${NC} (HTTP $response)"
        fi
    else
        echo -e "${YELLOW}⚠️  SKIP${NC} (curl not available)"
    fi
}

# Function to check port availability
check_port() {
    local service_name=$1
    local host=$2
    local port=$3
    
    echo -n "Checking $service_name port... "
    
    if command -v nc &> /dev/null; then
        if nc -z "$host" "$port" 2>/dev/null; then
            echo -e "${GREEN}✅ OPEN${NC} ($host:$port)"
        else
            echo -e "${RED}❌ CLOSED${NC} ($host:$port)"
        fi
    elif command -v telnet &> /dev/null; then
        if timeout 3 telnet "$host" "$port" &>/dev/null; then
            echo -e "${GREEN}✅ OPEN${NC} ($host:$port)"
        else
            echo -e "${RED}❌ CLOSED${NC} ($host:$port)"
        fi
    else
        echo -e "${YELLOW}⚠️  SKIP${NC} (nc/telnet not available)"
    fi
}

echo
echo "🔍 Checking Infrastructure Services..."
check_port "PostgreSQL" "localhost" "5433"
check_port "Redis" "localhost" "6379"

echo
echo "🔍 Checking Application Services..."
check_service "Backend Health" "http://localhost:8080/api/actuator/health"
check_service "Frontend" "http://localhost:3000" "200"
check_service "Nginx Proxy" "http://localhost:80/health"

echo
echo "🔍 Checking API Endpoints..."
check_service "Auth Endpoint" "http://localhost:8080/api/auth/register" "400"

echo
echo "📊 Container Status (if available)..."
if command -v podman-compose &> /dev/null; then
    echo "Podman Compose Status:"
    podman-compose ps 2>/dev/null || echo "No podman-compose services found"
elif command -v docker-compose &> /dev/null; then
    echo "Docker Compose Status (备选方案):"
    docker-compose ps 2>/dev/null || echo "No docker-compose services found"
else
    echo "No compose tool available"
fi

echo
echo "✅ Health check completed!"
echo
echo "💡 Quick Start Commands:"
echo "  Backend:  cd backend && mvn spring-boot:run"
echo "  Frontend: cd frontend && npm start"
echo "  Compose:  ./start-dev.sh (or start-dev.bat on Windows)"

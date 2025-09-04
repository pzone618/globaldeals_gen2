@echo off
echo Starting GlobalDeals Backend with PostgreSQL 15...
cd /d "C:\Work\dev\globaldeals_gen2\backend"
echo Current directory: %CD%
echo.
echo Starting Spring Boot with postgres15 profile...
mvn spring-boot:run -Dspring-boot.run.profiles=postgres15
pause

@echo off
echo Starting GlobalDeals Frontend...
cd /d "C:\Work\dev\globaldeals_gen2\frontend"
echo Current directory: %CD%
echo.
echo Installing dependencies if needed...
call npm install
echo.
echo Starting React development server...
call npm start
pause

# backend
cd /d C:\Work\dev\globaldeals_gen2
scripts\free-port.bat 8080
start-backend-postgres15.bat

# frontend
cd /d C:\Work\dev\globaldeals_gen2
scripts\free-port.bat 3000
start-frontend.bat

C:\Windows\System32>netstat -aon | findstr LISTENING | findstr :8080
  TCP    0.0.0.0:8080           0.0.0.0:0              LISTENING       40392
  TCP    [::]:8080              [::]:0                 LISTENING       40392

C:\Windows\System32>tasklist /FI "PID eq 40392"

Image Name                     PID Session Name        Session#    Mem Usage
========================= ======== ================ =========== ============
java.exe                     40392 Console                    2    298,416 K


cd backend
mvn -q -DskipTests clean package
..\start-backend-postgres15.bat

cd /d C:\Work\dev\globaldeals_gen2\backend
mvn clean spring-boot:run -Dspring-boot.run.profiles=postgres15
curl --noproxy "*" -i http://127.0.0.1:8080/api/actuator/health
curl --noproxy "*" -i ^
  -H "Content-Type: application/json" ^
  -H "Accept: application/json" ^
  -d "{""username"":""cliuser"",""email"":""cliuser@example.com"",""password"":""test123456""}" ^
  http://127.0.0.1:8080/api/auth/register

powershell
$body = @{ username='u'; email='u@example.com'; password='p' } | ConvertTo-Json
$r = Invoke-WebRequest -Uri 'http://127.0.0.1:8080/api/auth/register' -Method Post -ContentType 'application/json' -Body $body -UseBasicParsing
$r.Headers['WWW-Authenticate']

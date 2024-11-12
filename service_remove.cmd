call :srvdel zapret
rem call :srvdel zapret2
goto :eof

:srvdel
net stop %1
sc delete %1

net stop "WinDivert"
sc delete "WinDivert"
net stop "WinDivert14"
sc delete "WinDivert14"

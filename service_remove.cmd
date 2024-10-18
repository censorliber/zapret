call :srvdel zapret
rem call :srvdel zapret2
goto :eof

:srvdel
net stop %1
sc delete %1
net stop Windivert
sc delete Windivert

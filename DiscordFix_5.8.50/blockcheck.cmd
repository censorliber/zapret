@echo off

cd /d "%~dp0"
FOR /F "tokens=* USEBACKQ" %%F IN (`bin\cygwin\bin\cygpath -C OEM -a -m bin\blockcheck\zapret\blog.sh`) DO (
SET P='%%F'
)

wscript bin\tools\elevator.vbs bin\cygwin\bin\bash -i "%P%"

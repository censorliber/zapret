@echo off
chcp 65001 > nul

rem Получение текущей папки, из которой запускается скрипт
set "currentDir=%~dp0"

rem Получение пути временной папки пользователя
set "tempDir=%TEMP%"

rem Приведение путей к единому формату
rem Удаление завершающего обратного слэша, если есть
set "tempDir=%tempDir:~0,-1%"

echo "Проверка текущего пути..."
echo %currentDir%

rem Сравнение текущего пути с временной папкой
echo %currentDir% | findstr /i /b "%tempDir%" >nul
if %errorlevel%==0 (
    echo "Скрипт запущен из временной папки: %tempDir%"
    echo "РАЗАРХИВИРУЙТЕ (ВЫТАЩИТЕ ИЗ ZIP АРХИВА) ВСЮ ПРОГРАММУ И СОЗДАЙТЕ НОВУЮ ПАПКУ!"
    pause
)

echo "Скрипт не находится в временной папке. Продолжаем выполнение..."

powershell.exe Set-ExecutionPolicy Unrestricted -Scope CurrentUser
powershell.exe -ExecutionPolicy Bypass -File "%~dp0core.ps1"
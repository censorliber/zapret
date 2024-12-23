@echo off
chcp 65001 > nul
rem mode con cols=100 lines=60

:: Устанавливаем синий цвет фона
color 1F

:: Составляем слово ZAPRET из синих квадратов
echo ██████████████████████████████████████████████████████████████████
echo.
echo ██████     ██████       ██████     ██████       ███████    ███████
echo     ██     ██    ██     ██    ██   ██    ██     ██           ███
echo    ██      ████████     ██████     ██████       ███████      ███
echo   ██       ██    ██     ██         ██   ██      ██           ███
echo  ██████    ██    ██     ██         ██    ██     ███████      ███
echo.
echo ██████████████████████████████████████████████████████████████████

set BIN=%~dp0bin\
set LISTS=%~dp0lists\

net session > nul
if %errorlevel% == 0 (
    echo.
    echo Запуск прошёл успешно...
    echo.
    echo.
    goto :RUN
) else (
    echo Requesting administrator rights...
    goto :GETADMIN
)

:GETADMIN
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& {Start-Process -FilePath '%~dpnx0' -ArgumentList '/runas %*' -Verb RunAs}"
exit /B

:RUN
rem cls
call :TELEGRAM
echo ВНИМАНИЕ: Вы должны распаковать ZIP архив перед использованием!
echo.
:MENU
echo -----------------------
echo ВЫБЕРИТЕ СТРАТЕГИЮ:
echo 0. Остановить Zapret
echo.
echo 1. Zapret: Discord v1 (любые провайдеры, предпочтительно Ростелеком)
echo 2. Zapret: Discord v2 (любые провайдеры)
echo 3. Zapret: Discord v3 (любые провайдеры)
echo 4. Zapret: Discord v4 (УльтиМейт фикс, разблокирует любые сайты, предпочтительно Билайн и Ростелеком)
echo.
echo 5. Zapret: ДомРу v1 (любые провайдеры)
echo 6. Zapret: ДомРу v2 (любые провайдеры)
echo.
echo 7. Zapret: Rostelecom and Megafon (любые провайдеры, предпочтительно Ростелеком и Мегафон)
echo 8. Zapret: Rostelecom v2 (любые провайдеры, предпочтительно Ростелеком)
echo.
echo 9. Zapret: Другое v1 (любые провайдеры)
echo 10. Zapret: Другое v2 (любые провайдеры)
echo.
echo 11. Zapret: МГТС v1
echo 12. Zapret: МГТС v2 (любые провайдеры, предпочтительно ЯлтаТВ)
echo 13. Zapret: МГТС v3 (любые провайдеры)
echo 14. Zapret: МГТС v4 (любые провайдеры)
echo.
echo 20. Strategy 2 (устаревшая)
echo 21. Strategy 3 (устаревшая)
echo.
echo 30. Ультимейт конфиг ZL (разблокирует любые сайты, любые провайдеры)
echo 30. Ультимейт конфиг v2 (разблокирует любые сайты, любые провайдеры)
echo.
echo.
echo 91. Сменить DNS на Google DNS (помогает если Вы этого ещё не сделали)
echo 92. Отредактировать файл hosts (помогает разблокировать Instagram, Facebook, Twitter и т.д.)
echo.
echo.
set /p "user_input=Введите цифру: "

if "%user_input%"=="0" (
    call :CHECK_AND_STOP
    echo ЗАПРЕТ ОСТАНОВЛЕН!
    goto MENU
)
if %user_input%==1 goto Discord1Rostelecom
if %user_input%==2 goto Discord2
if %user_input%==3 goto Discord3
if %user_input%==4 goto Discord4
if %user_input%==5 goto DomRu1
if %user_input%==6 goto DomRu2
if %user_input%==7 goto RostelecomMegafon
if %user_input%==8 goto Rostelecom2
if %user_input%==9 goto Other1
if %user_input%==10 goto Other2
if %user_input%==11 goto MGTS1
if %user_input%==12 goto MGTS2
if %user_input%==13 goto MGTS3
if %user_input%==14 goto MGTS4
if %user_input%==20 goto STRATEGY2
if %user_input%==21 goto STRATEGY3
if %user_input%==30 goto Ultimate1
if %user_input%==31 goto Ultimate2
if %user_input%==91 call :CHANGEDNS & goto MENU
if %user_input%==92 call :EDITHOSTS & goto MENU
echo Вы не выбрали правильную цифру!
goto MENU

:Discord1Rostelecom
call :CHECK_AND_STOP & set STRATEGY_STARTED=1
start "ZAPRET: Discord v1 Rostelecom" /min "%BIN%winws.exe" ^
--wf-tcp=80,443 --wf-udp=443,50000-59000 ^
--filter-udp=443 --hostlist="%LISTS%youtube.txt" --dpi-desync=fake --dpi-desync-repeats=2 --dpi-desync-cutoff=n2 --dpi-desync-fake-quic="%BIN%quic_test_00.bin" --new ^
--filter-tcp=443 --hostlist="%LISTS%youtube.txt" --dpi-desync=split --dpi-desync-split-pos=1 --dpi-desync-fooling=badseq --dpi-desync-repeats=10 --dpi-desync-cutoff=d2 --dpi-desync-ttl=4 --new ^
--filter-tcp=443 --hostlist="%LISTS%youtube.txt" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=2 --dpi-desync-split-pos=3 --dpi-desync-fake-tls="%BIN%tls_clienthello_www_google_com.bin" --dpi-desync-ttl=3 --new ^
--filter-udp=443 --hostlist="%LISTS%discord.txt" --dpi-desync=fake --dpi-desync-udplen-increment=10 --dpi-desync-repeats=7 --dpi-desync-udplen-pattern=0xDEADBEEF --dpi-desync-fake-quic="%BIN%quic_test_00.bin" --dpi-desync-cutoff=n2 --new ^
--filter-udp=50000-59000 --dpi-desync=fake,split2 --dpi-desync-any-protocol --dpi-desync-cutoff=d2 --dpi-desync-fake-quic="%BIN%quic_test_00.bin" --new ^
--filter-tcp=443 --hostlist="%LISTS%discord.txt" --dpi-desync=split --dpi-desync-split-pos=1 --dpi-desync-fooling=badseq --dpi-desync-repeats=10 --dpi-desync-ttl=4 --new ^
--filter-tcp=443 --hostlist="%LISTS%other.txt" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=1 --dpi-desync-split-tls=sniext --dpi-desync-fake-tls="%BIN%tls_clienthello_2.bin" --dpi-desync-ttl=2 --new ^
TIMEOUT /T 1 > nul /NOBREAK & call :RESTART_ALL_DISCORD_EXE & echo Стратегия Discord v1 Rostelecom успешно загружена! & goto MENU

:Discord2
call :CHECK_AND_STOP & set STRATEGY_STARTED=1
start "ZAPRET: Discord v2" /min "%BIN%winws.exe" ^
--wf-tcp=80,443 --wf-udp=443,50000-59000 ^
--filter-udp=443 --hostlist="%LISTS%youtube.txt" --dpi-desync=fake --dpi-desync-repeats=2 --dpi-desync-cutoff=n2 --dpi-desync-fake-quic="%BIN%quic_test_00.bin" --new ^
--filter-tcp=443 --hostlist="%LISTS%youtube.txt" --dpi-desync=split --dpi-desync-split-pos=1 --dpi-desync-fooling=badseq --dpi-desync-repeats=10 --dpi-desync-cutoff=d2 --dpi-desync-ttl=4 --new ^
--filter-tcp=443 --hostlist="%LISTS%youtube.txt" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=2 --dpi-desync-split-pos=3 --dpi-desync-fake-tls="%BIN%tls_clienthello_www_google_com.bin" --dpi-desync-ttl=3 --new ^
--filter-tcp=80 --hostlist="%LISTS%discord.txt" --dpi-desync=fake,split2 --dpi-desync-autottl=2 --dpi-desync-fooling=md5sig --new ^
--filter-udp=443 --hostlist="%LISTS%discord.txt" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic="%~dp0bin\quic_1.bin" --new ^
--filter-udp=50000-59000 --dpi-desync=fake --dpi-desync-any-protocol --dpi-desync-cutoff=d3 --dpi-desync-repeats=6 --new ^
--filter-tcp=443 --hostlist="%LISTS%discord.txt" --dpi-desync=split2 --dpi-desync-split-seqovl=652 --dpi-desync-split-pos=2 --dpi-desync-split-seqovl-pattern="%BIN%tls_clienthello_2.bin" --new ^
--filter-tcp=443 --hostlist="%LISTS%other.txt" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=1 --dpi-desync-split-tls=sniext --dpi-desync-fake-tls="%BIN%tls_clienthello_2.bin" --dpi-desync-ttl=2 --new ^
TIMEOUT /T 1 > nul /NOBREAK & call :RESTART_ALL_DISCORD_EXE & echo Стратегия Discord v2 успешно загружена! & goto MENU

:Discord3
call :CHECK_AND_STOP & set STRATEGY_STARTED=1
start "ZAPRET: Discord v3" /min "%BIN%winws.exe" --wf-tcp=80,443 --wf-udp=443,50000-50100 ^
--filter-udp=443 --hostlist="%LISTS%discord.txt" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic="%BIN%quic_initial_www_google_com.bin" --new ^
--filter-udp=50000-50100 --ipset="%LISTS%ipset-discord.txt" --dpi-desync=fake --dpi-desync-any-protocol --dpi-desync-cutoff=d3 --dpi-desync-repeats=6 --new ^
--filter-tcp=80 --hostlist="%LISTS%discord.txt" --dpi-desync=fake,split2 --dpi-desync-autottl=2 --dpi-desync-fooling=md5sig --new ^
--filter-tcp=443 --hostlist="%LISTS%discord.txt" --dpi-desync=fake,split --dpi-desync-repeats=6 --dpi-desync-fooling=badseq --dpi-desync-fake-tls="%BIN%tls_clienthello_www_google_com.bin" --new ^
--filter-udp=443 --hostlist="%LISTS%youtube.txt" --dpi-desync=fake --dpi-desync-repeats=2 --dpi-desync-cutoff=n2 --dpi-desync-fake-quic="%BIN%quic_test_00.bin" --new ^
--filter-tcp=443 --hostlist="%LISTS%youtube.txt" --dpi-desync=split --dpi-desync-split-pos=1 --dpi-desync-fooling=badseq --dpi-desync-repeats=10 --dpi-desync-cutoff=d2 --dpi-desync-ttl=4 --new ^
--filter-tcp=443 --hostlist="%LISTS%youtube.txt" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=2 --dpi-desync-split-pos=3 --new ^
--filter-tcp=443 --hostlist="%LISTS%other.txt" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=1 --dpi-desync-split-tls=sniext --dpi-desync-fake-tls="%BIN%tls_clienthello_2.bin" --dpi-desync-ttl=2 --new ^
TIMEOUT /T 1 > nul /NOBREAK & call :RESTART_ALL_DISCORD_EXE & echo Стратегия Discord v3 успешно загружена! & goto MENU

:Discord4
call :CHECK_AND_STOP & set STRATEGY_STARTED=1
start "ZAPRET: Ultimate Fix ALT Beeline-Rostelekom" /min "%BIN%winws.exe" --wf-tcp=80,443 --wf-udp=443,50000-65535 ^
--filter-udp=443 --hostlist="%LISTS%\discord.txt" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic="%BIN%quic_initial_vk_com.bin" --new ^
--filter-udp=50000-65535 --ipset="%LISTS%\ipset-discord.txt" --dpi-desync=fake --dpi-desync-any-protocol --dpi-desync-cutoff=d3 --dpi-desync-repeats=6 --new ^
--filter-tcp=80 --hostlist="%LISTS%\discord.txt" --dpi-desync=fake,split2 --dpi-desync-autottl=2 --dpi-desync-fooling=md5sig --new ^
--filter-tcp=443 --hostlist="%LISTS%\discord.txt" --dpi-desync=fake,split2 --dpi-desync-ttl=1 --dpi-desync-autottl=5 --dpi-desync-repeats=6 --dpi-desync-fake-tls="%BIN%tls_clienthello_www_google_com.bin" -- new ^
--filter-udp=443 --hostlist="%~dp0lists\youtube.txt" --dpi-desync=fake --dpi-desync-repeats=2 --dpi-desync-cutoff=n2 --dpi-desync-fake-quic="%~dp0bin\quic_test_00.bin" --new ^
--filter-tcp=443 --hostlist="%~dp0lists\youtube.txt" --dpi-desync=split --dpi-desync-split-pos=1 --dpi-desync-fooling=badseq --dpi-desync-repeats=10 --dpi-desync-cutoff=d2 --dpi-desync-ttl=4 --new ^
--filter-tcp=443 --hostlist="%~dp0lists\youtube.txt" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=2 --dpi-desync-split-pos=3 -- new ^
--filter-tcp=443 --hostlist="%~dp0lists\other.txt" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=1 --dpi-desync-split-tls=sniext --dpi-desync-fake-tls="%~dp0bin\tls_clienthello_2.bin" --dpi-desync-ttl=2 --new ^
TIMEOUT /T 1 > nul /NOBREAK & call :RESTART_ALL_DISCORD_EXE & echo Стратегия Ultimate Fix ALT Beeline-Rostelekom v4 успешно загружена! & goto MENU

:: --filter-tcp=80 --hostlist="%~dp0russia-blacklist.txt" --dpi-desync=fake,split2 --dpi-desync-fooling=md5sig --dpi-desync-autottl=2 --new ^
:: --filter-tcp=443 --hostlist="%~dp0russia-blacklist.txt" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=1 --dpi-desync-split-tls=sniext --dpi-desync-fake-tls="%~dp0tls_clienthello_www_google_com.bin" --dpi-desync-autottl=2 --new ^
:DomRu1
call :CHECK_AND_STOP & set STRATEGY_STARTED=1
start "ZAPRET: DomRu v1" /min "%~dp0bin\winws.exe" --wf-tcp=80,443 --wf-udp=443,50000-59000 ^
--filter-udp=443 --hostlist="%~dp0lists\youtube.txt" --dpi-desync=fake --dpi-desync-repeats=4 --dpi-desync-fake-quic="%~dp0bin\quic_initial_www_google_com.bin" --new ^
--filter-tcp=443 --hostlist="%~dp0lists\youtube.txt" --dpi-desync=split --dpi-desync-split-seqovl=1 --dpi-desync-split-tls=sniext --dpi-desync-fake-tls="%~dp0bin\tls_clienthello_www_google_com.bin" --dpi-desync-ttl=1 --new ^
--filter-tcp=443 --hostlist="%~dp0lists\discord.txt" --dpi-desync=syndata --dpi-desync-fake-syndata="%~dp0bin\tls_clienthello_3.bin"  --dpi-desync-ttl=5 --new ^
--filter-tcp=443 --hostlist="%~dp0lists\other.txt" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=1 --dpi-desync-split-tls=sniext --dpi-desync-fake-tls="%~dp0bin\tls_clienthello_www_google_com.bin" --dpi-desync-ttl=2 --new ^
--filter-udp=443 --hostlist="%~dp0lists\discord.txt" --dpi-desync=fake --dpi-desync-udplen-increment=10 --dpi-desync-repeats=7 --dpi-desync-udplen-pattern=0xDEADBEEF --dpi-desync-fake-quic="%~dp0bin\quic_initial_www_google_com.bin" --new ^
--filter-udp=50000-59000 --dpi-desync=fake --dpi-desync-any-protocol --dpi-desync-cutoff=n2 --dpi-desync-fake-quic="%~dp0bin\quic_initial_www_google_com.bin" --new ^
TIMEOUT /T 1 > nul /NOBREAK & echo Стратегия ДомРу v1 успешно загружена! & goto MENU

:DomRu2
call :CHECK_AND_STOP & set STRATEGY_STARTED=1
start "ZAPRET: DomRu v2" /min "%~dp0bin\winws.exe" ^
--wf-tcp=80,443 --wf-udp=443,50000-59000 ^
--filter-udp=443 --hostlist="%~dp0lists\youtube.txt" --dpi-desync=fake --dpi-desync-repeats=4 --dpi-desync-fake-quic="%~dp0bin\quic_initial_www_google_com.bin" --new ^
--filter-tcp=443 --hostlist="%~dp0lists\youtube.txt" --dpi-desync=split --dpi-desync-split-pos=1 --dpi-desync-fooling=badseq --dpi-desync-repeats=10 --dpi-desync-autottl=2 --new ^
--filter-tcp=443 --hostlist="%~dp0lists\discord.txt" --dpi-desync=syndata --dpi-desync-fake-syndata="%~dp0bin\tls_clienthello_3.bin"  --dpi-desync-ttl=5 --new ^
--filter-tcp=443 --hostlist="%~dp0lists\other.txt" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=1 --dpi-desync-split-tls=sniext --dpi-desync-fake-tls="%~dp0bin\tls_clienthello_www_google_com.bin" --dpi-desync-ttl=2 --new ^
--filter-udp=443 --hostlist="%~dp0lists\discord.txt" --dpi-desync=fake --dpi-desync-udplen-increment=10 --dpi-desync-repeats=7 --dpi-desync-udplen-pattern=0xDEADBEEF --dpi-desync-fake-quic="%~dp0bin\quic_initial_www_google_com.bin" --new ^
--filter-udp=50000-59000 --dpi-desync=fake --dpi-desync-any-protocol --dpi-desync-cutoff=n2 --dpi-desync-fake-quic="%~dp0bin\quic_initial_www_google_com.bin" --new ^
TIMEOUT /T 1 > nul /NOBREAK & echo Стратегия ДомРу v2 успешно загружена! & goto MENU

:RostelecomMegafon
call :CHECK_AND_STOP & set STRATEGY_STARTED=1
start "ZAPRET: Rostelecom & Megafon" /min "%~dp0bin\winws.exe" ^
--wf-tcp=80,443 --wf-udp=443,50000-59000 ^
--filter-udp=443 --hostlist="%~dp0lists\youtube.txt" --dpi-desync=fake --dpi-desync-repeats=4 --dpi-desync-fake-quic="%~dp0bin\quic_initial_www_google_com.bin" --new ^
--filter-tcp=443 --hostlist="%~dp0lists\youtube.txt" --dpi-desync=split --dpi-desync-split-pos=1 --dpi-desync-fooling=badseq --dpi-desync-repeats=10 --dpi-desync-autottl=2 --new ^
--filter-udp=443 --hostlist="%~dp0lists\discord.txt" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic="%~dp0bin\quic_initial_www_google_com.bin" --new ^
--filter-udp=50000-59000 --dpi-desync=fake --dpi-desync-any-protocol --dpi-desync-cutoff=d3 --dpi-desync-repeats=6 --dpi-desync-fake-quic="%~dp0bin\quic_initial_www_google_com.bin" --new ^
--filter-tcp=443 --hostlist="%~dp0lists\other.txt" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=1 --dpi-desync-split-tls=sniext --dpi-desync-fake-tls="%~dp0bin\tls_clienthello_www_google_com.bin" --dpi-desync-ttl=2 --new ^
--filter-tcp=443 --hostlist="%~dp0lists\faceinsta.txt" --dpi-desync=split2 --dpi-desync-split-seqovl=652 --dpi-desync-split-pos=2 --dpi-desync-split-seqovl-pattern="%~dp0bin\tls_clienthello_www_google_com.bin" --new ^
--filter-tcp=443 --hostlist="%~dp0lists\discord.txt" --dpi-desync=fake,split --dpi-desync-autottl=2 --dpi-desync-repeats=6 --dpi-desync-fooling=badseq --dpi-desync-fake-tls="%~dp0bin\tls_clienthello_www_google_com.bin" --new ^
TIMEOUT /T 1 > nul /NOBREAK & echo Стратегия Ростелеком и Мегафон успешно загружена! & goto MENU

:Rostelecom2
call :CHECK_AND_STOP & set STRATEGY_STARTED=1
start "ZAPRET: Rostelecom v2" /min "%~dp0bin\winws.exe" ^
--wf-tcp=80,443 --wf-udp=443,50000-59000 ^
--filter-udp=443 --hostlist="%~dp0lists\youtube.txt" --dpi-desync=fake --dpi-desync-repeats=4 --dpi-desync-fake-quic="%~dp0bin\quic_1.bin" --new ^
--filter-tcp=443 --hostlist="%~dp0lists\youtube.txt" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=2 --dpi-desync-split-pos=3 --dpi-desync-fake-tls="%~dp0bin\tls_clienthello_2.bin" --dpi-desync-autottl=2 --new ^
--filter-udp=443 --hostlist="%~dp0lists\discord.txt" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic="%~dp0bin\quic_initial_www_google_com.bin" --new ^
--filter-udp=50000-59000 --dpi-desync=fake --dpi-desync-any-protocol --dpi-desync-cutoff=d3 --dpi-desync-repeats=6 --dpi-desync-fake-quic="%~dp0bin\quic_initial_www_google_com.bin" --new ^
--filter-tcp=443 --hostlist="%~dp0lists\other.txt" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=1 --dpi-desync-split-tls=sniext --dpi-desync-fake-tls="%~dp0bin\tls_clienthello_www_google_com.bin" --dpi-desync-ttl=2 --new ^
--filter-tcp=443 --hostlist="%~dp0lists\faceinsta.txt" --dpi-desync=split2 --dpi-desync-split-seqovl=652 --dpi-desync-split-pos=2 --dpi-desync-split-seqovl-pattern="%~dp0bin\tls_clienthello_www_google_com.bin" --new ^
--filter-tcp=443 --hostlist="%~dp0lists\discord.txt" --dpi-desync=fake,split --dpi-desync-autottl=2 --dpi-desync-repeats=6 --dpi-desync-fooling=badseq --dpi-desync-fake-tls="%~dp0bin\tls_clienthello_www_google_com.bin" --new ^
TIMEOUT /T 1 > nul /NOBREAK & echo Стратегия Ростелеком v2 успешно загружена! & goto MENU

:Other1
call :CHECK_AND_STOP & set STRATEGY_STARTED=1
start "ZAPRET: Other v1" /min "%~dp0bin\winws.exe" ^
--wf-l3=ipv4,ipv6 --wf-tcp=443 --wf-udp=443,50000-65535 ^
--filter-udp=443 --hostlist="%~dp0lists\youtube.txt" --dpi-desync=fake --dpi-desync-repeats=11 --dpi-desync-fake-quic="%~dp0bin\quic_initial_www_google_com.bin" --new ^
--filter-tcp=443 --hostlist="%~dp0lists\youtube.txt" --dpi-desync=split --dpi-desync-split-seqovl=1 --dpi-desync-split-tls=sniext --dpi-desync-fake-tls="%~dp0bin\tls_clienthello_www_google_com.bin" --dpi-desync-ttl=1 --new ^
--filter-tcp=443 --hostlist="%~dp0lists\discord.txt" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=1 --dpi-desync-split-tls=sniext --dpi-desync-fake-tls="%~dp0bin\tls_clienthello_www_google_com.bin" --dpi-desync-ttl=4 --new ^
--filter-udp=443 --hostlist="%~dp0lists\discord.txt" --dpi-desync=fake,split2 --dpi-desync-udplen-increment=10 --dpi-desync-repeats=6 --dpi-desync-udplen-pattern=0xDEADBEEF --dpi-desync-fake-quic="%~dp0bin\quic_initial_www_google_com.bin" --new ^
--filter-udp=50000-65535 --dpi-desync=fake,tamper --dpi-desync-any-protocol --dpi-desync-cutoff=d3 --dpi-desync-repeats=6 --dpi-desync-fake-quic="%~dp0bin\quic_initial_www_google_com.bin" --new ^
--filter-tcp=443 --hostlist="%~dp0lists\other.txt" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=1 --dpi-desync-split-tls=sniext --dpi-desync-fake-tls="%~dp0bin\tls_clienthello_2.bin" --dpi-desync-ttl=3 --new ^
--filter-tcp=443 --hostlist="%~dp0lists\faceinsta.txt" --dpi-desync=split2 --dpi-desync-split-seqovl=652 --dpi-desync-split-pos=2 --dpi-desync-split-seqovl-pattern="%~dp0bin\tls_clienthello_www_google_com.bin"
TIMEOUT /T 1 > nul /NOBREAK & echo Стратегия другое v1 успешно загружена! & goto MENU

:Other2
call :CHECK_AND_STOP & set STRATEGY_STARTED=1
start "ZAPRET: Other v2" /min "%~dp0bin\winws.exe" ^
--wf-l3=ipv4,ipv6 --wf-tcp=443 --wf-udp=443,50000-65535 ^
--filter-udp=443 --hostlist="%~dp0lists\youtube.txt" --dpi-desync=fake --dpi-desync-repeats=11 --dpi-desync-fake-quic="%~dp0bin\quic_initial_www_google_com.bin" --new ^
--filter-tcp=443 --hostlist="%~dp0lists\youtube.txt" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=1 --dpi-desync-split-tls=sniext --dpi-desync-fake-tls="%~dp0bin\tls_clienthello_www_google_com.bin" --dpi-desync-ttl=4 --new ^
--filter-udp=443 --hostlist="%~dp0lists\discord.txt" --dpi-desync=fake --dpi-desync-udplen-increment=10 --dpi-desync-repeats=6 --dpi-desync-udplen-pattern=0xDEADBEEF --dpi-desync-fake-quic="%~dp0bin\quic_initial_www_google_com.bin" --new ^
--filter-udp=50000-65535 --dpi-desync=fake,tamper --dpi-desync-any-protocol --dpi-desync-cutoff=n5 --dpi-desync-repeats=10 --dpi-desync-fake-quic="%~dp0bin\quic_initial_www_google_com.bin" --new ^
--filter-tcp=443 --hostlist="%~dp0lists\discord.txt" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=1 --dpi-desync-split-tls=sniext --dpi-desync-fake-tls="%~dp0bin\tls_clienthello_www_google_com.bin" --dpi-desync-ttl=2 --new ^
--filter-tcp=443 --hostlist="%~dp0lists\other.txt" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=1 --dpi-desync-split-tls=sniext --dpi-desync-fake-tls="%~dp0bin\tls_clienthello_2.bin" --dpi-desync-ttl=2 --new ^
--filter-tcp=443 --hostlist="%~dp0lists\faceinsta.txt" --dpi-desync=split2 --dpi-desync-split-seqovl=652 --dpi-desync-split-pos=2 --dpi-desync-split-seqovl-pattern="%~dp0bin\tls_clienthello_www_google_com.bin"
TIMEOUT /T 1 > nul /NOBREAK & echo Стратегия другое v2 успешно загружена! & goto MENU

:MGTS1
call :CHECK_AND_STOP & set STRATEGY_STARTED=1
start "ZAPRET: MGTS v1" /min "%~dp0bin\winws.exe" ^
--wf-tcp=80,443 --wf-udp=443,50000-59000 ^
--filter-udp=443 --hostlist="%~dp0lists\youtube.txt" --dpi-desync=fake --dpi-desync-repeats=4 --dpi-desync-fake-quic="%~dp0bin\quic_initial_www_google_com.bin" --new ^
--filter-tcp=443 --hostlist="%~dp0lists\youtube.txt" --dpi-desync=split --dpi-desync-split-pos=1 --dpi-desync-fooling=badseq --dpi-desync-repeats=10 --dpi-desync-ttl=4 --new ^
--filter-udp=443 --hostlist="%~dp0lists\discord.txt" --dpi-desync=fake --dpi-desync-udplen-increment=10 --dpi-desync-repeats=7 --dpi-desync-udplen-pattern=0xDEADBEEF --dpi-desync-fake-quic="%~dp0bin\quic_initial_www_google_com.bin" --new ^
--filter-udp=50000-59000 --dpi-desync=fake --dpi-desync-any-protocol --dpi-desync-cutoff=n2 --dpi-desync-fake-quic="%~dp0bin\quic_initial_www_google_com.bin" --new ^
--filter-tcp=443 --hostlist="%~dp0lists\other.txt" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=1 --dpi-desync-split-tls=sniext --dpi-desync-fake-tls="%~dp0bin\tls_clienthello_www_google_com.bin" --dpi-desync-ttl=2 --new ^
--filter-tcp=443 --hostlist="%~dp0lists\discord.txt" --dpi-desync=split --dpi-desync-split-pos=1 --dpi-desync-fooling=badseq --dpi-desync-repeats=10 --dpi-desync-autottl
TIMEOUT /T 1 > nul /NOBREAK & echo Стратегия МГТС v1 успешно загружена! & goto MENU

:MGTS2
call :CHECK_AND_STOP & set STRATEGY_STARTED=1
start "ZAPRET: MGTS v2" /min "%~dp0bin\winws.exe" ^
--wf-tcp=80,443 --wf-udp=443,50000-65535 ^
--filter-tcp=443 --hostlist="%~dp0lists\youtube.txt" --dpi-desync=split --dpi-desync-split-pos=1 --dpi-desync-fooling=badseq --dpi-desync-repeats=10 --dpi-desync-cutoff=d2 --dpi-desync-ttl=3 --new ^
--filter-tcp=443 --hostlist="%~dp0lists\discord.txt" --dpi-desync=split --dpi-desync-split-pos=1 --dpi-desync-fooling=badseq --dpi-desync-repeats=10 --dpi-desync-ttl=3 --new ^
--filter-tcp=443 --hostlist="%~dp0lists\faceinsta.txt" --dpi-desync=split2 --dpi-desync-split-seqovl=652 --dpi-desync-split-pos=2 --dpi-desync-split-seqovl-pattern="%~dp0bin\tls_clienthello_2.bin" --new ^
--filter-tcp=443 --hostlist="%~dp0lists\other.txt" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=1 --dpi-desync-split-tls=sniext --dpi-desync-fake-tls="%~dp0bin\tls_clienthello_2.bin" --dpi-desync-ttl=2 --new ^
--filter-udp=443 --hostlist="%~dp0lists\youtube.txt" --dpi-desync=fake --dpi-desync-repeats=2 --dpi-desync-cutoff=n2 --dpi-desync-fake-quic="%~dp0bin\quic_initial_www_google_com.bin" --new ^
--filter-udp=443 --hostlist="%~dp0lists\discord.txt" --dpi-desync=fake --dpi-desync-udplen-increment=10 --dpi-desync-repeats=7 --dpi-desync-udplen-pattern=0xDEADBEEF --dpi-desync-fake-quic="%~dp0bin\quic_test_00.bin" --dpi-desync-cutoff=n2 --new ^
--filter-udp=50000-65535 --dpi-desync=fake,split2 --dpi-desync-any-protocol --dpi-desync-cutoff=d2 --dpi-desync-fake-quic="%~dp0bin\quic_test_00.bin"
TIMEOUT /T 1 > nul /NOBREAK & echo Стратегия МГТС и ЯлтаТВ v2 успешно загружена! & goto MENU

:MGTS3
call :CHECK_AND_STOP & set STRATEGY_STARTED=1
start "ZAPRET: MGTS v3" /min "%~dp0bin\winws.exe" ^
--wf-tcp=80,443 --wf-udp=443,50000-65535 ^
--filter-tcp=443 --hostlist="%~dp0lists\youtube.txt" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=2 --dpi-desync-split-pos=3 --dpi-desync-fake-tls="%~dp0bin\tls_clienthello_www_google_com.bin" --dpi-desync-ttl=3 --new ^
--filter-tcp=443 --hostlist="%~dp0lists\discord.txt" --dpi-desync=split --dpi-desync-split-pos=1 --dpi-desync-fooling=badseq --dpi-desync-repeats=10 --dpi-desync-ttl=3 --new ^
--filter-tcp=443 --hostlist="%~dp0lists\faceinsta.txt" --dpi-desync=split2 --dpi-desync-split-seqovl=652 --dpi-desync-split-pos=2 --dpi-desync-split-seqovl-pattern="%~dp0bin\tls_clienthello_2.bin" --new ^
--filter-tcp=443 --hostlist="%~dp0lists\other.txt" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=1 --dpi-desync-split-tls=sniext --dpi-desync-fake-tls="%~dp0bin\tls_clienthello_2.bin" --dpi-desync-ttl=2 --new ^
--filter-udp=443 --hostlist="%~dp0lists\youtube.txt" --dpi-desync=fake --dpi-desync-repeats=2 --dpi-desync-cutoff=n2--dpi-desync-fake-quic="%~dp0bin\quic_initial_www_google_com.bin" --new ^
--filter-udp=443 --hostlist="%~dp0lists\discord.txt" --dpi-desync=fake --dpi-desync-udplen-increment=10 --dpi-desync-repeats=7 --dpi-desync-udplen-pattern=0xDEADBEEF --dpi-desync-fake-quic="%~dp0bin\quic_test_00.bin" --dpi-desync-cutoff=n2 --new ^
--filter-udp=50000-65535 --dpi-desync=fake,split2 --dpi-desync-any-protocol --dpi-desync-cutoff=d2 --dpi-desync-fake-quic="%~dp0bin\quic_test_00.bin"
TIMEOUT /T 1 > nul /NOBREAK & echo Стратегия МГТС v3 успешно загружена! & goto MENU

:MGTS4
call :CHECK_AND_STOP & set STRATEGY_STARTED=1
start "ZAPRET: MGTS v4" /min "%~dp0bin\winws.exe" ^
--wf-tcp=80,443 --wf-udp=443,50000-59000 ^
--filter-udp=443 --hostlist="%~dp0lists\youtube.txt" --dpi-desync=fake --dpi-desync-repeats=2 --dpi-desync-cutoff=n2 --dpi-desync-fake-quic="%~dp0bin\quic_test_00.bin" --new ^
--filter-tcp=443 --hostlist="%~dp0lists\youtube.txt" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=2 --dpi-desync-split-pos=3 --dpi-desync-fake-tls="%~dp0bin\tls_clienthello_www_google_com.bin" --dpi-desync-ttl=3 --new ^
--filter-udp=443 --hostlist="%~dp0lists\discord.txt" --dpi-desync=fake --dpi-desync-udplen-increment=10 --dpi-desync-repeats=7 --dpi-desync-udplen-pattern=0xDEADBEEF --dpi-desync-fake-quic="%~dp0bin\quic_test_00.bin" --dpi-desync-cutoff=n2 --new ^
--filter-udp=50000-59000 --dpi-desync=fake,split2 --dpi-desync-any-protocol --dpi-desync-cutoff=d2 --dpi-desync-fake-quic="%~dp0bin\quic_test_00.bin" --new ^
--filter-tcp=443 --hostlist="%~dp0lists\discord.txt" --dpi-desync=split --dpi-desync-split-pos=1 --dpi-desync-fooling=badseq --dpi-desync-repeats=10 --dpi-desync-ttl=4 --new ^
--filter-tcp=443 --hostlist="%~dp0lists\other.txt" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=1 --dpi-desync-split-tls=sniext --dpi-desync-fake-tls="%~dp0bin\tls_clienthello_2.bin" --dpi-desync-ttl=2 --new ^
TIMEOUT /T 1 > nul /NOBREAK & echo Стратегия МГТС v4 успешно загружена! & goto MENU

:Ultimate1
call :CHECK_AND_STOP & set STRATEGY_STARTED=1
start "---] zapret (zl variant): http,https,quic,youtube,discord [---" /min "%~dp0bin\winws.exe" ^
--wf-tcp=80,443 --wf-udp=443,50000-50099 ^
--filter-udp=443 --hostlist="%~dp0lists\youtubeQ.txt" --dpi-desync=fake --dpi-desync-fake-quic="%~dp0bin\quic_1.bin" --dpi-desync-repeats=4 --new ^
--filter-tcp=443 --hostlist="%~dp0lists\youtubeGV.txt" --dpi-desync=fakedsplit --dpi-desync-split-pos=1 --dpi-desync-fooling=badseq --dpi-desync-repeats=10 --dpi-desync-ttl=4 --new ^
--filter-tcp=443 --hostlist="%~dp0lists\youtube.txt" --dpi-desync=fake,multisplit --dpi-desync-split-seqovl=2 --dpi-desync-split-pos=3 --dpi-desync-fake-tls="%~dp0bin\tls_clienthello_2.bin" --dpi-desync-ttl=3 --new ^
--filter-tcp=80 --hostlist="%~dp0lists\other.txt" --dpi-desync=fake,multisplit --dpi-desync-fooling=md5sig --new ^
--filter-tcp=443 --hostlist="%~dp0lists\other.txt" --dpi-desync=fake,multisplit --dpi-desync-split-seqovl=1 --dpi-desync-split-pos=1 --dpi-desync-fake-tls="%~dp0bin\tls_clienthello_2.bin" --dpi-desync-ttl=5 --new ^
--filter-tcp=443 --hostlist="%~dp0lists\discord.txt" --dpi-desync=fakedsplit --dpi-desync-split-pos=1 --dpi-desync-fooling=badseq --dpi-desync-repeats=10 --dpi-desync-autottl --new ^
--filter-udp=443 --hostlist="%~dp0lists\discord.txt" --dpi-desync=fake --dpi-desync-udplen-increment=10 --dpi-desync-udplen-pattern=0xDEADBEEF --dpi-desync-fake-quic="%~dp0bin\quic_2.bin" --dpi-desync-repeats=8 --dpi-desync-cutoff=n2 --new ^
--filter-udp=50000-50099 --dpi-desync=fake --dpi-desync-any-protocol --dpi-desync-cutoff=d2 --dpi-desync-fake-quic="%~dp0bin\quic_1.bin"
TIMEOUT /T 1 > nul /NOBREAK & echo Стратегия Ультимейт конфиг ZL успешно загружена! & goto MENU

:Ultimate2
set YTDB_YTPot=--dpi-desync=multisplit --dpi-desync-split-seqovl=1 --dpi-desync-split-pos=midsld+1
set YTDB_WinSZ=--hostlist="%~dp0lists\youtubeGV.txt" --dpi-desync=multisplit --dpi-desync-split-seqovl=1 --dpi-desync-split-pos=midsld-1
set YTDB_DIS1=--ipset="%~dp0lists\ipset-discord.txt" --dpi-desync=syndata --dpi-desync-fake-syndata="%~dp0bin\tls_clienthello_3.bin" --dpi-desync-autottl
set YTDB_DIS2=--hostlist="%~dp0lists\discord.txt" --dpi-desync=fake,udplen --dpi-desync-udplen-increment=5 --dpi-desync-udplen-pattern=0xDEADBEEF --dpi-desync-fake-quic="%~dp0bin\quic_2.bin" --dpi-desync-repeats=7 --dpi-desync-cutoff=n2
set YTDB_DIS3=--dpi-desync=fake --dpi-desync-any-protocol --dpi-desync-cutoff=n3

rem set YTDB_prog_log=--debug=@%~dp0log_debug.txt
rem set YTDB_YTPot=--dpi-desync=fake,multisplit --dpi-desync-fooling=md5sig --dpi-desync-split-seqovl=2 --dpi-desync-split-pos=2 --dpi-desync-fake-tls="%~dp0fake\tls_clienthello_2.bin" --dpi-desync-autottl
rem set YTDB_YTPot=[�� ������ �������� ���� ���� ���������]

rem set YTDB_WinSZ=43 --wssize 1:6 --dpi-desync=fakedsplit --dpi-desync-split-seqovl=1 --dpi-desync-split-pos=midsld-1 --dpi-desync-fooling=md5sig,badseq
rem set YTDB_WinSZ=43 [�� ������ �������� ���� ���� ���������]

rem set YTDB_DIS1=--hostlist="%~dp0lists\russia-discord.txt" --dpi-desync=fake,multisplit --dpi-desync-split-pos=1,midsld --dpi-desync-fooling=md5sig,badseq --dpi-desync-fake-tls="%~dp0fake\tls_clienthello_4.bin" --dpi-desync-autottl
rem set YTDB_DIS1=--hostlist="%~dp0lists\russia-discord.txt" --dpi-desync=fake,fakedsplit --dpi-desync-fooling=badseq --dpi-desync-fake-tls="%~dp0fake\tls_clienthello_2.bin" --dpi-desync-repeats=6
rem YTDB_DIS1=[�� ������ �������� ���� ���� ��������� (������ ��������)]
rem set YTDB_DIS2=--hostlist="%~dp0lists\russia-discord.txt" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic="%~dp0fake\quic_1.bin"
rem set YTDB_DIS3=--dpi-desync=fake --dpi-desync-any-protocol --dpi-desync-cutoff=d3 --dpi-desync-repeats=6
rem set YTDB_DIS3=--dpi-desync=fake --dpi-desync-any-protocol --dpi-desync-fake-unknown-udp=0xC30000000108 --dpi-desync-cutoff=n2
rem set YTDB_DIS3=[�� ������ �������� ���� ���� ��������� (�����)]

start "---] zapret: http,https,quic,youtube,discord [---" /min "%~dp0bin\winws.exe" %YTDB_prog_log% ^
--wf-tcp=80,443 --wf-udp=443,50000-50090 ^
--filter-tcp=443 --ipset="%~dp0lists\russia-youtube-rtmps.txt" --dpi-desync=syndata --dpi-desync-fake-syndata="%~dp0bin\tls_clienthello_4.bin" --dpi-desync-autottl --new ^
--filter-udp=443 --hostlist="%~dp0lists\youtubeQ.txt" --dpi-desync=fake,udplen --dpi-desync-udplen-increment=2 --dpi-desync-fake-quic="%~dp0bin\quic_3.bin" --dpi-desync-cutoff=n3 --dpi-desync-repeats=2 --new ^
--filter-tcp=443 --hostlist="%~dp0lists\youtube.txt" %YTDB_YTPot% --new ^
--filter-tcp=80 --hostlist="%~dp0lists\other.txt" --dpi-desync=fake,multisplit --dpi-desync-fooling=md5sig --dpi-desync-autottl --new ^
--filter-tcp=443 --hostlist="%~dp0lists\other.txt" --dpi-desync=fake,multisplit --dpi-desync-split-seqovl=1 --dpi-desync-split-pos=midsld-1 --dpi-desync-fooling=md5sig,badseq --dpi-desync-fake-tls="%~dp0bin\tls_clienthello_4.bin" --dpi-desync-autottl --new ^
--filter-tcp=443 %YTDB_DIS1% --new ^
--filter-udp=443 %YTDB_DIS2% --new ^
--filter-udp=50000-50090 %YTDB_DIS3% --new ^
--filter-tcp=443 %YTDB_WinSZ%
TIMEOUT /T 1 > nul /NOBREAK & echo Стратегия Ультимейт v2 успешно загружена! & goto MENU

:STRATEGY2
call :CHECK_AND_STOP & set STRATEGY_STARTED=1
start "zapret: http,https,quic,discord (2)" /min "%BIN%winws.exe" ^
--wf-tcp=80,443 --wf-udp=443,50000-59000 ^
--filter-udp=443 --hostlist="%LISTS%youtube.txt" --dpi-desync=fake --dpi-desync-repeats=2 --dpi-desync-cutoff=n2 --dpi-desync-fake-quic="%BIN%quic_test_00.bin" --new ^
--filter-tcp=443 --hostlist="%LISTS%youtube.txt" --dpi-desync=split --dpi-desync-split-pos=1 --dpi-desync-fooling=badseq --dpi-desync-repeats=10 --dpi-desync-cutoff=d2 --dpi-desync-ttl=4 --new ^
--filter-tcp=443 --hostlist="%LISTS%youtube.txt" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=2 --dpi-desync-split-pos=3 --dpi-desync-fake-tls="%BIN%tls_clienthello_www_google_com.bin" --dpi-desync-ttl=3 --new ^
--filter-tcp=80 --hostlist="%LISTS%discord.txt" --dpi-desync=fake,split2 --dpi-desync-autottl=2 --dpi-desync-fooling=md5sig --new ^
--filter-udp=443 --hostlist="%LISTS%discord.txt" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic="%BIN%quic_1.bin" --new ^
--filter-udp=50000-59000 --dpi-desync=fake --dpi-desync-any-protocol --dpi-desync-cutoff=d3 --dpi-desync-repeats=6 --new ^
--filter-tcp=443 --hostlist="%LISTS%discord.txt" --dpi-desync=split2 --dpi-desync-split-seqovl=652 --dpi-desync-split-pos=2 --dpi-desync-split-seqovl-pattern="%BIN%tls_clienthello_2.bin" --new ^
--filter-tcp=443 --hostlist="%LISTS%other.txt" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=1 --dpi-desync-split-tls=sniext --dpi-desync-fake-tls="%BIN%tls_clienthello_2.bin" --dpi-desync-ttl=2 --new ^
TIMEOUT /T 1 > nul /NOBREAK & echo Стратегия v2 успешно загружена! & goto MENU

:STRATEGY3
call :CHECK_AND_STOP & set STRATEGY_STARTED=1
start "STRATEGY3" /min "%BIN%winws.exe" ^
--wf-tcp=80,443 --wf-udp=443,50000-50100 ^
--filter-udp=443 --hostlist="%LISTS%discord.txt" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic="%BIN%quic_initial_www_google_com.bin" --new ^
--filter-udp=50000-50100 --ipset="%LISTS%ipset-discord.txt" --dpi-desync=fake --dpi-desync-any-protocol --dpi-desync-cutoff=d3 --dpi-desync-repeats=6 --new ^
--filter-tcp=80 --hostlist="%LISTS%discord.txt" --dpi-desync=fake,split2 --dpi-desync-autottl=2 --dpi-desync-fooling=md5sig --new ^
--filter-tcp=443 --hostlist="%LISTS%discord.txt" --dpi-desync=fake,split --dpi-desync-repeats=6 --dpi-desync-fooling=badseq --dpi-desync-fake-tls="%BIN%tls_clienthello_www_google_com.bin" -- new ^
--filter-udp=443 --hostlist="%LISTS%youtube.txt" --dpi-desync=fake --dpi-desync-repeats=2 --dpi-desync-cutoff=n2 --dpi-desync-fake-quic="%BIN%quic_test_00.bin" --new ^
--filter-tcp=443 --hostlist="%LISTS%youtube.txt" --dpi-desync=split --dpi-desync-split-pos=1 --dpi-desync-fooling=badseq --dpi-desync-repeats=10 --dpi-desync-cutoff=d2 --dpi-desync-ttl=4 --new ^
--filter-tcp=443 --hostlist="%LISTS%youtube.txt" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=2 --dpi-desync-split-pos=3 ^
--filter-tcp=443 --hostlist="%LISTS%other.txt" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=1 --dpi-desync-split-tls=sniext --dpi-desync-fake-tls="%BIN%tls_clienthello_2.bin" --dpi-desync-ttl=2 --new ^
TIMEOUT /T 1 > nul /NOBREAK & echo Стратегия v3 успешно загружена! & goto MENU



:CHECK_AND_STOP
tasklist /fi "imagename eq winws.exe" | find /i "winws.exe" > NUL 2>&1
if %errorlevel% equ 0 (
  echo Перезапуск Запрета...
  taskkill /f /im winws.exe > NUL 2>&1
) else (
    echo Попытка запуска стратегии...
)

TIMEOUT /T 1 > nul /NOBREAK
sc stop windivert > nul
exit /b



:RESTART_ALL_DISCORD_EXE
tasklist /fi "imagename eq discord.exe" /fo csv /nh | find /v "No tasks" > temp.txt
if exist temp.txt (
    for /f "tokens=2 delims=," %%a in (temp.txt) do (
        echo Killing process with PID: %%a
        taskkill /f /pid %%a > NUL 2>&1
    )
    del temp.txt
) else (
    echo No Discord processes found.
)
TIMEOUT /T 1 > nul /NOBREAK
echo Starting Discord...
start "" "%AppData%\Microsoft\Windows\Start Menu\Programs\Discord Inc\Discord.lnk"
exit /b

:CHANGEDNS
@echo off
setlocal

@echo off
:: Установка переменных DNS
set "primaryDNS=185.222.222.222"
set "secondaryDNS=45.11.45.11"

:: Применение DNS для интерфейсов
echo Изменение DNS для интерфейсов...

netsh interface ip set dns name="Ethernet" source="static" address=%primaryDNS%
netsh interface ip add dns name="Ethernet" addr=%secondaryDNS% index=2

netsh interface ip set dns name="Ethernet 2" source="static" address=%primaryDNS%
netsh interface ip add dns name="Ethernet 2" addr=%secondaryDNS% index=2

netsh interface ip set dns name="Ethernet 3" source="static" address=%primaryDNS%
netsh interface ip add dns name="Ethernet 3" addr=%secondaryDNS% index=2

netsh interface ip set dns name="Wi-Fi" source="static" address=%primaryDNS%
netsh interface ip add dns name="Wi-Fi" addr=%secondaryDNS% index=2

ipconfig /flushdns
echo Все интерфейсы успешно обновлены.
pause


endlocal
exit /b


:EDITHOSTS
set hostsPath=C:\Windows\System32\drivers\etc\hosts

(
echo # Новый файл hosts
echo 0.0.0.0 www.aomeitech.com
echo 185.15.211.203 bt.t-ru.org
echo 185.15.211.203 bt2.t-ru.org
echo 185.15.211.203 bt3.t-ru.org
echo 185.15.211.203 bt4.t-ru.org
echo 3.66.189.153 mail.proton.me
echo 3.73.85.131 mail.proton.me
echo 31.13.72.36 facebook.com
echo 31.13.72.36 www.facebook.com
echo 31.13.72.12 static.xx.fbcdn.net
echo 157.240.229.174 www.instagram.com
echo 157.240.229.174 instagram.com
echo 157.240.247.63 scontent.cdninstagram.com
) > %hostsPath%

echo Файл hosts успешно обновлён.
exit /b

:TELEGRAM
set "reg_key=HKCU\Software\Zapret"
set "reg_value=TelegramOpened"

reg query "%reg_key%" /v "%reg_value%" > nul 2>&1
if %errorlevel% == 0 (
    echo "Присоединяйтесь к нашему каналу Telegram (для обновлений) https://t.me/bypassblock"
) else (
    echo Присоединяйтесь к нашему каналу Telegram
    start https://t.me/bypassblock
    reg add "%reg_key%" /v "%reg_value%" /t REG_DWORD /d 1 /f
)
exit /b
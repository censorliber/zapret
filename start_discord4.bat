@echo off

tasklist /fi "imagename eq winws.exe" | find /i "winws.exe" > NUL 2>&1
if %errorlevel% equ 0 (
    echo The Zapret process is already running. Close the OTHER windows and services and try to run this program again.
    echo The Zapret process is already running. Close the OTHER windows and services and try to run this program again.
    echo The Zapret process is already running. Close the OTHER windows and services and try to run this program again.
    pause
    exit
)

set BIN=%~dp0bin\
set LISTS=%~dp0lists\

start "ZAPRET: Ultimate Fix ALT Beeline-Rostelekom" /min "%BIN%winws.exe" --wf-tcp=80,443 --wf-udp=443,50000-65535 ^
--filter-udp=443 --hostlist="%LISTS%\discord.txt" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic="%BIN%quic_initial_vk_com.bin" --new ^
--filter-udp=50000-65535 --ipset="%LISTS%\ipset-discord.txt" --dpi-desync=fake --dpi-desync-any-protocol --dpi-desync-cutoff=d3 --dpi-desync-repeats=6 --new ^
--filter-tcp=80 --hostlist="%LISTS%\discord.txt" --dpi-desync=fake,split2 --dpi-desync-autottl=2 --dpi-desync-fooling=md5sig --new ^
--filter-tcp=443 --hostlist="%LISTS%\discord.txt" --dpi-desync=fake,split2 --dpi-desync-ttl=1 --dpi-desync-autottl=5 --dpi-desync-repeats=6 --dpi-desync-fake-tls="%BIN%tls_clienthello_www_google_com.bin" -- new ^
--filter-udp=443 --hostlist="%~dp0lists\youtube.txt" --dpi-desync=fake --dpi-desync-repeats=2 --dpi-desync-cutoff=n2 --dpi-desync-fake-quic="%~dp0bin\quic_test_00.bin" --new ^
--filter-tcp=443 --hostlist="%~dp0lists\youtube.txt" --dpi-desync=split --dpi-desync-split-pos=1 --dpi-desync-fooling=badseq --dpi-desync-repeats=10 --dpi-desync-cutoff=d2 --dpi-desync-ttl=4 --new ^
--filter-tcp=443 --hostlist="%~dp0lists\youtube.txt" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=2 --dpi-desync-split-pos=3 
--filter-tcp=443 --hostlist="%~dp0lists\other.txt" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=1 --dpi-desync-split-tls=sniext --dpi-desync-fake-tls="%~dp0bin\tls_clienthello_2.bin" --dpi-desync-ttl=2 --new ^
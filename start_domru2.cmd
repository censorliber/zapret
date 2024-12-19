@echo off

tasklist /fi "imagename eq winws.exe" | find /i "winws.exe" > NUL 2>&1
if %errorlevel% equ 0 (
    echo The Zapret process is already running. Close the OTHER windows and services and try to run this program again.
    echo The Zapret process is already running. Close the OTHER windows and services and try to run this program again.
    echo The Zapret process is already running. Close the OTHER windows and services and try to run this program again.
    pause
    exit
)

start "zapret: http,https,quic,discord" /min "%~dp0bin\winws.exe" ^
--wf-tcp=80,443 --wf-udp=443,50000-59000 ^
--filter-udp=443 --hostlist="%~dp0lists\youtube.txt" --dpi-desync=fake --dpi-desync-repeats=4 --dpi-desync-fake-quic="%~dp0bin\quic_initial_www_google_com.bin" --new ^
--filter-tcp=443 --hostlist="%~dp0lists\youtube.txt" --dpi-desync=split --dpi-desync-split-pos=1 --dpi-desync-fooling=badseq --dpi-desync-repeats=10 --dpi-desync-autottl=2 --new ^
--filter-tcp=443 --hostlist="%~dp0lists\discord.txt" --dpi-desync=syndata --dpi-desync-fake-syndata="%~dp0bin\tls_clienthello_3.bin"  --dpi-desync-ttl=5 --new ^
--filter-tcp=443 --hostlist="%~dp0lists\other.txt" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=1 --dpi-desync-split-tls=sniext --dpi-desync-fake-tls="%~dp0bin\tls_clienthello_www_google_com.bin" --dpi-desync-ttl=2 --new ^
--filter-udp=443 --hostlist="%~dp0lists\discord.txt" --dpi-desync=fake --dpi-desync-udplen-increment=10 --dpi-desync-repeats=7 --dpi-desync-udplen-pattern=0xDEADBEEF --dpi-desync-fake-quic="%~dp0bin\quic_initial_www_google_com.bin" --new ^
--filter-udp=50000-59000 --dpi-desync=fake --dpi-desync-any-protocol --dpi-desync-cutoff=n2 --dpi-desync-fake-quic="%~dp0bin\quic_initial_www_google_com.bin" --new ^
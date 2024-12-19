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
--wf-tcp=80,443 --wf-udp=443,50000-65535 ^
--filter-tcp=443 --hostlist="%~dp0lists\youtube.txt" --dpi-desync=split --dpi-desync-split-pos=1 --dpi-desync-fooling=badseq --dpi-desync-repeats=10 --dpi-desync-cutoff=d2 --dpi-desync-ttl=3 --new ^
--filter-tcp=443 --hostlist="%~dp0lists\discord.txt" --dpi-desync=split --dpi-desync-split-pos=1 --dpi-desync-fooling=badseq --dpi-desync-repeats=10 --dpi-desync-ttl=3 --new ^
--filter-tcp=443 --hostlist="%~dp0lists\faceinsta.txt" --dpi-desync=split2 --dpi-desync-split-seqovl=652 --dpi-desync-split-pos=2 --dpi-desync-split-seqovl-pattern="%~dp0bin\tls_clienthello_2.bin" --new ^
--filter-tcp=443 --hostlist="%~dp0lists\other.txt" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=1 --dpi-desync-split-tls=sniext --dpi-desync-fake-tls="%~dp0bin\tls_clienthello_2.bin" --dpi-desync-ttl=2 --new ^
--filter-udp=443 --hostlist="%~dp0lists\youtube.txt" --dpi-desync=fake --dpi-desync-repeats=2 --dpi-desync-cutoff=n2--dpi-desync-fake-quic="%~dp0bin\quic_initial_www_google_com.bin" --new ^
--filter-udp=443 --hostlist="%~dp0lists\discord.txt" --dpi-desync=fake --dpi-desync-udplen-increment=10 --dpi-desync-repeats=7 --dpi-desync-udplen-pattern=0xDEADBEEF --dpi-desync-fake-quic="%~dp0bin\quic_test_00.bin" --dpi-desync-cutoff=n2 --new ^
--filter-udp=50000-65535 --dpi-desync=fake,split2 --dpi-desync-any-protocol --dpi-desync-cutoff=d2 --dpi-desync-fake-quic="%~dp0bin\quic_test_00.bin"
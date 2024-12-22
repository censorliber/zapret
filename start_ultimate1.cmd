@echo off

tasklist /fi "imagename eq winws.exe" | find /i "winws.exe" > NUL 2>&1
if %errorlevel% equ 0 (
    echo The Zapret process is already running. Close the OTHER windows and services and try to run this program again.
    echo The Zapret process is already running. Close the OTHER windows and services and try to run this program again.
    echo The Zapret process is already running. Close the OTHER windows and services and try to run this program again.
    pause
    exit
)

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
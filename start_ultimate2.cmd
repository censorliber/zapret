@echo off

tasklist /fi "imagename eq winws.exe" | find /i "winws.exe" > NUL 2>&1
if %errorlevel% equ 0 (
    echo The Zapret process is already running. Close the OTHER windows and services and try to run this program again.
    echo The Zapret process is already running. Close the OTHER windows and services and try to run this program again.
    echo The Zapret process is already running. Close the OTHER windows and services and try to run this program again.
    pause
    exit
)
:: !�� �������� ��� ������! ::
set YTDB_YTPot=--dpi-desync=multisplit --dpi-desync-split-seqovl=1 --dpi-desync-split-pos=midsld+1
set YTDB_WinSZ=--hostlist="%~dp0lists\youtubeGV.txt" --dpi-desync=multisplit --dpi-desync-split-seqovl=1 --dpi-desync-split-pos=midsld-1
set YTDB_DIS1=--ipset="%~dp0lists\ipset-discord.txt" --dpi-desync=syndata --dpi-desync-fake-syndata="%~dp0bin\tls_clienthello_3.bin" --dpi-desync-autottl
set YTDB_DIS2=--hostlist="%~dp0lists\discord.txt" --dpi-desync=fake,udplen --dpi-desync-udplen-increment=5 --dpi-desync-udplen-pattern=0xDEADBEEF --dpi-desync-fake-quic="%~dp0bin\quic_2.bin" --dpi-desync-repeats=7 --dpi-desync-cutoff=n2
set YTDB_DIS3=--dpi-desync=fake --dpi-desync-any-protocol --dpi-desync-cutoff=n3
:: ^^ !�� �������� ��� ������! ^^ ::

:: ����� ����� �������� �����-��� ����� rem � ���������, ������� rem ::
rem set YTDB_prog_log=--debug=@%~dp0log_debug.txt

:: ����� ����� �������� ������ ��������� ��� ���������� ����� ����� rem � ���������, ������� rem ::
rem set YTDB_YTPot=--dpi-desync=fake,multisplit --dpi-desync-fooling=md5sig --dpi-desync-split-seqovl=2 --dpi-desync-split-pos=2 --dpi-desync-fake-tls="%~dp0fake\tls_clienthello_2.bin" --dpi-desync-autottl
rem set YTDB_YTPot=[�� ������ �������� ���� ���� ���������]

:: ����� ����� �������� wssize ��� ����� ����� [googlevideo.com] ����� rem � ���������, ������� rem ::
rem set YTDB_WinSZ=43 --wssize 1:6 --dpi-desync=fakedsplit --dpi-desync-split-seqovl=1 --dpi-desync-split-pos=midsld-1 --dpi-desync-fooling=md5sig,badseq
rem set YTDB_WinSZ=43 [�� ������ �������� ���� ���� ���������]

:: ����� ����� �������� ������ ��������� ��� �������� ����� rem � ���������, ������� rem ::
rem set YTDB_DIS1=--hostlist="%~dp0lists\russia-discord.txt" --dpi-desync=fake,multisplit --dpi-desync-split-pos=1,midsld --dpi-desync-fooling=md5sig,badseq --dpi-desync-fake-tls="%~dp0fake\tls_clienthello_4.bin" --dpi-desync-autottl
rem set YTDB_DIS1=--hostlist="%~dp0lists\russia-discord.txt" --dpi-desync=fake,fakedsplit --dpi-desync-fooling=badseq --dpi-desync-fake-tls="%~dp0fake\tls_clienthello_2.bin" --dpi-desync-repeats=6
rem YTDB_DIS1=[�� ������ �������� ���� ���� ��������� (������ ��������)]
rem set YTDB_DIS2=--hostlist="%~dp0lists\russia-discord.txt" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic="%~dp0fake\quic_1.bin"
rem set YTDB_DIS3=--dpi-desync=fake --dpi-desync-any-protocol --dpi-desync-cutoff=d3 --dpi-desync-repeats=6
rem set YTDB_DIS3=--dpi-desync=fake --dpi-desync-any-protocol --dpi-desync-fake-unknown-udp=0xC30000000108 --dpi-desync-cutoff=n2
rem set YTDB_DIS3=[�� ������ �������� ���� ���� ��������� (�����)]
:: ����� ����� ��������� ��������� ::

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
set ARGS=--wf-tcp=80,443 --wf-udp=443,50000-50020 --filter-udp=443 --hostlist=\"%~dp0russia-youtubeQ.txt\" --dpi-desync=fake --dpi-desync-repeats=2 --dpi-desync-cutoff=n2 --dpi-desync-fake-quic=\"%~dp0quic_test_00.bin\" --new --filter-tcp=443 --hostlist=\"%~dp0russia-youtubeGV.txt\" --dpi-desync=split --dpi-desync-split-pos=1 --dpi-desync-fooling=badseq --dpi-desync-repeats=10 --dpi-desync-cutoff=d2 --dpi-desync-ttl=4 --new --filter-tcp=443 --hostlist=\"%~dp0russia-youtube.txt\" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=2 --dpi-desync-split-pos=3 --dpi-desync-fake-tls=\"%~dp0tls_clienthello_www_google_com.bin\" --dpi-desync-ttl=3 --new --filter-tcp=80 --hostlist=\"%~dp0russia-blacklist.txt\" --dpi-desync=fake,split2 --dpi-desync-fooling=md5sig --dpi-desync-ttl=7 --new --filter-tcp=443 --hostlist=\"%~dp0russia-blacklist.txt\" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=1 --dpi-desync-split-tls=sniext --dpi-desync-fake-tls=\"%~dp0tls_clienthello_www_google_com.bin\" --dpi-desync-ttl=4 --new --filter-udp=443 --hostlist=\"%~dp0russia-discord.txt\" --dpi-desync=fake --dpi-desync-udplen-increment=10 --dpi-desync-repeats=7 --dpi-desync-udplen-pattern=0xDEADBEEF --dpi-desync-fake-quic=\"%~dp0quic_test_00.bin\" --dpi-desync-cutoff=n2 --new --filter-udp=50000-50020 --dpi-desync=fake,split2 --dpi-desync-any-protocol --dpi-desync-cutoff=d2 --dpi-desync-fake-quic=\"%~dp0quic_test_00.bin\" --new --filter-tcp=443 --hostlist=\"%~dp0russia-discord.txt\" --dpi-desync=split --dpi-desync-split-pos=1 --dpi-desync-fooling=badseq --dpi-desync-repeats=10 --dpi-desync-ttl=4 --new --filter-tcp=443 --hostlist-auto=\"%~dp0autohostlist.txt\" --hostlist-exclude=\"%~dp0netrogat.txt\" --dpi-desync=split --dpi-desync-split-pos=1 --dpi-desync-fooling=badseq --dpi-desync-repeats=10 --dpi-desync-ttl=4

call :srvinst zapret
rem set ARGS=--wf-l3=ipv4,ipv6 --wf-udp=443 --dpi-desync=fake 
rem call :srvinst zapret2
goto :eof

:srvinst
net stop %1
sc delete %1
sc create %1 binPath= "\"%~dp0winws.exe\" %ARGS%" DisplayName= "Zapret DPI bypass : %1" start= auto
sc description %1 "Zapret DPI bypass software"
sc start %1

start "zapret: http,https,quic" /min "%~dp0winws.exe" ^
--wf-l3=ipv4,ipv6 --wf-tcp=443 --wf-udp=443,50000-65535 ^
--filter-udp=443 --hostlist="%~dp0list-youtube.txt" --dpi-desync=fake --dpi-desync-repeats=11 --dpi-desync-fake-quic="%~dp0quic_initial_www_google_com.bin" --new ^
--filter-tcp=443 --hostlist="%~dp0list-youtube.txt" --dpi-desync=split --dpi-desync-split-seqovl=1 --dpi-desync-split-tls=sniext --dpi-desync-fake-tls="%~dp0tls_clienthello_www_google_com.bin" --dpi-desync-ttl=1 --new ^
--filter-tcp=443 --hostlist="%~dp0list-discord.txt" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=1 --dpi-desync-split-tls=sniext --dpi-desync-fake-tls="%~dp0tls_clienthello_www_google_com.bin" --dpi-desync-ttl=4 --new ^
--filter-udp=443 --hostlist="%~dp0list-discord.txt" --dpi-desync=fake,split2 --dpi-desync-udplen-increment=10 --dpi-desync-repeats=6 --dpi-desync-udplen-pattern=0xDEADBEEF --dpi-desync-fake-quic="%~dp0quic_initial_www_google_com.bin" --new ^
--filter-udp=50000-65535 --dpi-desync=fake,tamper --dpi-desync-any-protocol --dpi-desync-fake-quic="%~dp0quic_initial_www_google_com.bin" --new ^
--filter-tcp=443 --hostlist="%~dp0other.txt" --dpi-desync=fake,split2 --dpi-desync-split-seqovl=1 --dpi-desync-split-tls=sniext --dpi-desync-fake-tls="%~dp0tls_clienthello_www_google_com.bin" --dpi-desync-ttl=3 --new ^
--filter-tcp=443 --hostlist="%~dp0faceinsta.txt" --dpi-desync=fake,split2 --dpi-desync-ttl=5 --dpi-desync-repeats=6 --dpi-desync-split-pos=1 --dpi-desync-fooling=md5sig,badseq --dpi-desync-split-tls=sniext --dpi-desync-fake-tls="%~dp0tls_clienthello_www_google_com.bin"

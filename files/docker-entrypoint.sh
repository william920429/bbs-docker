#!/bin/bash

if [ ! -d "/home/bbs/pttbbs" ]; then
	sh /files/install_bbs.sh
fi

if [ ! -d "/usr/local/openresty/nginx/html/PttChrome/dist" ]; then
	sh /files/install_PttChrome.sh
fi

su bbsadm -c "/home/bbs/bin/shmctl init"
su bbsadm -c "/home/bbs/bin/logind"
/usr/local/openresty/bin/openresty
/usr/sbin/cron
# /usr/sbin/sshd
while true; do sleep 10; done


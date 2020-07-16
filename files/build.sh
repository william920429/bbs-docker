#!/bin/bash

if [ "$EUID" == "0" ]; then
	su -c $0 bbsadm
	
elif [ "$EUID" == "99" ]; then

	cd /home/bbs/pttbbs &&	bmake all install

	cd /home/bbs/pttbbs/daemon/logind && bmake all install

	bmake clean
	cd /home/bbs/pttbbs
	bmake clean

else

	echo "wrong user!"
	exit 1

fi

#!/bin/bash

if [ "$EUID" == "0" ]; then
	su bbsadm -c $0

elif [ "$EUID" == "99" ]; then

	cd /home/bbs
	git clone https://github.com/ptt/pttbbs.git

	cd /home/bbs/pttbbs
	#cp sample/pttbbs.conf pttbbs.conf

	cd /home/bbs/pttbbs/daemon/wsproxy && mkdir lib && cd lib
	git clone https://github.com/toxicfrog/vstruct/

	cp /files/pttbbs.conf /home/bbs/pttbbs/pttbbs.conf

	/files/build.sh

	test -d /home/bbs/etc || mkdir -p /home/bbs/etc
	cp /files/bindports.conf /home/bbs/etc/bindports.conf

	cd /home/bbs/pttbbs/sample && bmake install #new init
	cd /home/bbs; bin/initbbs -DoIt

else

	echo "wrong user!"
	exit 1

fi

exit 0


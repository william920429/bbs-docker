#!/bin/bash

testfile=/dev/shm/update.sh.tmp

if [ "$EUID" == "0" ]; then
	su bbsadm -c $0

	cd /usr/local/openresty/nginx/html/PttChrome/
	git pull | tee ${testfile}
	git rebase
	if [ "$(grep " changed, " ${testfile})" != "" ]; then #source updated
		cd /usr/local/openresty/nginx/html/PttChrome
		yarn upgrade
		yarn && npm update --depth 5 @babel/preset-env
		yarn && yarn build
		/usr/local/openresty/bin/openresty -s reload
		
	elif [ "$(grep "Already up to date." ${testfile})" == "" ]; then #something wrong
		echo "something wrong while updating pttchrome"
	fi
	rm -rf ${testfile}

elif [ "$EUID" == "99" ]; then

	cd /home/bbs/pttbbs

	git pull | tee ${testfile}
	git rebase
	if [ "$(grep " changed, " ${testfile})" != "" ]; then #source updated
		/files/build.sh
		pkill -ef logind
		pkill -ef shmctl
		/home/bbs/bin/shmctl init
		/home/bbs/bin/logind
	elif [ "$(grep "Already up to date." ${testfile})" == "" ]; then #something wrong
		echo "something wrong while updating pttbbs"
	fi
	rm -rf ${testfile}

	cd /home/bbs/pttbbs/daemon/wsproxy/lib/vstruct
	git pull
	git rebase

else

	echo "wrong user!"
	exit 1

fi

exit 0

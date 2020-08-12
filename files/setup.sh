#!/bin/bash

# create user
groupadd --gid 99 bbs
useradd -u 99 -g 99 --home-dir /home/bbs --shell /home/bbs/bin/bbsrf             bbs
useradd -u 99 -g 99 --home-dir /home/bbs --shell /home/bbs/bin/utf8 --non-unique bbsu
useradd -u 99 -g 99 --home-dir /home/bbs --shell /bin/bash          --non-unique bbsadm

test -d /home/bbs || mkdir -p /home/bbs
chown -R bbs:bbs /home/bbs && chmod 700 /home/bbs

#install required packages
apt update && apt upgrade -y --no-install-recommends
apt install -y --no-install-recommends \
        git python bmake gcc g++ make clang ccache libevent-dev pkg-config \
        libc6-dev curl ca-certificates gnupg cron lsb-release \
        nano

#install cron
cp /files/crontab /etc/crontab
su bbsadm -c "crontab /files/bbs-cron"

#install yarn nodejs
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
curl -sL https://deb.nodesource.com/setup_14.x | bash -
apt -y install --no-install-recommends yarn nodejs

#setup openresty
cp /files/nginx.conf /usr/local/openresty/nginx/conf/nginx.conf
ln -s /usr/local/openresty/bin/openresty /usr/bin/openresty

apt autoremove -y
apt autoclean -y

exit 0

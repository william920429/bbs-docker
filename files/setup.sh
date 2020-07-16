#!/bin/bash

# create user
groupadd --gid 99 bbs
useradd -u 99 -g 99 --home-dir /home/bbs --shell /home/bbs/bin/bbsrf             bbs
useradd -u 99 -g 99 --home-dir /home/bbs --shell /home/bbs/bin/utf8 --non-unique bbsu
useradd -u 99 -g 99 --home-dir /home/bbs --shell /bin/bash          --non-unique bbsadm

test -d /home/bbs || mkdir -p /home/bbs
chown -R bbs:bbs /home/bbs && chmod 700 /home/bbs

test -d /usr/local/src/bbs || mkdir -p /usr/local/src/bbs
chown -R bbs:bbs /usr/local/src/bbs && chmod 700 /usr/local/src/bbs

test -d /usr/local/src/PttChrome || mkdir -p /usr/local/src/PttChrome

#install required packages
apt update
apt upgrade -y --no-install-recommends
apt install -y --no-install-recommends git python bmake gcc g++ make clang ccache libevent-dev pkg-config \
                                       curl ca-certificates gnupg cron

#install cron
cp /files/crontab /etc/crontab

#install yarn nodejs
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
curl -sL https://deb.nodesource.com/setup_14.x | bash -
apt -y install --no-install-recommends yarn nodejs

cp /files/nginx.conf /usr/local/openresty/nginx/conf/nginx.conf

# /files/install_PttChrome.sh 

apt autoremove -y
apt autoclean -y

#install Pttbbs
# /files/install_bbs.sh

exit 0

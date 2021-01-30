#!/bin/bash

cd /usr/local/openresty/nginx/html/
git clone https://github.com/robertabcd/PttChrome.git /usr/local/openresty/nginx/html/PttChrome
cp /files/webpack.config.js /usr/local/openresty/nginx/html/PttChrome/webpack.config.js

cd /usr/local/openresty/nginx/html/PttChrome
yarn
yarn upgrade @babel/preset-env
yarn build

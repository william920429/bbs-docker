FROM openresty/openresty:bionic-nosse42
# FROM ubuntu:latest

COPY ./files/* /files/

RUN export PTTCHROME_PAGE_TITLE="附中電算bbs" \
	&& export DEFAULT_SITE="wsstelnet://bbs.crc.hs.ntnu.edu.tw/bbs" \
	&& chmod +x /files/*.sh \
	&& /files/setup.sh

CMD /files/docker-entrypoint.sh

#telnet
EXPOSE 3000
#http
EXPOSE 3001

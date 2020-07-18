FROM openresty/openresty:bionic-nosse42
# FROM ubuntu:latest

COPY ./files/* /files/

RUN chmod +x /files/*.sh

RUN /files/setup.sh

CMD /files/docker-entrypoint.sh

#telnet
EXPOSE 3000
#http
EXPOSE 3001

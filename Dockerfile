FROM openresty/openresty:bionic-nosse42
# FROM ubuntu:latest

COPY ./files/* /files/

RUN chmod +x /files/*.sh

RUN /files/setup.sh

CMD /files/docker-entrypoint.sh

EXPOSE 3000 #telnet
EXPOSE 3001 #http

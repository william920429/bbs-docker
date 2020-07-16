FROM openresty/openresty:bionic-nosse42
# FROM ubuntu:latest

COPY ./files/* /files/

RUN sh /files/setup.sh

CMD ["sh", "/files/docker-entrypoint.sh"]

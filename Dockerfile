FROM openresty/openresty:bionic-nosse42
# FROM ubuntu:latest

COPY ./files/* /files/

RUN /files/setup.sh

CMD ["/files/docker-entrypoint.sh"]

FROM openresty/openresty:bionic-nosse42
# FROM ubuntu:latest

COPY ./files/* /files/

RUN chmod +x /files/*.sh

RUN /files/setup.sh

CMD ["sh", "/files/docker-entrypoint.sh"]

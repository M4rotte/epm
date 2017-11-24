FROM alpine:3.6

RUN apk update && apk add tini bind-tools openssh

COPY etc /etc
COPY bin /bin
COPY sbin /sbin
COPY lib /lib

WORKDIR /
USER root
ENTRYPOINT ["/sbin/tini","-vv","-g","--","/sbin/epm","/etc/epm/epm.conf"]



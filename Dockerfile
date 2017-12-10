FROM alpine:3.6

RUN apk update && apk add tini bind-tools openssh

COPY etc /etc
COPY bin /bin
COPY sbin /sbin
COPY lib /lib

RUN sed -i -e 's/=\.\//=\//' /etc/epm/epm.conf &&\
    sed -i -e "s/{build_date}/$(date)/" \
           -e "s/{build_host}/$(uname -rs)/" /etc/motd

WORKDIR /
USER root
ENTRYPOINT ["/sbin/tini","-vv","-g","--","/sbin/epm","/etc/epm/epm.conf"]


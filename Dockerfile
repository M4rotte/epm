FROM alpine:3.6

RUN apk update && apk add tini bind-tools openssh nginx

COPY etc /etc
COPY bin /bin
COPY sbin /sbin
COPY lib /lib

RUN sed -i -e 's/=\.\//=\//' \
            /etc/epm/epm.conf &&\
    sed -i -e "s/{build_date}/$(date)/" \
           -e "s/{build_host}/$(uname -rs)/" \
           /etc/motd &&\
    sed -i -e 's/listen 80 default_server;/listen 8080 default_server;/' \
           -e 's/listen \[::\]:80 default_server;/listen [::]:8080 default_server;/' \
           /etc/nginx/conf.d/default.conf

WORKDIR /
USER root
ENTRYPOINT ["/sbin/tini","-vv","-g","--","/sbin/epm","/etc/epm/epm.conf"]


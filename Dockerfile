FROM alpine:3.6

LABEL com.oxyure.vendor="United Microbiotas" \
      maintainer="stef@oxyure.com" \
      description="FooBarBaz"

RUN apk update && apk add --no-cache tini git nano openssh bind-tools openssl

RUN  adduser -h /var/epm -s /sbin/nologin -S -D -H epm &&\
     mkdir /var/epm /etc/epm /lib/epm
COPY sbin/epm /sbin/epm
COPY lib/epm/epm /lib/epm/epm
COPY etc/epm/epm.cfg /etc/epm/epm.cfg
COPY bin/sleep.sh /bin/sleep.sh
COPY etc/epm/services /etc/epm/services
RUN chown -R epm:root /lib/epm /var/epm /etc/epm

EXPOSE 22/tcp

USER root
WORKDIR /var/epm
ENTRYPOINT ["/sbin/tini","-v","--","/sbin/epm"]

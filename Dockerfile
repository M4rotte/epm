FROM alpine:3.6

LABEL com.oxyure.vendor="United Microbiotas" \
      maintainer="stef@oxyure.com" \
      description="FooBarBaz"

RUN apk update && apk add --no-cache tini git nano openssh bind-tools openssl

ARG ROOT_PASSWD

RUN sed -i -e 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' \
           -e 's/#PasswordAuthentication yes/PasswordAuthentication yes/' \
              /etc/ssh/sshd_config &&\
    echo root:${ROOT_PASSWD} | chpasswd

RUN mkdir /var/epm /etc/epm
COPY epm /sbin/epm
COPY epm.cfg /etc/epm/epm.cfg
COPY sleep.sh /bin/sleep.sh
COPY services /etc/epm/services

EXPOSE 22/tcp

USER root
WORKDIR /root
ENTRYPOINT ["/sbin/tini","-v","--","/sbin/epm"]

FROM alpine:latest
MAINTAINER GGMethos <ggmethos@autistici.org>

USER root

RUN echo "IRCD Installation Starting"

RUN apk upgrade --update-cache --available

RUN apk update && apk upgrade

RUN apk add cmake openssl clang gcc g++ make libffi-dev openssl-dev ninja

RUN addgroup unreal && \
adduser -h /home/unreal -s /sbin/nologin -D -G unreal unreal && \
chown -R unreal /home/unreal && \
mkdir -p /data && \
chown -R unreal /data

VOLUME ["/tarball"]

COPY /tarball/unrealircd-5.0.1.tar.gz /home/unreal/

RUN cd /home/unreal/ && mkdir unrealircd

RUN cp /home/unreal/unrealircd-5.0.1.tar.gz /home/unreal/unrealircd/unrealircd-5.0.1.tar.gz

RUN cd /home/unreal/unrealircd/ && tar xfvz unrealircd-5.0.1.tar.gz

RUN cd /home/unreal/unrealircd/ && ls -la

RUN cd /home/unreal/unrealircd/unrealircd-5.0.1/ && ls -la

RUN chmod +x /home/unreal/unrealircd/unrealircd-5.0.1/Config

#########################################################################

#CUSTOM CONFIGURATION

VOLUME ["/secrets"]

COPY /secrets/unrealircd.conf /home/unreal/

COPY /secrets/config.settings /home/unreal/unrealircd/unrealircd-5.0.1/

########################################################################

RUN cd /home/unreal/unrealircd/unrealircd-5.0.1/ && ./Config -quick && yes US | make pem && make && make install

# openssl ecparam -out server.key.pem -name secp384r1 -genkey && openssl req -new -config extras/tls.cnf -sha256 -subj "/C=US/ST=GFY/L=GFY/O=FU/CN=www.duskcoin.com" -out server.req.pem -key server.key.pem -nodes && openssl req -x509 -days 3650 -sha256 -in server.req.pem -subj "/C=US/ST=GFY/L=GFY/O=FU/CN=www.duskcoin.com" -key server.key.pem -out server.cert.pem && 

RUN chown -R unreal /home/unreal

USER unreal

#RUN cd /home/unreal/unrealircd/unrealircd/bin && ./unrealircd start

#get config from data volume and put it where appropriate, then start daemon

RUN cd /home/unreal && ls -la

RUN cp /home/unreal/unrealircd.conf /home/unreal/unrealircd/conf/

EXPOSE 6667

EXPOSE 6697

#CMD ["./home/unreal/unrealirc/bin/unrealircd", "start", "-F"]

CMD ["./home/unreal/unrealircd/bin/unrealircd", "-F", "start"]

#CMD ["./home/unreal/unrealirc/bin/unrealircd", "start"]

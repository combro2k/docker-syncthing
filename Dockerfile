FROM ubuntu-debootstrap:14.04
MAINTAINER Martijn van Maurik <docker@vmaurik.nl>

ENV VERSION 0.10.21
ENV DEBIAN_FRONTEND noninteractive

RUN useradd syncthing -b /config

RUN apt-get update
RUN apt-get dist-upgrade -yq
RUN apt-get install tar curl ca-certificates sudo -yq

RUN mkdir -p /opt/syncthing
RUN cd /opt/syncthing && \
    curl -k -L https://github.com/syncthing/syncthing/releases/download/v${VERSION}/syncthing-linux-amd64-v${VERSION}.tar.gz | \
    tar zxv --strip-components=1

RUN mkdir -p /config /data && chown -R syncthing:syncthing /data /config

VOLUME ["/data", "/config"]

WORKDIR /opt/syncthing

EXPOSE 8080 22000/tcp 22000/udp

ADD start.sh /opt/syncthing/start.sh

RUN chmod +x /opt/syncthing/start.sh

RUN chown -R syncthing:syncthing /opt/syncthing

CMD ["/opt/syncthing/start.sh"]

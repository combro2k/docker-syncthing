FROM ubuntu:14.04
MAINTAINER Martijn van Maurik <docker@vmaurik.nl>

ENV VERSION 0.10.20
ENV DEBIAN_FRONTEND noninteractive

RUN useradd syncthing -b /home/syncthing

RUN apt-get update
RUN apt-get dist-upgrade -yq
RUN apt-get install tar curl ca-certificates -yq

RUN mkdir -p /opt/syncthing
RUN cd /opt/syncthing && \
    curl -k -L https://github.com/syncthing/syncthing/releases/download/v0.10.20/syncthing-linux-amd64-v${VERSION}.tar.gz | \
    tar zxv --strip-components=1

RUN mkdir -p /data/{config,data}

RUN sudo -H -u syncthing -generate=/data/config

VOLUME ["/data"]

WORKDIR /opt/syncthing

EXPOSE 8080

ADD start.sh /opt/syncthing/start.sh

RUN chmod +x /opt/syncthing/start.sh

RUN chown -R syncthing:syncthing /opt/syncthing

CMD ["/bin/bash"]

#!/bin/bash
set -e

if [ ! -z "$IPV6ADDR" ]; then
	echo  $IPV6ADDR
	ip -6 addr add "$IPV6ADDR" dev eth0
fi

sleep 2

if [ ! -z "$IPV6GW" ]; then
	echo $IPV6GW
	ip -6 route add  default via "$IPV6GW" dev eth0
fi

chown syncthing:syncthing /data /config -R

if [[ ! -f "/config/config.xml" ]]
then
    sudo -H -u syncthing /opt/syncthing/syncthing -generate=/config
    sed -i 's#/config/syncthing/Sync#/data#g' /config/config.xml
fi

sudo -H -u syncthing /opt/syncthing/syncthing -gui-address=0.0.0.0:8080 -home /config

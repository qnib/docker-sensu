#!/bin/bash

sleep 2

if [ "X${SENSU_CLIENT}" != "Xtrue" ];then
    echo "$SENSU_CLIENT!=true -> Do not start client"
    rm -f /etc/consul.d/sensu-client.json
    consul reload
    exit 0
fi
source /opt/qnib/consul/etc/bash_functions.sh

echo -n "Wait for redis... "
wait_for_srv redis
echo -n "Wait for rabbitmq... "
wait_for_srv rabbitmq
echo -n "Wait for sensu-server... "
wait_for_srv sensu-server

/opt/sensu/embedded/bin/ruby /opt/sensu/bin/sensu-client \
                              -c /etc/sensu/config.json \
                              -d /etc/sensu/conf.d \
                              -e /etc/sensu/extensions \
                              -p /var/run/sensu/sensu-client.pid \
                              -l /var/log/sensu/sensu-client.log \
                              -L info

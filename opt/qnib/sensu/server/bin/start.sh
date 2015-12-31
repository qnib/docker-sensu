#!/bin/bash

if [ "X${SENSU_SERVER}" != "Xtrue" ];then
    echo "$SENSU_SERVER!=true -> Do not start server"
    rm -f /etc/consul.d/sensu-server.json
    consul reload
    exit 0
fi
source /opt/qnib/consul/etc/bash_functions.sh

wait_for_srv redis
wait_for_srv rabbitmq

/opt/sensu/embedded/bin/ruby /opt/sensu/bin/sensu-server \
                              -c /etc/sensu/config.json \
                              -d /etc/sensu/conf.d \
                              -e /etc/sensu/extensions \
                              -p /var/run/sensu/sensu-server.pid \
                              -l /var/log/sensu/sensu-server.log \
                              -L info

#!/bin/bash

sleep 2

if [ "X${SENSU_CLIENT}" != "Xtrue" ];then
    echo "$SENSU_CLIENT!=true -> Do not start client"
    rm -f /etc/consul.d/sensu-client.json
    consul reload
    exit 0
fi
source /opt/qnib/consul/etc/bash_functions.sh

echo -n "Wait for rabbitmq... "
wait_for_srv rabbitmq

export IP_ADDR=$(ip -o -4 add|grep eth0|egrep -o "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+")
export HOSTNAME=$(hostname)
consul-template -once -consul localhost:8500 -template "/etc/consul-terminal/sensu/client.json.ctmpl:/etc/sensu/conf.d/client.json"

/opt/sensu/embedded/bin/ruby /opt/sensu/bin/sensu-client \
                              -c /etc/sensu/config.json \
                              -d /etc/sensu/conf.d \
                              -e /etc/sensu/extensions \
                              -p /var/run/sensu/sensu-client.pid \
                              -l /var/log/supervisor/sensu-client.log \
                              -L info

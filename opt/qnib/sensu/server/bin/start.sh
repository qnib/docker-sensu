#!/bin/bash

if [ "X${SENSU_SERVER}" != "Xtrue" ];then
    echo "$SENSU_SERVER!=true -> Do not start server"
    rm -f /etc/consul.d/sensu-server.json
    consul reload
    sleep 2
    exit 0
fi
source /opt/qnib/consul/etc/bash_functions.sh

wait_for_srv redis
wait_for_srv rabbitmq

consul-template -once -consul localhost:8500 -template "/etc/consul-templates/sensu/settings.json.ctmpl:/etc/sensu/settings.json"

/opt/sensu/embedded/bin/ruby /opt/sensu/bin/sensu-server \
                              -c /etc/sensu/settings.json \
                              -d /etc/sensu/conf.d \
                              -e /etc/sensu/extensions \
                              -p /var/run/sensu/sensu-server.pid \
                              -l /var/log/supervisor/sensu-server.log \ 
                              -L info

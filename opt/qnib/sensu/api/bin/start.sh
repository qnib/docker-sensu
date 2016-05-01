#!/bin/bash


if [ "X${SENSU_API}" != "Xtrue" ];then
    echo "$SENSU_API!=true -> Do not start sensu-api"
    rm -f /etc/consul.d/sensu-api.json
    consul reload
    sleep 2
    exit 0
fi

source /opt/qnib/consul/etc/bash_functions.sh

echo -n "Wait for redis... "
wait_for_srv redis

consul-template -once -consul localhost:8500 -template "/etc/consul-templates/sensu/settings.json.ctmpl:/etc/sensu/settings.json"

/opt/sensu/embedded/bin/ruby /opt/sensu/bin/sensu-api \
                                -c /etc/sensu/settings.json \
                                -d /etc/sensu/conf.d \
                                -e /etc/sensu/extensions \
                                -p /var/run/sensu/sensu-api.pid \
                                -l /var/log/supervisor/sensu-api.log \
                                -L info

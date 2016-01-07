#!/bin/bash

sleep 2

if [ "X${SENSU_CLIENT}" == "Xfalse" ];then
    echo "$SENSU_CLIENT==false -> Do not start client"
    rm -f /etc/consul.d/sensu-client.json
    consul reload
    exit 0
fi
source /opt/qnib/consul/etc/bash_functions.sh

if [ "X${SENSU_FORCE_CLIENT}" != "Xtrue" ];then
    echo -n "Wait for sensu-server... "
    wait_for_srv sensu-server 120
    echo -n "Wait for rabbitmq... "
    wait_for_srv rabbitmq 120
fi

for item in $(find /etc/sensu/init.d/*.sh);do
    sh ${item}
done

export IP_ADDR=$(ip -o -4 add|grep eth0|egrep -o "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+")
export HOSTNAME=$(hostname)
consul-template -once -consul localhost:8500 -template "/etc/consul-templates/sensu/client.json.ctmpl:/etc/sensu/conf.d/client.json"
consul-template -once -consul localhost:8500 -template "/etc/consul-templates/sensu/settings.json.ctmpl:/etc/sensu/settings.json"

/opt/sensu/embedded/bin/ruby /opt/sensu/bin/sensu-client \
                              -c /etc/sensu/settings.json \
                              -d /etc/sensu/conf.d \
                              -e /etc/sensu/extensions \
                              -p /var/run/sensu/sensu-client.pid \
                              -l /var/log/supervisor/sensu-client.log \
                              -L info

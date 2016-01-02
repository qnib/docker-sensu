### Add Sensu to the mix
FROM qnib/consul

ADD etc/yum.repos.d/sensu.repo /etc/yum.repos.d/
RUN yum install -y sensu nmap && \
    mkdir -p /var/run/sensu && \
    chown sensu: /var/run/sensu
ENV SENSU_CLIENT=true \
    SENSU_API=false \
    SENSU_SERVER=false \
    SENSU_FORCE_CLIENT=false
ADD etc/sensu/config.json /etc/sensu/
ADD etc/supervisord.d/*.ini /etc/supervisord.d/
ADD etc/consul.d/*.json /etc/consul.d/
ADD /opt/qnib/sensu/server/bin/start.sh /opt/qnib/sensu/server/bin/
ADD /opt/qnib/sensu/api/bin/start.sh /opt/qnib/sensu/api/bin/
ADD /opt/qnib/sensu/client/bin/start.sh /opt/qnib/sensu/client/bin/
ADD etc/consul-terminal/sensu/client.json.ctmpl /etc/consul-terminal/sensu/
ADD bash_functions.sh /opt/qnib/consul/etc/bash_functions.sh

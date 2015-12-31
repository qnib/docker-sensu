### Add Sensu to the mix
FROM qnib/consul

ADD etc/yum.repos.d/sensu.repo /etc/yum.repos.d/
RUN yum install -y sensu nmap && \
    mkdir -p /var/run/sensu && \
    chown sensu: /var/run/sensu
ENV SENSU_CLIENT=false \
    SENSU_API=false \
    SENSU_SERVER=false
ADD etc/sensu/config.json /etc/sensu/
ADD etc/sensu/conf.d/*.json /etc/sensu/conf.d/
ADD etc/supervisord.d/*.ini /etc/supervisord.d/
ADD etc/consul.d/*.json /etc/consul.d/
RUN chown sensu: /etc/consul.d/sensu-*.json
ADD /opt/qnib/sensu/server/bin/start.sh /opt/qnib/sensu/server/bin/
ADD /opt/qnib/sensu/api/bin/start.sh /opt/qnib/sensu/api/bin/
ADD /opt/qnib/sensu/client/bin/start.sh /opt/qnib/sensu/client/bin/

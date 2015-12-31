### Add Sensu to the mix
FROM qnib/consul

ADD etc/yum.repos.d/sensu.repo /etc/yum.repos.d/
RUN yum install -y sensu nmap && \
    mkdir -p /var/run/sensu && \
    chown sensu: /var/run/sensu
ADD etc/sensu/config.json /etc/sensu/
ADD etc/sensu/conf.d/client.json /etc/sensu/conf.d/
ADD etc/supervisord.d/*.ini /etc/supervisord.d/
ADD etc/consul.d/*.json /etc/consul.d/

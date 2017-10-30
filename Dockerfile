FROM java:8
MAINTAINER Albert Palenzuela <albert.palenzuela@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
ENV ES_SKIP_SET_KERNEL_PARAMETERS true

RUN apt-get update && \
    apt-get install --no-install-recommends -y supervisor wget apt-transport-https && \
    apt-get clean

# EK
RUN \
    wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add - && \
    rm -f /etc/apt/sources.list.d/* && \
    if ! grep "elastic" /etc/apt/sources.list; then echo "deb https://artifacts.elastic.co/packages/5.x/apt stable main" >> /etc/apt/sources.list;fi && \
    apt-get update && \
    apt-get install --no-install-recommends -y elasticsearch kibana && \
    apt-get clean && \
    sed -i '/#network.host:.*/a network.host: 0\.0\.0\.0' /etc/elasticsearch/elasticsearch.yml && \
    sed -i '/#cluster.name:.*/a cluster.name: elcluster' /etc/elasticsearch/elasticsearch.yml && \
    sed -i '/#path.data: \/path\/to\/data/a path.data: /data' /etc/elasticsearch/elasticsearch.yml && \
    sed -i '/#path.logs: \/path\/to\/logs/a path.logs: /var/log/elasticsearch' /etc/elasticsearch/elasticsearch.yml && \
    sed -i 's/#server\.port: 5601/server.port: 80/' /etc/kibana/kibana.yml && \
    sed -i 's/#server\.host: "localhost"/server.host: 0\.0\.0\.0/' /etc/kibana/kibana.yml

ADD etc/supervisor/conf.d/ /etc/supervisor/conf.d/

RUN mkdir -p /var/log/elasticsearch && \
    mkdir /data && \
    chown elasticsearch:elasticsearch /var/log/elasticsearch && \
    chown elasticsearch:elasticsearch /data

EXPOSE 80 9200 9300

CMD [ "/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf" ]
#CMD ["/bin/bash"]

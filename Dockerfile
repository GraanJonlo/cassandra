FROM phusion/baseimage:0.9.19

MAINTAINER Andy Grant <andy.a.grant@gmail.com>

ADD https://github.com/kelseyhightower/confd/releases/download/v0.11.0/confd-0.11.0-linux-amd64 /usr/local/bin/confd
RUN chmod +x /usr/local/bin/confd

RUN apt-get update && apt-get upgrade -y -o Dpkg::Options::="--force-confold"

RUN \
  add-apt-repository ppa:openjdk-r/ppa && \
  apt-get update && apt-get install -y \
  openjdk-8-jdk \
  python \
  wget

RUN rm -rf /var/lib/apt/lists/*

ENV CASSANDRA_VERSION 3.9

RUN \
  cd /tmp && \
  wget -O cassandra.tar.gz http://apache.mirror.anlx.net/cassandra/$CASSANDRA_VERSION/apache-cassandra-$CASSANDRA_VERSION-bin.tar.gz && \
  tar xvzf cassandra.tar.gz && \
  mv apache-cassandra-$CASSANDRA_VERSION /cassandra && \
  groupadd cassandra && \
  useradd -g cassandra cassandra && \
  rm -rf /tmp/*

VOLUME ["/data"]
VOLUME ["/cassandra/logs"]

RUN mkdir -p /etc/service/cassandra
ADD cassandra.sh /etc/service/cassandra/run

ADD cassandra.toml /etc/confd/conf.d/cassandra.toml
ADD cassandra.yml.tmpl /etc/confd/templates/cassandra.yml.tmpl

EXPOSE 7000-7001 9042 9160

CMD ["/sbin/my_init", "--quiet"]
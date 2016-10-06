#!/bin/bash
/usr/local/bin/confd -onetime -backend env

mkdir -p /cassandra/data
mkdir -p /cassandra/logs
mkdir -p /data/data
mkdir -p /data/hints
mkdir -p /data/commitlog
mkdir -p /data/saved_caches
chown cassandra:cassandra /data
chown cassandra:cassandra /cassandra/data
chown cassandra:cassandra /cassandra/logs
chmod 0755 /data
chmod 0755 /cassandra/data
chmod 0755 /cassandra/logs

exec /sbin/setuser cassandra /cassandra/bin/cassandra -f

# Kerberized autoscalable Hadoop cluster

## Start the cluster

First start krb5.

```
docker-compose up -d krb5
```

__WARNING: krb5 servers is development only. It's totally insecure. It contains a simple REST endpoint to give you any keystore/keytab files without authentication__

Start all the other components
```
docker-compose up -d
```

Feel free to scale up, if you need:

```
docker-compose scale datanode=2
```

## Smoketest

From the client machine (you need the krb5.conf):

```
docker-compose exec datanode bash
apk add --update krb5
kinit -kt /opt/hadoop/etc/hadoop/dn.keytab dn/`hostname`
klist
hdfs dfs -ls /
curl -v --negotiate -u : "http://sc:50070/webhdfs/v1/?op=LISTSTATUS&user.name=root"
klist
```

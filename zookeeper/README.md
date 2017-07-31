
# Zookeeper 3 node quorum configuration.

To start:

```
docker-compose up -d
```

To check the state:

```
for i in `seq 1 3`; do docker-compose exec zookeeper$i bash -c "echo srvr | nc localhost 2181"; done
```

To start a cli:

```
docker-compose exec zookeeper1 zkCli.sh
```

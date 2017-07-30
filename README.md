# Docker compose based hadoop/spark cluster

This repository contains docker-compose files to demonstrate usage of the flokkr docker images with simple docker-compose files.

To start the containers go to a subdirectory and start the containers with 

```
docker-compose up -d
```

To scale services

```
docker-compose scale datanode=1
```

## Attributes

| Topic                                    | Solution                                 |
| ---------------------------------------- | ---------------------------------------- |
| __Configuration management__             |                                          |
| Source of config files:                  | docker-compose external environment variable file |
| Configuration preprocessing:             | **envtoconf** (Convert environment variables to configuration formats |
| Automatic restart on config change:      | Not supported, docker-compose up is required |
| __Provisioning and scheduling__          |                                          |
| Multihost support                        | NO                                       |
| Requirements on the hosts                | docker daemon and docker-compose         |
| Definition of the containers per host    | N/A, one docker-compose file for the local host |
| Scheduling (find hosts with available resource) | NO, localhost only                       |
| Failover on host crash                   | NO                                       |
| Scale up/down:                           | Easy with ```docker-compose scale datanode=3``` |
| Multi tenancy (multiple cluster)         | Partial (from multiple checkout directory, after port adjustment) |
| __Network__                              |                                          |
| Network between containers               | dedicated network per docker-compose file |
| DNS                                      | YES, handled by the docker network       |
| Service discovery                        | NO (DNS based)                           |
| Data locality                            | NO                                       |
| Availability of the ports                | Published according to the docker-compose files |

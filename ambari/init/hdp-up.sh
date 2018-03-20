#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
curl -v -k -u admin:admin -H "X-Requested-By:ambari" -X POST --data @$DIR/hdfs-blueprint.json  http://ambari-server:8080/api/v1/blueprints/hdfs
curl -v -k -u admin:admin -H "X-Requested-By:ambari" -X POST http://ambari-server:8080/api/v1/version_definitions -d '{
  "VersionDefinition": {
   "version_url": "http://public-repo-1.hortonworks.com/HDP/centos7/2.x/updates/2.6.3.0/HDP-2.6.3.0-235.xml"
    }
  }'

curl -v -k -u admin:admin -H "X-Requested-By:ambari" -X POST http://ambari-server:8080/api/v1/clusters/c1 -d '{
  "blueprint": "hdfs",
  "default_password": "Welcome1",
  "repository_version_id": 1,
  "configurations": [
    {
    }
  ],
  "host_groups": [
    {
      "name": "host_group_1",
      "host_count": 1
    }
  ]
}'


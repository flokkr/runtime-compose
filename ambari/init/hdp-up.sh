#!/usr/bin/env bash

curl -v -k -u admin:admin -H "X-Requested-By:ambari" -X POST --data @hdfs-blueprint.json  http://localhost:8080/api/v1/blueprints/hdfs
curl -v -k -u admin:admin -H "X-Requested-By:ambari" -X POST http://localhost:8080/api/v1/version_definitions -d '{
  "VersionDefinition": {
   "version_url": "http://public-repo-1.hortonworks.com/HDP/centos6/2.x/updates/2.6.3.0/HDP-2.6.3.0-235.xml"
    }
  }'

#!/bin/bash

export PATH=/var/vcap/packages/docker/bin:$PATH
REGISTY_CONFIG=/var/vcap/jobs/shipyard/config
export DOCKER_HOST=<%= p('swarmmaster_ip') %>:<%= p('swarmmaster_port') %>

shipyard_host=`docker port shipyard-controller |cut -d ' ' -f 3 |cut -d ':' -f 1`
shipyard_port=`docker port shipyard-controller |cut -d ' ' -f 3 |cut -d ':' -f 2`

awk 'NR==3{$2="\"'$shipyard_host'\""}NR==6{$2="'$shipyard_port'"}NR==6{$1="  port:"}{print}' $REGISTY_CONFIG/route-registrar.tpl > $REGISTY_CONFIG/route-registrar.tpls

diffent=`diff $REGISTY_CONFIG/route-registrar.tpls $REGISTY_CONFIG/route-registrar.yml`

if [ "$diffent" == "" ]; then
  echo "NoChange"
else
    cp $REGISTY_CONFIG/route-registrar.tpls $REGISTY_CONFIG/route-registrar.yml
fi

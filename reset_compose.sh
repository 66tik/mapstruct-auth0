#!/bin/bash

stack=${PWD##*/}
rmi=local
file=src/main/docker/mariadb.yml

if [ -z ${1+x} ];
  then rmi=local;
  else rmi=$1;
fi
# echo $rmi

## --rmi flag must be one of: all, local
docker-compose -f $file -p $stack down --rmi $rmi --volumes

docker-compose -f $file -p $stack up -d --build --remove-orphans --force-recreate

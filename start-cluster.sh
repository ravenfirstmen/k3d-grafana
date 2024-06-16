#!/bin/bash

CLUSTER_NAME=${1:-"grafana"}
SHARED_VOLUME=$(pwd)/.volume

mkdir -p ${SHARED_VOLUME}

# this is manadatory in order to fluent-bit work
if [ -f /etc/machine-id ]; then
  cp -f /etc/machine-id ${SHARED_VOLUME}/
else
  #touch ${SHARED_VOLUME}/machine-id
  $(uuid | sed 's/-//g') > ${SHARED_VOLUME}/machine-id
fi

k3d cluster create $CLUSTER_NAME \
    --api-port 6443 \
    --port "9090:9090@loadbalancer" \
    --port "4222:4222@loadbalancer" \
    --port "3000:3000@loadbalancer" \
    --agents 3 \
    --k3s-arg '--disable=metrics-server@server:*' \
    --volume ${SHARED_VOLUME}/machine-id:/etc/machine-id \
    --volume "$(pwd)/manifests:/var/lib/rancher/k3s/server/manifests/custom"

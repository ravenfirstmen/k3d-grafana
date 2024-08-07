#!/bin/bash

CLUSTER_NAME=${1:-"grafana"}
SHARED_VOLUME=$(pwd)/.volume

mkdir -p ${SHARED_VOLUME}

# this is manadatory in order to fluent-bit work
if [ -f /etc/machine-id ]; then
  cp -f /etc/machine-id ${SHARED_VOLUME}/
else
  uuidgen -r -x | tr -d '-' > ${SHARED_VOLUME}/machine-id
fi

    # --registry-create k3d-registry.localhost:5000 \
k3d cluster create $CLUSTER_NAME \
    --api-port 6443 \
    --registry-create k3d-registry.localhost:5000 \
    --port "9090:9090@loadbalancer" \
    --port "4222:4222@loadbalancer" \
    --port "3000:3000@loadbalancer" \
    --port "3100:3100@loadbalancer" \
    --port "4318:4320@loadbalancer" \
    --port "4566:4566@loadbalancer" \
    --port "5432:5432@loadbalancer" \
    --servers 1 \
    --agents 3 \
    --k3s-arg '--disable=metrics-server@server:*' \
    --volume "${SHARED_VOLUME}/machine-id:/etc/machine-id@server:*;agent:*" \
    --volume "$(pwd)/manifests:/var/lib/rancher/k3s/server/manifests/custom@server:*"

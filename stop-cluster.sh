#!/bin/bash

CLUSTER_NAME=${1:-"grafana"}
SHARED_VOLUME=$(pwd)/.volume

k3d cluster delete ${CLUSTER_NAME}

rm -rf ${SHARED_VOLUME}

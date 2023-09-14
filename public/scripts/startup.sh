#!/bin/bash

if [ $# -lt 4 ]; then
  echo "Usage: $0 <server_name> <server_tag> <deploy port|expose:source> <debug port|expose:source>"
  exit 1
fi

SERVER_NAME=$1
SERVER_TAG=$2
SERVER_PORT=$3
DEBUG_PORT=$4
CONTAINER_ID=$(docker ps -aq --filter name=$1)

DOCKER_START_CMD="docker run -d --name ${SERVER_NAME} -p ${SERVER_PORT} -p ${DEBUG_PORT} --restart=always ${SERVER_NAME}:${SERVER_TAG}"
DOCKER_STOP_CMD="docker stop ${CONTAINER_ID}"
DOCKER_RM_CMD="docker rm ${CONTAINER_ID}"

if [ -z "${CONTAINER_ID}" ]; then
    echo "no previous container, start a new container"
else
  echo "previous container exists, stopping"
  echo "executing docker stop"
  eval "${DOCKER_STOP_CMD}"
  echo "executing docker rm"
  eval "${DOCKER_RM_CMD}"
  echo "start a new container"
fi

eval "${DOCKER_START_CMD}"
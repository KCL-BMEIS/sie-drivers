#!/bin/bash
HOST=aicregistry
PORT=5000
NAMESPACE=mock-or-drivers
TAG=ubuntu-24.04-ros-jazzy
docker build . -f docker/$TAG.Dockerfile \
  --no-cache \
  --tag $HOST:$PORT/$NAMESPACE:$TAG
docker push $HOST:$PORT/$NAMESPACE:$TAG

#!/usr/bin/env bash

set -euo pipefail

# Container configuration
CONTAINER_NAME=baxter
DOCKER_IMAGE=dabaspark/kinetic-baxter:nvidia 

# GPU configuration
GPUS="all"

# X11 configuration
XSOCK=/tmp/.X11-unix
XAUTH=$(pwd)/.tmp/docker.xauth
XAUTH_DOCKER=/tmp/.docker.xauth

# Create .tmp directory if it doesn't exist
mkdir -p .tmp

# Setup X authentication
if [ ! -f $XAUTH ]
then
    xauth_list=$(xauth nlist :0 | sed -e 's/^..../ffff/')
    if [ ! -z "$xauth_list" ]
    then
        echo "$xauth_list" | xauth -f $XAUTH nmerge -
    else
        touch $XAUTH
    fi
    chmod a+r $XAUTH
fi

# Pull the latest image
echo "Pulling the latest image..."
docker pull $DOCKER_IMAGE

# Run the container
echo "Starting Docker container..."
docker run --rm -it \
    --name "$CONTAINER_NAME" \
    --gpus "$GPUS" \
    --env="DISPLAY" \
    --env="QT_X11_NO_MITSHM=1" \
    --env="XAUTHORITY=$XAUTH_DOCKER" \
    --volume="$XSOCK:$XSOCK:rw" \
    --volume="$XAUTH:$XAUTH_DOCKER:rw" \
    $DOCKER_IMAGE \
    bash

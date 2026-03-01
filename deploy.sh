#! /bin/bash

IMG_NAME=$1

echo "Pulling the latest image"
docker pull $IMG_NAME

echo "Stopping old containers"
docker stop -f cloud-transcoder 2>/dev/null || true
docker rm -f cloud-transcoder 2>/dev/null || true

echo "Running the new image"
docker run -d --name cloud-transcoder --restart always --env-file /home/ubuntu/cloud-transcoder.env $IMG_NAME
echo "App deployed successfully"
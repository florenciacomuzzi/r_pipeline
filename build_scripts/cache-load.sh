#!/bin/bash
set -e

echo 'Loading docker cache...'
mkdir -p $IMAGE_CACHE_PATH

DOCKER_IMAGES_CACHE=`mktemp`
find $IMAGE_CACHE_PATH -name *.tar.gz > $DOCKER_IMAGES_CACHE

while read file; do
    echo $file
    if ! docker load -i $file; then
        echo "Error loading docker image $file. Removing..."
        rm $file
    fi
done < $DOCKER_IMAGES_CACHE

rm $DOCKER_IMAGES_CACHE

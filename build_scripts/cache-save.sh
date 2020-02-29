#/bin/bash
set -e

mkdir -p $IMAGE_CACHE_PATH
DOCKER_IMAGES_NEW=`mktemp`
docker images -q --no-trunc | awk -F':' '{print $2}' | sort > $DOCKER_IMAGES_NEW

DOCKER_IMAGES_CACHE=`mktemp`
find $IMAGE_CACHE_PATH -name *.tar.gz -printf '%f\n' | awk -F. '{print $1}' | sort > $DOCKER_IMAGES_CACHE

DOCKER_IMAGES_DELETE=`mktemp`
DOCKER_IMAGES_SAVE=`mktemp`
comm -13 $DOCKER_IMAGES_NEW $DOCKER_IMAGES_CACHE > $DOCKER_IMAGES_DELETE
comm -23 $DOCKER_IMAGES_NEW $DOCKER_IMAGES_CACHE > $DOCKER_IMAGES_SAVE

if [ $(< $DOCKER_IMAGES_DELETE wc -l) -gt 0 ]; then
    echo Deleting docker images that are no longer current
    < $DOCKER_IMAGES_DELETE xargs -I % sh -c "echo Deleting extraneous image % && rm $IMAGE_CACHE_PATH/%.tar.gz"
    echo
fi

if [ $(< $DOCKER_IMAGES_SAVE wc -l) -gt 0 ]; then
    echo Saving missing images to docker cache
    < $DOCKER_IMAGES_SAVE xargs -I % sh -c "echo Saving image % && docker save % | gzip -c > '$IMAGE_CACHE_PATH/%.tar.gz'"
    echo
fi

rm $DOCKER_IMAGES_NEW $DOCKER_IMAGES_CACHE $DOCKER_IMAGES_DELETE $DOCKER_IMAGES_SAVE

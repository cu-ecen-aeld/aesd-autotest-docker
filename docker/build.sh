#!/bin/bash
set -e
pushd $(dirname $0)/..
BUILDARGS="--load"
TAGPREFIX="24-"
#See https://devops.stackexchange.com/a/4450
for number in $(seq 7) 4-buildroot 5-buildroot 7-buildroot; do
    docker buildx build ${BUILDARGS} -f docker/Dockerfile --target assignment${number} -t cuaesd/aesd-autotest:${TAGPREFIX}assignment${number} src
done
docker tag cuaesd/aesd-autotest:${TAGPREFIX}assignment1 cuaesd/aesd-autotest:${TAGPREFIX}unit-test

docker buildx build ${BUILDARGS} -f docker/Dockerfile-yocto --target assignment6-yocto -t cuaesd/aesd-autotest:${TAGPREFIX}assignment6-yocto src

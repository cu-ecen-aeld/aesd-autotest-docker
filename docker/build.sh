#!/bin/bash
set -e
pushd $(dirname $0)/..
#See https://devops.stackexchange.com/a/4450
for number in $(seq 7) 4-buildroot 5-buildroot 7-buildroot; do
    docker build -f docker/Dockerfile --target assignment${number} -t cuaesd/aesd-autotest:assignment${number} src
done
docker tag cuaesd/aesd-autotest:assignment1 cuaesd/aesd-autotest:unit-test

docker build -f docker/Dockerfile-yocto --target assignment6-yocto -t cuaesd/aesd-autotest:assignment6-yocto src

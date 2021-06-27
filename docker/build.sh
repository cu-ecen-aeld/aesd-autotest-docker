#!/bin/bash
set -e
pushd $(dirname $0)/..
#See https://devops.stackexchange.com/a/4450
for number in $(seq 6) 4-buildroot 5-buildroot; do
    docker build -f docker/Dockerfile --target assignment${number} -t cuaesd/aesd-autotest:assignment${number} src
done
docker tag cuaesd/aesd-autotest:assignment1 cuaesd/aesd-autotest:unit-test

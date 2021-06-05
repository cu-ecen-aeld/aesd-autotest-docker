#!/bin/bash
pushd $(dirname $0)/..
#See https://devops.stackexchange.com/a/4450
for number in $(seq 3); do
    docker build -f docker/Dockerfile --target assignment${number} -t cuaesd/aesd-autotest:assignment${number} src
done
docker tag cuaesd/aesd-autotest:assignment1 cuaesd/aesd-autotest:unit-test

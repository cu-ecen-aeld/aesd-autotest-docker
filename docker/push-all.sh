#!/bin/bash
set -e
for number in $(seq 6); do
    docker push cuaesd/aesd-autotest:assignment${number}
done
docker push cuaesd/aesd-autotest:assignment4-buildroot
docker push cuaesd/aesd-autotest:assignment5-buildroot
docker push cuaesd/aesd-autotest:unit-test

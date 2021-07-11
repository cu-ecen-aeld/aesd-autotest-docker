#!/bin/bash
set -e
for number in $(seq 7); do
    docker push cuaesd/aesd-autotest:assignment${number}
done
docker push cuaesd/aesd-autotest:assignment4-buildroot
docker push cuaesd/aesd-autotest:assignment5-buildroot
docker push cuaesd/aesd-autotest:assignment7-buildroot
docker push cuaesd/aesd-autotest:assignment6-yocto
docker push cuaesd/aesd-autotest:unit-test

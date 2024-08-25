#!/bin/bash
set -e
TAGPREFIX="24-"
for number in $(seq 7); do
    docker push cuaesd/aesd-autotest:${TAGPREFIX}assignment${number}
done
docker push cuaesd/aesd-autotest:${TAGPREFIX}assignment4-buildroot
docker push cuaesd/aesd-autotest:${TAGPREFIX}assignment5-buildroot
docker push cuaesd/aesd-autotest:${TAGPREFIX}assignment7-buildroot
docker push cuaesd/aesd-autotest:${TAGPREFIX}assignment6-yocto
docker push cuaesd/aesd-autotest:${TAGPREFIX}unit-test

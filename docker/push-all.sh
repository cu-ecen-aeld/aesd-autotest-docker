#!/bin/bash
for number in $(seq 3); do
    docker push cuaesd/aesd-autotest:assignment${number}
done
docker push cuaesd/aesd-autotest:unit-test

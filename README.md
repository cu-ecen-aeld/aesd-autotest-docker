# CU Boulder Advanced Embedded Software Development Docker Container

A docker container used for autotest of software projects used with CU Boulder
 [Advanced Embedded Software Development](https://sites.google.com/colorado.edu/ecen5013/home)


## Contents
* Ubuntu base image with development essentials, cmake and ruby to support [Unity](http://www.throwtheswitch.org/)
plus dependencies to support testing assignments.

## Testing Locally
You can test your changes locally (before they are available on docker hub) by building your own updated
image.  Use 

`./docker/build.sh`

to build an image for each assignment and tag accordingly

## Pushing to Docker Hub
When an assignment container is complete and ready to be run with the autotest framework, push to docker hub using 
```
docker login
docker push cuaesd/aesd-autotest:<tagname>
```

Tags are created for each assignment as well as a generic `unit-test` tag to support Unity unit testing.

Talk to Dan if you need access to docker hub.

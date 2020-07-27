# CU Boulder Advanced Embedded Software Development Docker Container

A docker container used for autotest of software projects used with CU Boulder
 [Advanced Embedded Software Development](https://sites.google.com/colorado.edu/ecen5013/home)


## Contents
* Ubuntu base image with development essentials, cmake and ruby to support [Unity](http://www.throwtheswitch.org/)
plus dependencies to support testing assignments.

## Usage

Start with

`docker run -it -v <local project path>:/project cuaesd/aesd-autotest`

To mount your `<local project path>` to /project within the container.  This will open an interactive command
prompt you can use to run within the container.

To run a specific test script in the container, you can use

`docker run -it -v <local project path>:/project cuaesd/aesd-autotest ./<scriptname>`

where `<scriptname>` is the path to the script relative to the local project path specified

## Testing Locally
You can test your changes locally (before they are available on docker hub) by building your own updated
image.  Use 

`docker build . -t cuaesd/aesd-autotest`

## Tagging
Use [docker tags](https://docs.docker.com/engine/reference/commandline/tag/) to tag an image for a specific assignment.  The tag should match the name specified in the `conf/assignment.txt` file for the given assignment.
```
docker tag cuaesd/aesd-autotest:latest cuaesd/aesd-autotest:<tagname>
```
or if you want to use the same container used in a different assignment, use:
```
docker tag cuaesd/aesd-autotest:<otherassignment> cuaesd/aesd-autotest:<tagname>
```

## Pushing to Docker Hub
When an assignment container is complete and ready to be run with the autotest framework, push to docker hub using 
```
docker login
docker push cuaesd/aesd-autotest:<tagname>
```
Talk to Dan if you need access to docker hub.

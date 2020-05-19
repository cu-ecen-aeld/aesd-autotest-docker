# CU Boulder Advanced Embedded Software Development Docker Container

A docker container used for autotest of software projects used with CU Boulder
 [Advanced Embedded Software Development](https://sites.google.com/colorado.edu/ecen5013/home)


## Contents
* Ubuntu base image with development essentials, cmake and ruby to support [Unity](http://www.throwtheswitch.org/)

## Usage

Start with

`docker run -it -v <local project path>:/project cuaesd/aesd-autotest`

To mount your `<local project path>` to /project within the container.  This will open an interactive command
prompt you can use to run within the container.

To run a specific test script in the container, you can use

`docker run -it -v <local project path>:/project cuaesd/aesd-autotest ./<scriptname>`

where `<scriptname>` is the path to the script relative to the local project path specified

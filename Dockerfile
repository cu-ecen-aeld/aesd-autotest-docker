from ubuntu:18.04

MAINTAINER Dan Walkes (walkes@colorado.edu)

# Assignment 1 requirements
RUN apt-get update && apt-get install -y ruby cmake git build-essential bsdmainutils valgrind sudo

# Assignment 3 requirments - support crosstool-ng
RUN apt-get install -y automake bison chrpath flex g++ git gperf \
    gawk libexpat1-dev libncurses5-dev libsdl1.2-dev libtool \
    python2.7-dev texinfo help2man libtool-bin wget

# Add a user account with sude permissions, use uid and gid unlikely to conflict
# with a typical install
RUN groupadd -g 3000 autotest-admin && \
    adduser --uid 3000 --gid 3000 --disabled-password --gecos '' autotest-admin && \
    adduser autotest-admin sudo && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER autotest-admin

WORKDIR /home/autotest-admin

COPY crosstool-config .

RUN git clone https://github.com/crosstool-ng/crosstool-ng.git && \
    cd crosstool-ng && \
    git checkout crosstool-ng-1.24.0 && \
    ./bootstrap && \
    ./configure --enable-local && \
     make && \
    ./ct-ng distclean && \
    ./ct-ng arm-unknown-linux-gnueabi && \
    cp ../crosstool-config .config && \
    ./ct-ng build && \
    cd .. && \
    rm -rf crosstool-ng

# Make all cross compile tools executable by all users
RUN chmod 775 /home/autotest-admin/x-tools/arm-unknown-linux-gnueabi/bin/*

USER root

# Assignment 3 kernel build - add kernel build dependencies and qemu-system-arm
RUN apt-get update && apt-get install -y bc qemu-system-arm u-boot-tools kmod cpio

#Assignment 4 changes
# See https://docs.docker.com/engine/reference/builder/#from
# and https://hub.docker.com/_/ubuntu/
# Use the docker hub ubuntu image version 18.04
FROM ubuntu:18.04 AS aesd-build

RUN export UBUNTU_FRONTEND=noninteractive

RUN apt-get update && apt-get install apt-utils -y
RUN apt-get install -y tzdata
RUN ln -fs /usr/share/zoneinfo/America/Denver /etc/localtime 
RUN dpkg-reconfigure -f noninteractive tzdata

RUN apt-get update && apt-get install -y dialog build-essential


# Buildroot requirements for assignments 4 and later                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
RUN apt-get update && apt-get install -y sed make binutils build-essential bash \
    patch gzip bzip2 perl tar cpio unzip rsync file bc wget python libncurses5-dev \
    git qemu openssh-client expect sshpass psmisc

# Add github to known hosts so we don't get prompted to allow ssh key use there
RUN touch /home/admin/.ssh/known_hosts
RUN ssh-keyscan github.com >> /home/admin/.ssh/known_hosts
# See https://docs.docker.com/engine/reference/builder/#copy
# All files in the current directory should be copied to
# the WORKDIR assignment-testing directory
COPY . assignment-testing

RUN mkdir /project

# Create empty project directory (to be mapped by source code volume)
WORKDIR /project

CMD ["/bin/bash"]

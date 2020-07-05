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

RUN mkdir /project

# Create empty project directory (to be mapped by source code volume)
WORKDIR /project

CMD ["/bin/bash"]

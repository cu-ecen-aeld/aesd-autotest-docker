from ubuntu:18.04

MAINTAINER Dan Walkes (walkes@colorado.edu)

# Assignment 1 requirements
RUN apt-get update && apt-get install -y ruby cmake git build-essential bsdmainutils valgrind sudo

# Assignment 3 requirments - support crosstool-ng
RUN apt-get update && apt-get install -y automake bison chrpath flex g++ git gperf \
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
RUN apt-get update && \
    DEBIAN_FRONTEND="noninteractive" TZ="America/Denver" apt-get install -y apt-utils \
                        tzdata \
                        sudo \
                        dialog \
                        build-essential \
                        sed make binutils bash patch gzip bzip2 perl tar cpio unzip rsync file bc wget python libncurses5-dev git qemu\
                        openssh-client \
                        expect \
                        sshpass \
                        psmisc \
                        && \
    ln -fs /usr/share/zoneinfo/America/Denver /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

# Assignment 5 changes
RUN apt-get update && \
    apt-get install -y netcat iputils-ping
    
#Assignment 6 changes
RUN apt-get update && \
    UBUNTU_FRONTEND="noninteractive" TZ="America/Denver" apt-get install -y apt-utils \
                        valgrind \
                        netcat \
                        tzdata \
                        sudo \
                        dialog \
                        build-essential \
                        gawk wget git-core diffstat unzip texinfo gcc-multilib \
                        chrpath socat cpio python3 python3-pip python3-pexpect \
                        xz-utils debianutils iputils-ping python3-git python3-jinja2 libegl1-mesa libsdl1.2-dev xterm locales \
                        && \
    ln -fs /usr/share/zoneinfo/America/Denver /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

RUN locale-gen en_US.UTF-8 && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
CMD ["/bin/bash"]

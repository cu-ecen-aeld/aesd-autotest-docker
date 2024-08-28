FROM ubuntu:22.04 AS assignment1

LABEL maintainer="Dan Walkes (walkes@colorado.edu)"

# Assignment 1 requirements
RUN apt-get update &&  \
    DEBIAN_FRONTEND="noninteractive" TZ="America/Denver"  apt-get install -y \
    --no-install-recommends \
    ruby cmake git build-essential bsdmainutils valgrind sudo wget

# Avoids "detected dubious ownership"
# based on discussion at https://github.com/git/git/commit/8959555cee7ec045958f9b6dd62e541affb7e7d9
# Since this container is only used/useful with autotest runners and
# the autotest runner will create its own work directory I don't think
# the shared directory exposure listed there applies
RUN git config --system --add safe.directory '*'

# For use with github actions we need a user account we can run in the container which
# maps to the user setup on the github runner VM instance.
RUN groupadd -g 1001 autotest-admin && \
    adduser --uid 1001 --gid 1001 --disabled-password --gecos '' autotest-admin && \
    adduser autotest-admin sudo && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

FROM assignment1 AS assignment2
FROM assignment2 AS assignment3-kernel

# Assignment 3 kernel build - add kernel build dependencies and qemu-system-arm
# Use recommends with qemu-system-arm since it needs rom files we don't obtain with no-install-recommends
RUN apt-get update && apt-get install -y --no-install-recommends \
        bc u-boot-tools kmod cpio flex bison libssl-dev psmisc && \
    apt-get install -y qemu-system-arm

FROM assignment3-kernel AS assignment3
WORKDIR /usr/local/arm-cross-compiler/
ARG GCC_ARM_VERSION=13.3.rel1
# Assignment 3 - ARM cross compiler
RUN wget -O gcc-arm.tar.xz \
    https://developer.arm.com/-/media/Files/downloads/gnu/$GCC_ARM_VERSION/binrel/arm-gnu-toolchain-$GCC_ARM_VERSION-x86_64-aarch64-none-linux-gnu.tar.xz && \
    mkdir install && \
    tar x -C install -f gcc-arm.tar.xz && \
    rm -r gcc-arm.tar.xz

ENV PATH="${PATH}:/usr/local/arm-cross-compiler/install/arm-gnu-toolchain-$GCC_ARM_VERSION-x86_64-aarch64-none-linux-gnu/bin"

RUN  sed -i "/^# If not running interactively, don't do anything.*/i export PATH=\$PATH:$(find /usr/local/arm-cross-compiler/install -maxdepth 2 -type d -name bin)" \
            /root/.bashrc
RUN  sed -i "/^# If not running interactively, don't do anything.*/i export PATH=\$PATH:$(find /usr/local/arm-cross-compiler/install -maxdepth 2 -type d -name bin)" \
            /home/autotest-admin/.bashrc


# For assignment 4 we don't need assignment 3 cross compile content, we'll use buildroot for this
FROM assignment3-kernel AS assignment4-buildroot
RUN apt-get update && \
    DEBIAN_FRONTEND="noninteractive" TZ="America/Denver" apt-get install -y apt-utils \
                        tzdata \
                        sudo \
                        dialog \
                        build-essential \
                        sed make binutils bash patch gzip bzip2 perl tar cpio unzip rsync file bc wget python3 libncurses5-dev git qemu\
                        openssh-client \
                        expect \
                        sshpass \
                        psmisc \
                        netcat iputils-ping \
                        && \
    ln -fs /usr/share/zoneinfo/America/Denver /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

RUN apt-get update && apt-get install --reinstall ca-certificates && \
    update-ca-certificates

FROM assignment2 AS assignment4
FROM assignment4 AS assignment5
RUN apt-get update && \
    apt-get install -y netcat

FROM assignment5 AS assignment6
FROM assignment6 AS assignment7

FROM assignment4-buildroot AS assignment5-buildroot
RUN apt-get update && \
    apt-get install -y netcat

FROM assignment5-buildroot AS assignment7-buildroot

WORKDIR /home/autotest-admin
COPY entrypoint.sh .
RUN chmod a+x entrypoint.sh
ENTRYPOINT [ "/home/autotest-admin/entrypoint.sh" ]

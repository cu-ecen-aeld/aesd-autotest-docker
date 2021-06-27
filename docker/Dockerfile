from ubuntu:20.04 AS assignment1

MAINTAINER Dan Walkes (walkes@colorado.edu)

# Assignment 1 requirements
RUN apt-get update &&  \
    DEBIAN_FRONTEND="noninteractive" TZ="America/Denver"  apt-get install -y \
    --no-install-recommends \
    ruby cmake git build-essential bsdmainutils valgrind sudo wget

# Add a user account with sude permissions, use uid and gid unlikely to conflict
# with a typical install
RUN groupadd -g 3000 autotest-admin && \
    adduser --uid 3000 --gid 3000 --disabled-password --gecos '' autotest-admin && \
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

# Assignment 3 - ARM cross compiler
RUN wget -O gcc-arm.tar.xz \
    https://developer.arm.com/-/media/Files/downloads/gnu-a/10.2-2020.11/binrel/gcc-arm-10.2-2020.11-x86_64-aarch64-none-linux-gnu.tar.xz && \
    mkdir install && \
    tar x -C install -f gcc-arm.tar.xz && \
    rm -r gcc-arm.tar.xz


# Assignment 3 path updates
#RUN  echo "export PATH=\$PATH:$(find /usr/arm-cross-compiler/install -maxdepth 2 -type d -name bin)" >> \
#            /root/.bashrc

RUN  sed -i "/^# If not running interactively, don't do anything.*/i export PATH=\$PATH:$(find /usr/local/arm-cross-compiler/install -maxdepth 2 -type d -name bin)" \
            /root/.bashrc
RUN  sed -i "/^# If not running interactively, don't do anything.*/i export PATH=\$PATH:$(find /usr/local/arm-cross-compiler/install -maxdepth 2 -type d -name bin)" \
            /home/autotest-admin/.bashrc

ENV PATH="${PATH}:/usr/local/arm-cross-compiler/install/gcc-arm-10.2-2020.11-x86_64-aarch64-none-linux-gnu/bin"

# For assignment 4 we don't need assignment 3 cross compile content, we'll use buildroot for this
from assignment3-kernel AS assignment4-buildroot
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
                        netcat iputils-ping \
                        && \
    ln -fs /usr/share/zoneinfo/America/Denver /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

FROM assignment2 AS assignment4
FROM assignment4 AS assignment5
RUN apt-get update && \
    apt-get install -y netcat

FROM assignment5 AS assignment6

FROM assignment4-buildroot AS assignment5-buildroot
RUN apt-get update && \
    apt-get install -y netcat

WORKDIR /home/autotest-admin
COPY entrypoint.sh .
RUN chmod a+x entrypoint.sh
ENTRYPOINT [ "/home/autotest-admin/entrypoint.sh" ]

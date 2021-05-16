from ubuntu:20.04

MAINTAINER Dan Walkes (walkes@colorado.edu)

# Assignment 1 requirements
RUN apt-get update &&  \
    DEBIAN_FRONTEND="noninteractive" TZ="America/Denver"  apt-get install -y \
    ruby cmake git build-essential bsdmainutils valgrind sudo wget

# Add a user account with sude permissions, use uid and gid unlikely to conflict
# with a typical install
RUN groupadd -g 3000 autotest-admin && \
    adduser --uid 3000 --gid 3000 --disabled-password --gecos '' autotest-admin && \
    adduser autotest-admin sudo && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

WORKDIR /usr/arm-cross-compiler/

# Assignment 3 - ARM cross compiler
RUN wget -O gcc-arm.tar.xz \
    https://developer.arm.com/-/media/Files/downloads/gnu-a/10.2-2020.11/binrel/gcc-arm-10.2-2020.11-x86_64-aarch64-none-linux-gnu.tar.xz && \
    mkdir install && \
    tar x -C install -f gcc-arm.tar.xz && \
    rm -rf gcc-arm.tar.gz

# Assignment 3 kernel build - add kernel build dependencies and qemu-system-arm
RUN apt-get update && apt-get install -y bc qemu-system-arm u-boot-tools kmod cpio flex bison

# Assignment 3 path updates
#RUN  echo "export PATH=\$PATH:$(find /usr/arm-cross-compiler/install -maxdepth 2 -type d -name bin)" >> \
#            /root/.bashrc

RUN  sed -i "/^# If not running interactively, don't do anything.*/i export PATH=\$PATH:$(find /usr/arm-cross-compiler/install -maxdepth 2 -type d -name bin)" \
            /root/.bashrc
RUN  sed -i "/^# If not running interactively, don't do anything.*/i export PATH=\$PATH:$(find /usr/arm-cross-compiler/install -maxdepth 2 -type d -name bin)" \
            /home/autotest-admin/.bashrc



WORKDIR /home/autotest-admin
COPY entrypoint.sh .
RUN chmod a+x entrypoint.sh
ENTRYPOINT [ "/home/autotest-admin/entrypoint.sh" ]

from ubuntu:18.04

MAINTAINER Dan Walkes (walkes@colorado.edu)

# Assignment 1 requirements
RUN apt-get update && apt-get install -y ruby cmake git build-essential bsdmainutils valgrind sudo

# Assignment 3 requirments - support crosstool-ng
RUN apt-get install -y automake bison chrpath flex g++ git gperf \
    gawk libexpat1-dev libncurses5-dev libsdl1.2-dev libtool \
    python2.7-dev texinfo help2man libtool-bin wget

RUN adduser  --disabled-password --gecos '' admin && \
    adduser admin sudo && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER admin

WORKDIR /home/admin

COPY crosstool-config .

RUN git clone https://github.com/crosstool-ng/crosstool-ng.git && \
    cd crosstool-ng && \
    git checkout crosstool-ng-1.24.0 && \
    ./bootstrap && \
    ./configure --enable-local && \
     make && \
    ./ct-ng distclean && \
    ./ct-ng arm-unknown-linux-gnueabi && \
    cp ../crosstool-config .config

RUN cd crosstool-ng && \
    ./ct-ng build && \
    cd .. && \
    rm -rf crosstool-ng

USER root
RUN mkdir /project

# Create empty project directory (to be mapped by source code volume)
WORKDIR /project

CMD ["/bin/bash"]

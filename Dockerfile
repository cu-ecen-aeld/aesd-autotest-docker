from ubuntu:18.04

MAINTAINER Dan Walkes (walkes@colorado.edu)

RUN apt-get update && apt-get install -y ruby cmake git build-essential

RUN mkdir /project

# Create empty project directory (to be mapped by source code volume)
WORKDIR /project

CMD ["/bin/bash"]

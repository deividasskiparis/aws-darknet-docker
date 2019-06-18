FROM nvidia/cuda:10.1-base-ubuntu18.04

WORKDIR /opt/docker

RUN apt-get update && \
	apt-get install -y --no-install-recommends git-core vim build-essential python3-dev python3-setuptools python3-pip && \
    rm -rf /var/lib/apt/lists/*

RUN pip3 install setuptools wheel virtualenv --upgrade

RUN pip3 install awscli
RUN git clone https://github.com/pjreddie/darknet.git darknet && \
	cd darknet && \
	make GPU=0 all

WORKDIR /opt/docker

COPY config/* ./
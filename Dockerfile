FROM nvidia/cuda:10.0-devel-ubuntu18.04

WORKDIR /opt/docker

RUN apt-get update && \
		apt-get install -y \
        python3 \
        python3-pip \
        python3-setuptools \
        git-core

RUN pip3 install setuptools wheel virtualenv awscli --upgrade

RUN git clone https://github.com/pjreddie/darknet.git darknet && \
	cd darknet && \
	make GPU=1 all

WORKDIR /opt/docker

COPY config/* ./
COPY scripts/* ./

ENV NETWORK_FILENAME network.cfg
ENV DATA_FILENAME config.data
ENV PRETRAINED_WEIGHTS_FILENAME ""
ENV S3_BUCKET_NAME ""

CMD ["./train.sh"]

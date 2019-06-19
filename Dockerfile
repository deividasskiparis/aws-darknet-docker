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

ARG S3

ENV MODEL_NAME yolov3-tiny
ENV NETWORK_FILENAME ${MODEL_NAME}.cfg
ENV PRETRAINED_WEIGHTS ${MODEL_NAME}.conv.15
ENV DATA_FILENAME config.data
ENV S3_BUCKET_NAME ${S3}


CMD /opt/docker/train-and-save.sh

FROM nvidia/cuda:10.0-devel-ubuntu18.04

WORKDIR /opt/docker

RUN apt-get update && \
		apt-get install -y \
        python3 \
        python3-pip \
        python3-setuptools \
        git-core

RUN pip3 install setuptools wheel virtualenv --upgrade

RUN pip3 --no-cache-dir install --upgrade awscli

RUN git clone https://github.com/pjreddie/darknet.git darknet && \
	cd darknet && \
	make GPU=1 all

WORKDIR /opt/docker

COPY config/* ./
COPY scripts/* ./

ENV MODEL_NAME network
ENV NETWORK_FILENAME ${MODEL_NAME}.cfg
ENV PRETRAINED_WEIGHTS yolov3-tiny.conv.15
ENV DATA_FILENAME config.data
ENV CLASS_NAMES class.names

CMD /opt/docker/train-and-save.sh
FROM nvidia/cuda:10.1-base-ubuntu18.04

WORKDIR /opt/docker

RUN apt-get update && \
		apt-get install -y \
        python3 \
        python3-pip \
        python3-setuptools \
        git-core

RUN pip3 install setuptools wheel virtualenv --upgrade

RUN pip3 --no-cache-dir install --upgrade awscli

RUN pip3 install awscli
RUN git clone https://github.com/pjreddie/darknet.git darknet && \
	cd darknet && \
	make GPU=1 all

WORKDIR /opt/docker

COPY config/* ./
RUN mkdir backup

RUN aws s3 sync s3://social-turbo-ml/data data/
RUN ./darknet/darknet detector train config.data network.cfg yolov3-tiny.conv.15
RUN aws s3 cp /backup/network_final.weights s3://social-turbo-ml/weights
#!/bin/bash
aws s3 sync s3://social-turbo-ml/data data/

mkdir backup
./darknet/darknet detector train ${DATA_FILENAME} ${NETWORK_FILENAME} ${PRETRAINED_WEIGHTS}

aws s3 cp backup/${MODEL_NAME}_final.weights s3://social-turbo-ml/models/

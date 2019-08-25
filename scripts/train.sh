#!/bin/bash
set -e

echo "Getting data from S3"
aws s3 sync s3://${S3_BUCKET_NAME}/data data/
aws s3 sync s3://${S3_BUCKET_NAME}/pretrained pretrained/

if [ ! -d "backup" ]; then
    mkdir backup
fi

if [ -f "pretrained/${PRETRAINED_WEIGHTS_FILENAME}" ]; then
    export PRETRAINED_WEIGHTS="pretrained/${PRETRAINED_WEIGHTS_FILENAME}"
fi

echo "Start training at $(date +"%D %T")"
./darknet/darknet detector train ${DATA_FILENAME} ${NETWORK_FILENAME} ${PRETRAINED_WEIGHTS}

echo "Finished training at $(date +"%D %T")"

source save_weights.sh
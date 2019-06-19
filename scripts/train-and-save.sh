#!/bin/bash
echo "Getting data from S3"
aws s3 sync s3://${S3_BUCKET_NAME}/data data/

mkdir backup
./darknet/darknet detector train ${DATA_FILENAME} ${NETWORK_FILENAME} ${PRETRAINED_WEIGHTS}

UNIX_EPOCH=exec date +%s

echo "Uploading final weights to s3://${S3_BUCKET_NAME}/models/${MODEL_NAME}_${UNIX_EPOCH}.weights"
aws s3 cp backup/${MODEL_NAME}_final.weights s3://${S3_BUCKET_NAME}/models/${MODEL_NAME}_${UNIX_EPOCH}.weights
#!/bin/bash
set -e

UNIX_EPOCH=$(date +%s)

# Get basename of the network file, since Darknet saves the weights as 'NetworkFileBaseName_final.weights'
NETWORK_FILENAME=${NETWORK_FILENAME##*/}
BASE_NAME=${NETWORK_FILENAME%.cfg}

echo "Uploading final weights to s3://${S3_BUCKET_NAME}/models/${BASE_NAME}_${UNIX_EPOCH}.weights"

aws s3 cp backup/${BASE_NAME}_final.weights s3://${S3_BUCKET_NAME}/models/${BASE_NAME}_${UNIX_EPOCH}.weights
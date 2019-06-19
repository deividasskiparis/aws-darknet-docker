# aws-darknet-yolo-docker
Nvidia based docker image with [Darknet](https://github.com/pjreddie/darknet) to train a [yolov3-tiny](https://pjreddie.com/darknet/yolo/) network on your custom images

Works seemlesly with AWS EC2 and S3

## Steps:
1. Create a S3 bucket on AWS
2. Upload images, train.txt and test.txt lists to the S3 bucket. 
Expected structure of the bucket
```
your-s3-bucket/
└── data/
    ├── train.txt
    ├── test.txt
    ├── images/
    |   ├── image-name-1.jpg
    |   ├── image-name-2.jpg
    |   └── ...
    └── labels/
        ├── image-name-1.txt
        ├── image-name-2.txt
        └── ...
``` 

`train.txt` and `test.txt` should contain image relative paths to the data/ folder in S3, ex.
```
data/images/image-name-1.jpg
data/images/image-name-2.jpg
```

3. Modify `coco.names`, `config.data` and `yolov3-tiny.cfg` as described by https://github.com/AlexeyAB/darknet#how-to-train-to-detect-your-custom-objects



4. Set up your EC2 instance
    1. Create a custom role in IAM settings for EC2, which allows access to your S3 bucket.
    2. Create a GPU instance on AWS which already has NVIDIA and CUDA pre-installed. Search for "Deep Learning" when choosing your instance AMI
    3. Ensure you set your created role as an IAM role of the instance
    4. SSH into the instance. [More info](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AccessingInstancesLinux.html)
    5. clone this repo
    ```
    git clone https://github.com/Scout24/social-turbo-ml.git aws-darknet-yolo-docker && cd aws-darknet-yolo-docker
    ```

5. Build docker image
```
docker build --build-arg S3=your-s3-bucket-name -t train-yolo .
```
6. Run image
```
docker run -d --name train-yolo train-yolo
```
NOTE: If running locally instead on EC2, you will have to provide AWS credentials to your docker container for a role, that has access to your S3 bucket
```
docker run -d --name train-yolo -e "AWS_ACCESS_KEY_ID=*********" -e "AWS_SECRET_ACCESS_KEY=*********" train-yolo
```

7. After the training is finished, the trained weights will be uploaded to you S3 bucket `/models` directory

8. Terminate your EC2 after the training is finished to avoid charges

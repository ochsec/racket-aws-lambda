#!/bin/bash

# Set variables
RACKET_VERSION="8.15"
REGION="us-east-1"
ACCOUNT_ID=$(aws sts get-login-password --region $REGION)
ECR_REPO="racket-lambda"
IMAGE_TAG="latest"

# Login to ECR
aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com

# Create ECR repository if not exists
aws ecr describe-repositories --repository-names $ECR_REPO || \
    aws ecr create-repository --repository-name $ECR_REPO

# Build Docker image
docker build -t $ECR_REPO:$IMAGE_TAG .

# Tag and push image
docker tag $ECR_REPO:$IMAGE_TAG $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$ECR_REPO:$IMAGE_TAG
docker push $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$ECR_REPO:$IMAGE_TAG

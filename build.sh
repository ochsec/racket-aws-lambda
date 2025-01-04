#!/bin/bash

# Set default variables
VERSION="1.0.0"
RACKET_VERSION="8.15"
REGION="us-east-1"
AWS_PROFILE="default"
ECR_REPO="racket-lambda"
IMAGE_TAG="latest"

# Parse command-line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -p|--profile) AWS_PROFILE="$2"; shift ;;
        -r|--region) REGION="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

# Use the specified AWS profile
ACCOUNT_ID=$(AWS_PROFILE=$AWS_PROFILE aws sts get-caller-identity --query Account --output text)

# Login to ECR using the specified profile
AWS_PROFILE=$AWS_PROFILE aws ecr get-login-password --region $REGION | \
    docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com

# Create ECR repository if not exists
AWS_PROFILE=$AWS_PROFILE aws ecr describe-repositories --repository-names $ECR_REPO || \
    AWS_PROFILE=$AWS_PROFILE aws ecr create-repository --repository-name $ECR_REPO

# Build Docker image
docker build -t $ECR_REPO:$IMAGE_TAG .

# Tag and push image
docker tag $ECR_REPO:$IMAGE_TAG $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$ECR_REPO:$IMAGE_TAG
AWS_PROFILE=$AWS_PROFILE aws ecr push $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$ECR_REPO:$IMAGE_TAG

#!/bin/bash

# Set default variables
VERSION="1.1.0"
RACKET_VERSION="8.15"
AWS_PROFILE="default"
ECR_REPO="racket-lambda"
IMAGE_TAG="latest"
HANDLER_FILE="${HANDLER_FILE:=lambda-handler.rkt}"

# Parse command-line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -p|--profile) AWS_PROFILE="$2"; shift ;;
        -P|--aws-profile) AWS_PROFILE="$2"; shift ;;
        -r|--region) REGION="$2"; shift ;;
        -R|--aws-region) REGION="$2"; shift ;;
        -f|--handler) HANDLER_FILE="$2"; shift ;;
        -H|--handler-file) HANDLER_FILE="$2"; shift ;;
        -n|--name) ECR_REPO="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

# Validate handler file
if [[ ! -f "$HANDLER_FILE" ]]; then
    echo "Error: Handler file '$HANDLER_FILE' not found."
    exit 1
fi

# Set default region if not specified
REGION="${REGION:-us-east-1}"

# Use the specified AWS profile
ACCOUNT_ID=$(AWS_PROFILE=$AWS_PROFILE aws sts get-caller-identity --query Account --output text)

# Validate and normalize the region
REGION=$(echo "$REGION" | tr '[:upper:]' '[:lower:]')

# Login to ECR using the specified profile (non-interactive)
AWS_PROFILE=$AWS_PROFILE aws ecr get-login-password --region $REGION | \
    docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com

# Create ECR repository if not exists
AWS_PROFILE=$AWS_PROFILE aws ecr describe-repositories --repository-names $ECR_REPO || \
    AWS_PROFILE=$AWS_PROFILE aws ecr create-repository --repository-name $ECR_REPO

# Build Docker image
docker build -t $ECR_REPO:$IMAGE_TAG .

# Tag and push image
docker tag $ECR_REPO:$IMAGE_TAG $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$ECR_REPO:$IMAGE_TAG
docker push $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$ECR_REPO:$IMAGE_TAG

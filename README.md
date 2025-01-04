# Racket AWS Lambda Container

## Purpose

This repository provides a containerized AWS Lambda runtime for Racket, enabling serverless function execution using the Racket programming language.

## Features

- Minimal Racket runtime container
- Structured logging compatible with AWS CloudWatch
- Extensible Lambda handler template
- Automated build and deployment scripts

## Prerequisites

- Docker
- AWS CLI
- AWS Account with ECR and Lambda permissions
- Racket development experience

## Usage

### Building the Container

1. Configure AWS credentials
2. Run the build script:
   ```bash
   ./build.sh
   ```

### Deploying to AWS Lambda

1. Use AWS CLI to create a Lambda function:
   ```bash
   aws lambda create-function \
       --function-name RacketLambdaFunction \
       --package-type Image \
       --code ImageUri=<your-ecr-image-uri> \
       --role <lambda-execution-role-arn> \
       --handler handle-event
   ```

### Customizing the Handler

Modify `lambda-handler.rkt` to implement your specific Lambda function logic.

## Contributing

Contributions are welcome. Please submit pull requests or open issues.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

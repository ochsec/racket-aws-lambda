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

## Version

Current version: 1.1.0

## Usage

### Building the Container

1. Configure AWS credentials
2. Create ECR repository (if not already exists):
   ```bash
   aws ecr create-repository --repository-name racket-lambda --region YOUR_REGION
   ```
   Note: Replace `YOUR_REGION` with your desired AWS region.

3. Run the build script with optional arguments:
   ```bash
   ./build.sh [-p|--profile PROFILE] [-r|--region REGION] [-h|--handler HANDLER_FILE]
   ```

   Arguments:
   - `-p, --profile`: AWS profile to use (default: "default")
   - `-r, --region`: AWS region for ECR repository (default: "us-east-1")
   - `-h, --handler`: Racket handler file to use (default: "lambda-handler.rkt")

   Examples:
   ```bash
   ./build.sh                  # Uses default profile, us-east-1, lambda-handler.rkt
   ./build.sh -p mycompany     # Uses mycompany profile, us-east-1, lambda-handler.rkt
   ./build.sh -r us-west-2     # Uses default profile, us-west-2, lambda-handler.rkt
   ./build.sh -h dynamic-handler.rkt  # Uses dynamic handler
   ./build.sh -p mycompany -r us-west-2 -h dynamic-handler.rkt  # Specifies all options
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

#### Installing Additional Racket Packages

In the Dockerfile, there's a commented-out line for installing Racket packages:
```dockerfile
# RUN raco pkg install --auto <your-packages-here>
```
To add external Racket packages:
1. Uncomment the line
2. Replace `<your-packages-here>` with the package name(s) you want to install
3. Rebuild the Docker image

Example:
```dockerfile
RUN raco pkg install --auto web-server
```

Two handler implementations are provided:

1. `lambda-handler.rkt`: A generic event handler with basic logging and error handling.
2. `dynamic-handler.rkt`: A homoiconic handler that allows dynamic code execution with strict sandboxing.

#### Dynamic Handler Usage Example

The `dynamic-handler.rkt` enables executing Racket code dynamically:

```json
{
  "program": "(lambda (x) (+ x 10))",
  "data": 5
}
```

This would return `15`. The handler provides:
- Secure code evaluation
- CPU and memory limits
- Structured logging
- Error handling

## Contributing

Contributions are welcome. Please submit pull requests or open issues.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

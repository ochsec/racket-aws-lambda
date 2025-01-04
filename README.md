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

Current version: 1.0.0

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

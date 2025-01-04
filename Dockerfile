# Use Amazon Linux 2 as base image
FROM amazonlinux:2

# Install dependencies
RUN yum update -y && \
    yum install -y wget tar gzip which gcc make

# Install Racket
ENV RACKET_VERSION=8.9
RUN wget https://download.racket-lang.org/releases/${RACKET_VERSION}/installers/racket-minimal-${RACKET_VERSION}-x86_64-linux-cs.tar.gz && \
    tar -xzf racket-minimal-${RACKET_VERSION}-x86_64-linux-cs.tar.gz -C /opt && \
    rm racket-minimal-${RACKET_VERSION}-x86_64-linux-cs.tar.gz

# Add Racket to PATH
ENV PATH="/opt/racket/bin:${PATH}"

# Install AWS Lambda Runtime Interface Client
RUN wget https://github.com/aws/aws-lambda-runtime-interface-emulator/releases/latest/download/aws-lambda-rie -O /usr/local/bin/aws-lambda-rie && \
    chmod +x /usr/local/bin/aws-lambda-rie

# Set working directory
WORKDIR /function

# Copy Lambda handler and dependencies
COPY lambda-handler.rkt .
COPY bootstrap .
RUN chmod 755 bootstrap

# Install any Racket package dependencies
RUN raco pkg install --auto <your-packages-here>

# Set the CMD to use the bootstrap script
CMD ["/function/bootstrap"]

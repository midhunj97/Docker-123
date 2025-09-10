# Base image
FROM ubuntu:20.04

# Set non-interactive frontend to avoid tzdata prompts
ENV DEBIAN_FRONTEND=noninteractive

# Create app directory with proper permissions
RUN mkdir -p /app /src && chmod 777 /app

# Define mount point
VOLUME ["/app"]

# Install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    wget \
    awscli \
    ca-certificates \
    gnupg \
    && rm -rf /var/lib/apt/lists/*

# Install MongoDB Database Tools
RUN wget https://fastdl.mongodb.org/tools/db/mongodb-database-tools-debian10-x86_64-100.7.0.deb --no-check-certificate && \
    apt install -y ./mongodb-database-tools-*.deb && \
    rm -f mongodb-database-tools-*.deb

# Copy script into container
WORKDIR /src
COPY create-mongodb-dump.sh /src/create-mongodb-dump.sh

# Normalize line endings (in case uploaded from Windows)
RUN sed -i 's/\r$//' /src/create-mongodb-dump.sh && \
    chmod +x /src/create-mongodb-dump.sh

# Run the script by default
CMD ["bash", "/src/create-mongodb-dump.sh"]

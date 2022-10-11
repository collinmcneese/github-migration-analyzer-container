ARG PLATFORM="linux/amd64"
ARG BASE_IMAGE="node:lts-alpine"

# Base image information
FROM --platform=${PLATFORM} ${BASE_IMAGE}

WORKDIR /app

# Dependencies
RUN apk add git bash --no-cache
RUN mkdir /log

# Clone Migration Analyzer
RUN \
    git clone https://github.com/github/gh-migration-analyzer.git

# Install Migration Analyzer
RUN \
    cd gh-migration-analyzer \
    && npm install

# copy the start.sh script & set permissions
COPY start.sh start.sh
RUN chmod +x start.sh

ENTRYPOINT ["bash", "./start.sh"]

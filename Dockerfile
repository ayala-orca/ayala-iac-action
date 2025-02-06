FROM ghcr.io/orcasecurity/orca-cli:1.84.0

RUN apk --no-cache --update add bash curl

# Set the Node.js version to install
ENV NODE_VERSION=22.11.0
ENV NODE_PACKAGE_URL=https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.xz

# Download and install Node.js from the specified URL
RUN curl -fsSL $NODE_PACKAGE_URL -o node.tar.xz && \
    mkdir -p /usr/local/lib/nodejs && \
    tar -xJf node.tar.xz -C /usr/local/lib/nodejs && \
    rm node.tar.xz

RUN apk --no-cache --update add npm

WORKDIR /app
# Docker tries to cache each layer as much as possible, to increase building speed.
# Therefore, commands which change rarely, must be in the beginning.
COPY package*.json ./
# Install dependencies using npm ci instead of npm install to avoid packages updating accidentally
RUN npm ci
# Copy the js source code to the image:
COPY ./src ./src

WORKDIR /
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]


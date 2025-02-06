FROM ghcr.io/orcasecurity/orca-cli:1
RUN apk add --no-cache sqlite sqlite-dev
RUN apk --no-cache --update add bash nodejs npm

# Set the Node.js version to install
ENV NODE_VERSION=20.18.2
ENV NODE_PACKAGE_URL=https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.xz

# Download and install Node.js from the specified URL
RUN curl -fsSL $NODE_PACKAGE_URL -o node.tar.xz && \
    mkdir -p /usr/local/lib/nodejs && \
    tar -xJf node.tar.xz -C /usr/local/lib/nodejs && \
    rm node.tar.xz

ENV PATH=/usr/local/lib/nodejs/node-v$NODE_VERSION-linux-x64/bin:$PATH

RUN node --version
RUN npm --version

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


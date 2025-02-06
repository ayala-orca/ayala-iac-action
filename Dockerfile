FROM ghcr.io/orcasecurity/orca-cli:1.84.0

RUN apk --no-cache --update add bash curl nodejs npm

# Install specific Node version using n
RUN npm install -g n
RUN n 22.11.0  # or your desired version

# Verify versions
RUN node --version
RUN npm --version

# If you need a specific npm version
RUN npm install -g npm@11.1.0  # or your desired npm version


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


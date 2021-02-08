# hadolint ignore=DL3007
FROM eafxx/ubuntu-base:latest
LABEL maintainer="https://github.com/elmerfdz"
ARG VERSION
SHELL ["/bin/bash", "-eo", "pipefail", "-c"]
# hadolint ignore=DL3018,DL3003,DL3008 
RUN \
 mkdir -p /install && \
 rm -rf /etc/apt/apt.conf.d/docker-gzip-indexes && \
 apt-get update && \
 DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      tzdata \
      curl \
      jq \
      iputils-ping \
      ruby-sass
ENV IS_DOCKER=true
ENV STATPING_DIR=/app
ENV PORT=8080    
WORKDIR /install
SHELL ["/bin/bash", "-eo", "pipefail", "-c"]
# hadolint ignore=DL3018,DL3003,DL3008,SC2086  
RUN \
   chmod +x /etc/s6/init/init-stage2 && \
   chmod +x /docker-mods && \
   MACHINE_ARCH="$(uname -m)" && \
   case "$MACHINE_ARCH" in \
       x86_64) export ARCH='amd64' ;; \
       armhf|arm|armv7l|armv7) export ARCH='arm-7' ;; \
       arm64|aarch64|armv8b|armv8l|aarch64_be) export ARCH='arm64' ;; \
   esac && \  
   VERSION=$(curl -s https://api.github.com/repositories/136770331/releases/latest | jq -r ".tag_name") && \
   curl -L -o statping-linux-"$ARCH".tar.gz https://github.com/statping/statping/releases/download/"$VERSION"/statping-linux-"$ARCH".tar.gz && \
   tar -xvzf statping-linux-"$ARCH".tar.gz && \
   chmod +x statping && \
   mv statping /usr/local/bin/statping && \
   rm -rf statping-linux-"$ARCH".tar.gz
COPY root/ /

WORKDIR /app
VOLUME /app
EXPOSE $PORT

HEALTHCHECK --interval=60s --timeout=10s --retries=3 CMD curl -s "http://localhost:$PORT/health" | jq -r -e ".online==true"

FROM lsiobase/ubuntu:bionic
LABEL maintainer="https://github.com/elmerfdz"
ARG VERSION
RUN rm -rf /etc/apt/apt.conf.d/docker-gzip-indexes \
 && apt-get update \
 && apt-get upgrade -y \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y \
      tzdata \
      curl \
      jq \
      ruby-sass \ 
      wget
#RUN curl -L -s https://assets.statping.com/sass -o /usr/local/bin/sass && \
#    chmod +x /usr/local/bin/sass
ENV IS_DOCKER=true
ENV STATPING_DIR=/app
ENV PORT=8080    
WORKDIR /app

RUN MACHINE_TYPE=$(uname -m); if [ "$MACHINE_TYPE" == "x86_64" ]; then ARCH="amd64"; elif [ "$MACHINE_TYPE" == "arm" ]; then ARCH="arm"; elif [ "$MACHINE_TYPE" == "arm64" ] || [ "$MACHINE_TYPE" == "aarch64" ] || [ "$MACHINE_TYPE" == "armv8b" ] || [ "$MACHINE_TYPE" == "armv8l" ] || [ "$MACHINE_TYPE" == "aarch64_be" ]; then ARCH="arm64"; else ARCH="386"; fi

RUN mkdir -p /install  && \
    VERSION=$(curl -s https://api.github.com/repositories/136770331/releases/latest | jq -r ".tag_name") && \
    wget https://github.com/statping/statping/releases/download/$VERSION/statping-linux-$ARCH.tar.gz -P "/install" -q --show-progress && \
    tar -xvzf /install/statping-linux-$ARCH.tar.gz -C /install && \
    chmod +x /install/statping && \
    mv /install/statping /usr/local/bin/statping
COPY root/ /

VOLUME /app
EXPOSE $PORT

HEALTHCHECK --interval=60s --timeout=10s --retries=3 CMD curl -s "http://localhost:$PORT/health" | jq -r -e ".online==true"
#CMD statping -port $PORT


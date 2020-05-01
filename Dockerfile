FROM ubuntu:eoan AS add-apt-repositories
RUN apt-get update \
 && apt-get upgrade -y \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y gnupg 

FROM ubuntu:eoan
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
RUN curl -L -s https://assets.statping.com/sass -o /usr/local/bin/sass && \
    chmod +x /usr/local/bin/sass
ENV IS_DOCKER=true
ENV STATPING_DIR=/app
ENV PORT=8080    
WORKDIR /app
RUN mkdir -p /install  && \
    curl -o- -L https://statping.com/install.sh | bash
RUN statping version 
#COPY root/ /

VOLUME /app
EXPOSE $PORT

HEALTHCHECK --interval=60s --timeout=10s --retries=3 CMD curl -s "http://localhost:$PORT/health" | jq -r -e ".online==true"
CMD statping -port $PORT
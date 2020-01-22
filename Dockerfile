FROM eafxx/alpine-base
LABEL maintainer="https://github.com/elmerfdz"
ARG VERSION
RUN apk --no-cache add curl jq libsass wget tzdata libsass
RUN curl -L -s https://assets.statping.com/sass -o /usr/local/bin/sass && \
    chmod +x /usr/local/bin/sass
ENV IS_DOCKER=true
ENV STATPING_DIR=/app
ENV PORT=8080

COPY root/ /

WORKDIR /app
VOLUME /app
EXPOSE $PORT

HEALTHCHECK --interval=60s --timeout=10s --retries=3 CMD curl -s "http://localhost:$PORT/health" | jq -r -e ".online==true"
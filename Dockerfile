# syntax=docker/dockerfile:1@sha256:4edf897a3ffa55b89f906fc8cc78afdb3f1834cc9c7083565e611a8a7d5fe99e
FROM wordpress:7.1.4-php8.5-fpm-alpine@sha256:e3f07024c3576abb0b591e2bb9504032e7fa0783f6e39837f4d9843736ac59e2

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

RUN set -eux; \
    apk add --no-cache --virtual .build-deps $PHPIZE_DEPS; \
    docker-php-ext-install -j "$(nproc)" pdo_mysql; \
    apk del --no-network .build-deps

USER www-data

HEALTHCHECK --interval=1m --timeout=10s --start-period=1m --retries=3 \
    CMD php-fpm -t || exit 1

ARG WORDPRESS_VERSION

FROM wordpress:${WORDPRESS_VERSION:-6}

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    vim msmtp

RUN pecl install xdebug \
    && docker-php-ext-enable xdebug

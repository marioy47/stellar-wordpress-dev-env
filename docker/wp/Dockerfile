ARG WORDPRESS_VERSION

FROM wordpress:${WORDPRESS_VERSION:-fpm}

# Install aditional software
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    vim msmtp

# Install PHP Composer.
RUN curl -s https://getcomposer.org/installer | php \
	&& mv composer.phar /usr/local/bin/composer

RUN pecl install xdebug \
    && docker-php-ext-enable xdebug

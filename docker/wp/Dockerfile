ARG WORDPRESS_VERSION

FROM wordpress:${WORDPRESS_VERSION:-fpm}

# Install aditional software
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    vim msmtp unzip

# Install PHP Composer.
RUN curl -s https://getcomposer.org/installer | php \
	&& mv composer.phar /usr/local/bin/composer \
    && echo 'export PATH=$(composer global config bin-dir --absolute --quiet):$PATH' >> /etc/bash.bashrc


# Install and enable Xdebug on port 9003
RUN pecl install xdebug \
    && docker-php-ext-enable xdebug

#!/bin/bash

# Script to install WordPress in a multisite configuration

URL="https://${LANDO_APP_NAME}.lndo.site"

if [ ! -f ${LANDO_WEBROOT}/index.php ]; then
    wp core download --path=${LANDO_WEBROOT}
fi

if [ ! -f ${LANDO_WEBROOT}/wp-config.php ]; then
    sleep 10
    wp config create --path=${LANDO_WEBROOT} --dbhost=database.${LANDO_APP_NAME}.internal --dbname=wordpress --dbuser=wordpress --dbpass=wordpress --extra-php <<PHP
/* Lando custom config */
define( 'WP_DEBUG', true );
define( 'SCRIPT_DEBUG', true);
define( 'LEARNDASH_DEBUG', true );
define( 'LEARNDASH_SCRIPT_DEBUG', true );
define( 'LEARNDASH_BUILDER_DEBUG', true );
define( 'WP_DEBUG_DISPLAY', true );
define( 'WP_DEBUG_LOG', '/tmp/wordpress/wordpress.log' );
define( 'WP_REDIS_HOST', 'redis.${LANDO_APP_NAME}.internal' );
PHP
fi

wp --path=${LANDO_WEBROOT} core multisite-install --subdomains --title="${LANDO_APP_PROJECT}" --admin_user=admin --admin_password=password --admin_email=admin@example.com --skip-email --url="$URL"
wp --path=${LANDO_WEBROOT} plugin install redis-cache --activate
wp --path=${LANDO_WEBROOT} redis enable
wp --path=${LANDO_WEBROOT} rewrite structure '/%year%/%monthnum%/%postname%/' --hard

echo "Go to $URL/wp-admin/ with User admin and password password"

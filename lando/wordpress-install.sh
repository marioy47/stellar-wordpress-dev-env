#!/bin/bash


URL="https://${LANDO_APP_NAME}.lndo.site"

if [ ! -f ${LANDO_WEBROOT}/index.php ]; then
    wp core download --path=${LANDO_WEBROOT}
fi

if [ ! -f ${LANDO_WEBROOT}/wp-config.php ]; then
    sleep 10
    wp config create --path=${LANDO_WEBROOT} --dbhost=database.${LANDO_APP_NAME}.internal --dbname=wordpress --dbuser=wordpress --dbpass=wordpress
    wp core multisite-install --path=${LANDO_WEBROOT} --subdomains --title="${LANDO_APP_PROJECT}" --admin_user=admin --admin_password=password --admin_email=admin@example.com --skip-email --url="$URL"
fi

echo "Go to $URL/wp-admin/ with User admin and password password"

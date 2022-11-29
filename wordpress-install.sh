sleep 10
URL="https://${LANDO_APP_NAME}.lndo.site"
wp core download --path=${LANDO_WEBROOT}
wp config create --path=${LANDO_WEBROOT} --dbhost=database.${LANDO_APP_NAME}.internal --dbname=wordpress --dbuser=wordpress --dbpass=wordpress
wp core multisite-install --path=${LANDO_WEBROOT} --subdomains --title="${LANDO_APP_PROJECT}" --admin_user=admin --admin_password=password --admin_email=admin@example.com --skip-email --url="$URL"
echo "Go to $URL/wp-admin/ with User admin and password password"

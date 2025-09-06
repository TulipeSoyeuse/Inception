#!/bin/bash

if [ -f ./wp-config.php ]
then
	echo "wp-config already exist"
else
    cp wp-config-sample.php wp-config.php
    sed -i "s/username_here/$db_user/g" wp-config.php
    sed -i "s/password_here/$db_pwd/g" wp-config.php
    sed -i "s/localhost/mariadb:3306/g" wp-config.php
    sed -i "s/database_name_here/$db_name/g" wp-config.php

    curl "https://api.wordpress.org/secret-key/1.1/salt/" -sSo salts
    csplit wp-config.php '/AUTH_KEY/' '/NONCE_SALT/+1'
    cat xx00 salts xx02 > wp-config.php
	rm salts xx00 xx01 xx02
    sed -i "s/define( 'WP_DEBUG', true );/define( 'WP_DEBUG_LOG', true );/g" wp-config.php
    sed -i "/That's all, stop editing/i define('WP_HOME','https://rdupeux.42.fr');\ndefine('WP_SITEURL','https://rdupeux.42.fr');" wp-config.php

fi

# wp core install --allow-root \
#                     --path=/var/www/inception.site \
#                     --url=inception.com \
#                     --title=Inception \
#                     --admin_user=$WP_USER1 \
#                     --admin_password=$WP_USER1_PSWD \
#                     --admin_email=info@example.com \
#                     --skip-email

exec "$@"

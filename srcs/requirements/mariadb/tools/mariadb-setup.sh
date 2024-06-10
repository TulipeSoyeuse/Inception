#!/bin/bash
mysql_install_db
service mariadb start
mariadb -e "CREATE USER IF NOT EXISTS wordpress_db_user@'%' IDENTIFIED BY '${db_pwd}';"
mariadb -e "GRANT ALL ON *.* TO root@'localhost';"
#mariadb -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${ROOT_MARIADB_PWD}';" && \
#mariadb -u root -p$ROOT_MARIADB_PWD -e "FLUSH PRIVILEGES;"

if [ -d "/var/lib/mysql/$db_name" ]; then
    echo "database exist"
else
    mariadb -e  "CREATE DATABASE IF NOT EXISTS $db_name; 
                GRANT ALL ON $db_name.* TO '$db_user'@'%' IDENTIFIED BY '$db_pwd'; 
                FLUSH PRIVILEGES;"

    mariadb $db_name < /setup/wordpress.sql
fi

mysqladmin shutdown
mysqld
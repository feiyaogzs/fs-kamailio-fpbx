#!/bin/bash

# Set environment variables
DB_HOST=${DB_HOST:-localhost}
DB_PORT=${DB_PORT:-5432}
DB_NAME=${DB_NAME:-fusionpbx}
DB_USERNAME=${DB_USERNAME:-fusionpbx}
DB_PASSWORD=${DB_PASSWORD:-fusionpbx}

ADMIN_USERNAME=${ADMIN_USERNAME:-admin}
ADMIN_PASSWORD=${ADMIN_PASSWORD:-adminpass}
DOMAIN_NAME=${DOMAIN_NAME:-example.com}

FS_HOST=${FS_HOST:-localhost}

# Set the FusionPBX database configuration in the database initializing file
sed -i "s|{admin_username}|${ADMIN_USERNAME}|" /var/www/fusionpbx/db-init.php
sed -i "s|{admin_password}|${ADMIN_PASSWORD}|" /var/www/fusionpbx/db-init.php
sed -i "s|{domain_name}|${DOMAIN_NAME}|" /var/www/fusionpbx/db-init.php
sed -i "s|{database_host}|${DB_HOST}|" /var/www/fusionpbx/db-init.php
sed -i "s|{database_port}|${DB_PORT}|" /var/www/fusionpbx/db-init.php
sed -i "s|{database_name}|${DB_NAME}|" /var/www/fusionpbx/db-init.php
sed -i "s|{database_username}|${DB_USERNAME}|" /var/www/fusionpbx/db-init.php
sed -i "s|{database_password}|${DB_PASSWORD}|" /var/www/fusionpbx/db-init.php

# Update FS directories permissions
/bin/chmod -R 777 /etc/freeswitch
/bin/chmod -R 777 /usr/local/freeswitch/sounds
/bin/chmod -R 777 /var/lib/freeswitch/db
/bin/chmod -R 777 /var/lib/freeswitch/recordings
/bin/chmod -R 777 /var/lib/freeswitch/storage
/bin/chmod -R 777 /usr/share/freeswitch/scripts

# Initialize the FusionPBX database
/usr/local/bin/php /var/www/fusionpbx/db-init.php

echo "switch.event_socket.host = $FS_HOST" >> /etc/fusionpbx/config.conf
sed -i 's/^error.reporting = user$/error.reporting = all/' /etc/fusionpbx/config.conf

# Start web server
exec apache2-foreground

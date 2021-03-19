#!/bin/bash

BASE_DOC_ROOT="/var/www"

if [ -z "$1" ]; then
  echo "Enter New Site Domain :"
  read
  DOMAIN_NAME="$REPLY"
else
  DOMAIN_NAME="$1"
fi

if [ -d "${BASE_DOC_ROOT}/${DOMAIN_NAME}" ]; then
  echo "Doc Root Already Exists"
else
  # Create Required Folders & Update Permissions
  mkdir -p "${BASE_DOC_ROOT}/${DOMAIN_NAME}/public"
  mkdir -p "${BASE_DOC_ROOT}/${DOMAIN_NAME}/logs"
fi

# Update Folder Permission
sudo find "${BASE_DOC_ROOT}/${DOMAIN_NAME}" -type d -exec chmod 750 {} \;
sudo find "${BASE_DOC_ROOT}/${DOMAIN_NAME}" -type f -exec chmod 640 {} \;
chown -R www-data:www-data "${BASE_DOC_ROOT}/${DOMAIN_NAME}"

# Create Apache Config
APACHE_CONFIG="/etc/apache2/sites-available/${DOMAIN_NAME}.conf"
touch "$APACHE_CONFIG"
echo "UseCanonicalName On

<VirtualHost *:80>
        ServerAdmin \"webmaster@${DOMAIN_NAME}\"
        ServerName \"${DOMAIN_NAME}\"
        DocumentRoot \"${BASE_DOC_ROOT}/${DOMAIN_NAME}/public\"

        <Directory \"${BASE_DOC_ROOT}/${DOMAIN_NAME}/public\">
            Options Indexes FollowSymLinks
            AllowOverride All
            Require all granted
        </Directory>

        ErrorLog \"${BASE_DOC_ROOT}/${DOMAIN_NAME}/logs/error.log\"
        CustomLog \"${BASE_DOC_ROOT}/${DOMAIN_NAME}/logs/access.log\" combined

        <IfModule mod_dir.c>
            DirectoryIndex index.php index.pl index.cgi index.html index.xhtml index.htm
        </IfModule>
</VirtualHost>
" >$APACHE_CONFIG

# Enable Apache Site
sudo a2ensite "${DOMAIN_NAME}.conf"

# Restart Apache
echo "Restarting Apache"
sudo service apache2 restart
echo "Done."

# Creating SSL
certbot --apache -d "${DOMAIN_NAME}"

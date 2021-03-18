#!/bin/bash
BASE_DOC_ROOT="/var/www"
DEMO_TEMPLATE="${BASE_DOC_ROOT}/template.sva.one"
MYSQL_CREDS="${BASE_DOC_ROOT}/global-files/database-server.ini"

echo "Demo Instance Slug :"
read
DEMO_SLUG=$REPLY
DOMAIN_NAME="${DEMO_SLUG}.sva.one"

# Create Required Folders & Update Permissions
echo "Copying Template WP To Domain WP - $DOMAIN_NAME"
cp -r "${DEMO_TEMPLATE}/*" "${BASE_DOC_ROOT}/${DOMAIN_NAME}/"
rm -rf "${BASE_DOC_ROOT}/${DOMAIN_NAME}/logs"
mkdir -p "${BASE_DOC_ROOT}/${DOMAIN_NAME}/logs"

# Creating Apache Config
bash ./apache-vhost.sh "$DOMAIN_NAME"

# Creating Database
echo "Creating Database"
php ./php/create-db.php "$DOMAIN_NAME"

#DB_HOST=$(awk -F "=" '/HOST/ {print $2}' database-server.ini)
#DB_USER=$(awk -F "=" '/USER/ {print $2}' database-server.ini)
#DB_PASS=$(awk -F "=" '/PASS/ {print $2}' database-server.ini)

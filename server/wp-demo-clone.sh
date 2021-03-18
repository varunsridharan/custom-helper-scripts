#!/bin/bash
BASE_DOC_ROOT="/var/www"
DEMO_TEMPLATE="${BASE_DOC_ROOT}/template.sva.one"
DEMO_TEMPLATE_DB="wpdemos_template"
MYSQL_CREDS="${BASE_DOC_ROOT}/global-files/database-server.ini"
FILE=db.`date +"%Y%m%d-%H%M%S"`.sql

echo "Demo Instance Slug :"
read
DEMO_SLUG=$REPLY
DOMAIN_NAME="${DEMO_SLUG}.sva.one"

# Create Required Folders & Update Permissions
echo "Copying Template WP To Domain WP - $DOMAIN_NAME"
cp -r "${DEMO_TEMPLATE}/" "${BASE_DOC_ROOT}/${DOMAIN_NAME}/"
rm -rf "${BASE_DOC_ROOT}/${DOMAIN_NAME}/logs"
mkdir -p "${BASE_DOC_ROOT}/${DOMAIN_NAME}/logs"

# Creating Apache Config
bash ./apache-vhost.sh "$DOMAIN_NAME"

# Creating Database
echo "Creating Database"
#php ./php/create-db.php "$DOMAIN_NAME"
DB_HOST=$(awk -F "=" '/HOST/ {print $2}' "$MYSQL_CREDS")
DB_USER=$(awk -F "=" '/USER/ {print $2}' "$MYSQL_CREDS")
DB_PASS=$(awk -F "=" '/PASS/ {print $2}' "$MYSQL_CREDS")
TO_DATABASE=$(php ./php/getdbname.php "$DOMAIN_NAME")
echo "Copying Database from $DEMO_TEMPLATE_DB => $TO_DATABASE"
#mysqldump --opt --user=$DB_USER --password=$DB_PASS --host=$DB_HOST "$DEMO_TEMPLATE_DB" > $FILE

#!/bin/bash
BASE_DOC_ROOT="/var/www"
DEMO_TEMPLATE_DOMAIN="template.sva.one"
DEMO_TEMPLATE="${BASE_DOC_ROOT}/${DEMO_TEMPLATE_DOMAIN}"
DEMO_TEMPLATE_DB="wpdemos_template"
MYSQL_CREDS="${BASE_DOC_ROOT}/helpers/database-server.ini"
FILE=db.`date +"%Y%m%d-%H%M%S"`.sql

echo " "
echo "WordPress Demo Instance Product Slug ?"
read
DEMO_SLUG=$REPLY
DOMAIN_NAME="${DEMO_SLUG}.sva.one"

#############################
### Creating Database     ###
#############################
echo " "
echo "Creating Database"
echo " "
DB_HOST=$(awk -F "=" '/HOST/ {print $2}' "$MYSQL_CREDS")
DB_USER=$(awk -F "=" '/USER/ {print $2}' "$MYSQL_CREDS")
DB_PASS=$(awk -F "=" '/PASS/ {print $2}' "$MYSQL_CREDS")
TO_DATABASE=$(php ./php/getdbname.php "$DOMAIN_NAME")

mysql --user=$DB_USER --password=$DB_PASS --host=$DB_HOST -e "CREATE DATABASE IF NOT EXISTS $TO_DATABASE"

echo " "
echo "Copying Template Database"
echo " "

mysqldump --opt --user=$DB_USER --password=$DB_PASS --host=$DB_HOST "$DEMO_TEMPLATE_DB" > $FILE
echo "Updating Domain Name in SQL"
sed -i -e "s/${DEMO_TEMPLATE_DOMAIN}/${DOMAIN_NAME}/g" "$FILE"
mysql --user=$DB_USER --password=$DB_PASS --host=$DB_HOST "$TO_DATABASE" < $FILE
rm -rf $FILE
##########################################################
######### Copying & Updating File Permission     #########
##########################################################
echo " "
echo "Copying WordPress Instance"
echo " "
cp -r "${DEMO_TEMPLATE}/" "${BASE_DOC_ROOT}/${DOMAIN_NAME}/"
rm -rf "${BASE_DOC_ROOT}/${DOMAIN_NAME}/logs"
mkdir -p "${BASE_DOC_ROOT}/${DOMAIN_NAME}/logs"
sed -i -e "s/${DEMO_TEMPLATE_DOMAIN}/${DOMAIN_NAME}/g" "${BASE_DOC_ROOT}/${DOMAIN_NAME}/public/wp-config.php"

##########################################################
######### Creating Apache Config     #########
##########################################################
bash ./apache-vhost.sh "$DOMAIN_NAME"
echo " "

echo "###############################################################"
echo "Site URL : https://${DOMAIN_NAME}"
echo "Database Name : ${TO_DATABASE}"
echo "Site ROOT Path: ${BASE_DOC_ROOT}/${DOMAIN_NAME}/public"
echo "###############################################################"
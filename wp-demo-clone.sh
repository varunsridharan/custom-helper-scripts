#!/bin/bash

echo "Demo Instance Slug :"
read
DEMO_TEMPLATE="/var/www/template.sva.one"
DEMO_SLUG=$REPLY
DOMAIN_DOMAIN="${DEMO_SLUG}.sva.one"

# Create Required Folders & Update Permissions
mkdir -p "${BASE_DOC_ROOT}/${DOMAIN_NAME}/"
sudo cp "${DEMO_TEMPLATE}/*" "${BASE_DOC_ROOT}/${DOMAIN_NAME}/"
rm -rf "${BASE_DOC_ROOT}/${DOMAIN_NAME}/logs"
mkdir -p "${BASE_DOC_ROOT}/${DOMAIN_NAME}/logs"

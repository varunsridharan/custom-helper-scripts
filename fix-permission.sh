#!/bin/bash

if [ -z "$1" ]; then
  echo "Provide A Valid Path"
else
  VALID_PATH="$1"
  # Update Folder Permission
  sudo find "${VALID_PATH}" -type d -exec chmod 750 {} \;
  sudo find "${VALID_PATH}" -type f -exec chmod 640 {} \;
  chown -R www-data:www-data "${VALID_PATH}"
fi

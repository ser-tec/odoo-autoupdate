#!/bin/bash

dir=$(dirname $0)
cd $dir

# Import configuration file
. update.conf

# Folders list
DEFAULT_FOLDERS="$ODOO_PATH/addons,$ODOO_PATH/odoo/addons"
OCA_FOLDER=$(ls -d $OCA_FOLDER/* 2>/dev/null)
GIT_ADDONS_FOLDERS=${GIT_ADDONS_FOLDERS[@]}
OTHER_FOLDERS=${OTHER_FOLDERS[@]}

# Format the folders list
OCA_FOLDER=$(echo "$OCA_FOLDER" | tr ' ' ',')
GIT_ADDONS_FOLDERS=$(echo "$GIT_ADDONS_FOLDERS" | tr ' ' ',')
OTHER_FOLDERS=$(echo "$OTHER_FOLDERS" | tr ' ' ',')
ALL_FOLDERS="$OTHER_FOLDERS,$GIT_ADDONS_FOLDERS,$DEFAULT_FOLDERS,$OCA_FOLDER"

# remove possible comma error
ALL_FOLDERS=$(echo "$ALL_FOLDERS" | tr -s ',')

# Write ALL_FOLDERS on autoupdate.conf for updateDB.sh use
sed -i "s|ALL_FOLDERS=.*|ALL_FOLDERS=$ALL_FOLDERS|" "autoupdate.conf"

# Error checking
if [ $? -ne 0 ]; then
  echo "Error writing file" >&2
  exit 1
fi
echo "The folder list was successfully written to the file autoupdate.conf"

# rewrite variable for better readability
ALL_FOLDERS=${ALL_FOLDERS//,/,\\n    }

# rewrite variable with end delimitator for future update
ALL_FOLDERS+="\n# end addons"

# Update the file specified in output_file
sed -i '/addons_path = /,/# end addons/c\addons_path = '"$ALL_FOLDERS"'' "$ODOO_CONF"

# Error checking
if [ $? -ne 0 ]; then
  echo "Error writing file" >&2
  exit 1
fi

echo "The folder list was successfully written to the file $ODOO_CONF"

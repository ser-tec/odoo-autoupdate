#!/bin/bash

dir=$(dirname $0)
cd $dir
echo $PWD

# Import configuration file
. update.conf

echo $OCA_FOLDER
echo "###"

# Folders list
DEFAULT_FOLDERS="$ODOO_PATH/addons,$ODOO_PATH/odoo/addons"
OCA_FOLDER1=$(ls -d $OCA_FOLDER/* 2>/dev/null)
GIT_ADDONS_FOLDERS=${GIT_ADDONS_FOLDERS[@]}
OTHER_FOLDERS=${OTHER_FOLDERS[@]}
echo $OCA_FOLDER1
echo "###"
# Format the folders list
OCA_FOLDER2=$(echo "$OCA_FOLDER1" | tr '\n' ',')
GIT_ADDONS_FOLDERS=$(echo "$GIT_ADDONS_FOLDERS" | tr ' ' ',')
OTHER_FOLDERS=$(echo "$OTHER_FOLDERS" | tr ' ' ',')
ALL_FOLDERS="$OTHER_FOLDERS,$GIT_ADDONS_FOLDERS,$DEFAULT_FOLDERS,$OCA_FOLDER"

echo $OCA_FOLDER2

# remove possible comma error
ALL_FOLDERS=$(echo "$ALL_FOLDERS" | tr -s ',')

#echo $ALL_FOLDERS
echo "sto per scrivere 1"
# Write ALL_FOLDERS on update.conf for update_db.sh use
sed -i "s|ALL_FOLDERS=.*|ALL_FOLDERS=$ALL_FOLDERS|" "update.conf"
echo "scritto update.conf"

# Error checking
if [ $? -ne 0 ]; then
  echo "Error writing file" >&2
  exit 1
fi
echo "The folder list was successfully written to the file update.conf"

# rewrite variable for better readability
ALL_FOLDERS=${ALL_FOLDERS//,/,\\n    }

# rewrite variable with end delimitator for future update
ALL_FOLDERS+="\n# end addons"

echo "sto per scrivere 2"
# Update the file specified in output_file
sed -i '/addons_path = /,/# end addons/c\addons_path = '"$ALL_FOLDERS"'' "$ODOO_CONF"

# Error checking
if [ $? -ne 0 ]; then
  echo "Error writing file" >&2
  exit 1
fi
echo "The folders list was successfully written to the file $ODOO_CONF"

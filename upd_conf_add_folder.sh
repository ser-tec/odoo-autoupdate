#!/bin/bash

dir=$(dirname $0)
cd $dir

# Import the configuration file
. autoupdate.conf

# Folder list
#var_folders=("${CUSTOM_FOLDERS[@]}")
#variable_folders=$(ls -d $var_folders/* 2>/dev/null)

variable_folders=${CUSTOM_FOLDERS[@]}
variable_folders2=$(ls -d $OCA_FOLDER/* 2>/dev/null)

# Error checking
if [ $? -ne 0 ]; then
  echo "Error generating folder list" >&2
  exit 1
fi

# Format the folder list
FIX_FOLDERS=$(echo "$FIX_FOLDERS" | tr '\n' ',')
variable_folders=$(echo "$variable_folders" | tr '\n' ',')
variable_folders2=$(echo "$variable_folders2" | tr '\n' ',')
formatted_folders="$FIX_FOLDERS,$variable_folders,$variable_folders2"

# formatted_folders=$(echo "$FIX_FOLDERS,$variable_folders,$variable_folders2" | tr '\n' ',')

# Remove the last comma
formatted_folders=${formatted_folders%,}

# Update the file specified in output_file
sed -i "s|addons_path = .*|addons_path = $formatted_folders|" "$ODOO_CONF"

# Write formatted_folders on autoupdate.conf becouse after it will be called by updateDB.sh 
sed -i "s|formatted_folders=.*|formatted_folders=$formatted_folders|" "autoupdate.conf"

# Error checking
if [ $? -ne 0 ]; then
  echo "Error writing file" >&2
  exit 1
fi

echo "The folder list was successfully written to the file $ODOO_CONF"

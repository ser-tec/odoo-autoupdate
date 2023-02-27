#!/bin/bash

dir=$(dirname $0)
cd $dir

# Import the configuration file
. autoupdate.conf

var_folders=("${CUSTOM_FOLDERS[@]}")
variable_folders=$(ls -d $var_folders/* 2>/dev/null)

# loop through all folders in $CUSTOM_FOLDER
for folder in $variable_folders; do
    echo "Updating folder: $folder"
    cd "$folder"
    git checkout || true
    git pull
done

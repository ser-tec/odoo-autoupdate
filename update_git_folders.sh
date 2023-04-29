#!/bin/bash

dir=$(dirname "$0")
cd "$dir"

# Import the configuration file
. update.conf

# loop through all folders in $GIT_ADDONS_FOLDERS
for i in "${GIT_ADDONS_FOLDERS[@]}"; do
  echo "Updating folder: $i"
  cd "$i"
  git checkout || true
  git pull
  cd "$dir"
done

#!/bin/bash

dir=$(dirname $0)
cd $dir

# Import the configuration file
. update.conf

cd "$VENV/.."

# Get into python virtualization
source "$VENV/bin/activate"
echo virtual enviroment attivo

if [ "$SKIP_REQ" = "False" ]; then
  if [ -n "$REQUIREMENTS" ]; then
    echo REQUIREMENTS non vuoto $REQUIREMENTS
    for dir in $(echo "$REQUIREMENTS" | tr ',' '\n'); do
      if [ -d "$dir" ]; then
        if [ -f "$dir/requirements.txt" ]; then
          echo -e "Installing packages from $dir/requirements.txt\n"
          pip3 install -r "$dir/requirements.txt"
          echo -e "\n"
        else
          echo -e "Skipping $dir (no requirements.txt found)\n"
        fi
      else
        echo -e "Skipping $dir (not a directory)\n"
      fi
    done
  else
    echo REQUIREMENTS vuoto $REQUIREMENTS
    for dir in $(echo "$ALL_FOLDERS" | tr ',' '\n'); do
      if [ -d "$dir" ]; then
        if [ -f "$dir/requirements.txt" ]; then
          echo -e "Installing packages from $dir/requirements.txt\n"
          pip3 install -r "$dir/requirements.txt"
          echo -e "\n"
        else
          echo -e "Skipping $dir (no requirements.txt found)\n"
        fi
      else
        echo -e "Skipping $dir (not a directory)\n"
      fi
    done
  fi
fi

for db in "${DB_NAME[@]}"; do
  echo "$ODOO_PATH/odoo-bin -c $ODOO_CONF -d $db -u all --stop-after-init"
  $ODOO_PATH/odoo-bin -c "$ODOO_CONF" -d "$db" -u all --stop-after-init

  if [ $? = 0 ]; then
    echo "DB correctly updated: $db"
  else
    echo "DB error update: $db"
  fi

# deactivate python virtual enviroment
deactivate

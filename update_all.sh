#!/bin/bash
################################################################################
# Script for update odoo and all the addons contained in OCA.
# Author: Grando Giulio
#-------------------------------------------------------------------------------
# git clone https://github.com/ser-tec/odoo-autoupdate2.git
# makes the file executable:
# sudo chmod +x autoupdate.sh
# Execute the script to update Odoo:
# ./autoupdate.sh
################################################################################

dir=$(dirname $0)
cd $dir

# Import the configuration file
. update.conf

# Create a log file and open it for writing
log_file="$LOGFILE$(date +"%Y-%m-%d_%H-%M-%S").log"
exec > >(tee -i $log_file)

var_list=("ODOO_VERS" "ODOO_PATH" "ODOO_SERVICE" "ODOO_USER" "ODOO_CONF" "VENV" "DB_NAME" "LOGFILE" "OCA_FOLDER")

    for var in "${var_list[@]}"
    do
        if [ -z "${!var}" ]
        then
            echo "La variabile $var non è stata impostata. Si prega di impostare la variabile prima di eseguire lo script."
            exit 1
        fi
    done

# Stop the odoo service (as super user)
if sudo /bin/systemctl stop $ODOO_SERVICE.service; then
  echo "Odoo service stopped successfully"
else
  echo "Failed to stop Odoo service"
fi

# Update OCA (AS ODOO USER)
echo --------------------
echo Start Update OCA
echo --------------------
su - $ODOO_USER -s /bin/bash $dir/update_OCA.sh

# Update GIT_FOLDERS (AS ODOO USER)
echo --------------------
echo Start Update GIT_FOLDERS
echo --------------------
su - $ODOO_USER -s /bin/bash $dir/update_git_folders.sh

# Update ODOO (AS ODOO USER)
echo --------------------
echo Start Update ODOO
echo --------------------
su - $ODOO_USER -s /bin/bash $dir/update_odoo.sh

# Update addons list on conf odoo (as super user )
echo --------------------
echo Start Update addons list
echo --------------------
sudo $dir/update_addons_path.sh

# Update DB (AS ODOO USER)
echo --------------------
echo Start Update DB
echo --------------------
su - $ODOO_USER -s /bin/bash $dir/update_DB.sh
echo --------------------

# Riavvio il servizio odoo (as super user )
if sudo /bin/systemctl start $ODOO_SERVICE.service; then
  echo "Odoo service started successfully"
else
  echo "Failed to start Odoo service"
fi
echo --------------------

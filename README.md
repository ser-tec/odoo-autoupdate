# Odoo-autoupdate
These collection of scripts allows you to update odoo and all the addons contained in OCA.

```update_all.sh``` -> it runs the other scripts in the right order. It Stop the odoo service during the update process and restart after finish<br/>
```update_oca.sh``` -> it download the new modules contained in the OCA repository and update the existing ones skipping those specified in the exclude_folder parameter.<br/>
```update_addons_path.sh``` -> it writes the list of addons in the odoo configuration file <br/>
```update_odoo.sh``` -> it update odoo<br/>
```update_db.sh``` -> it install dependencies and update the database<br/>
```update_git_folders.sh``` -> it update folders that can be update by git
WARNING : 
* THE SCRIPT DOESN'T MAKE A BACKUP
* GH must be installed and it is necessary to have done a first authentication with token


## Prerequisites 
* ubuntu
* odoo installed from source
* odoo configuration file need to be modified with "# end addons" after addon_path list

## Installation

```
$ git clone https://github.com/ser-tec/odoo-autoupdate.git
$ cd odoo-autoupdate
$ sudo chmod u+x *.sh
```

## Settings

Define your own parameters in autoupdate.conf
```
$ nano update.conf
```

## Scheduling
* Edit cron:
```
$ sudo crontab -e
```
* Add the following entries. Save and exit.<br/> 
Help for scheduling https://crontab.guru/
```
00 0 * * * /path-odoo-autoupdate/update_all.sh
```

## Manual Execution
```
$ ./path-odoo-autoupdate/update_all.sh 
```

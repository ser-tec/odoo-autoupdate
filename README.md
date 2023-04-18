# Odoo-autoupdate
These collection of scripts allows you to update odoo and all the addons contained in OCA.
you can use singly or toghether.

```update_all.sh``` -> it runs the other scripts in the right order. It Stop the odoo service during the update process and restart after finish<br/>
```update_oca.sh``` -> it download the new modules contained in the OCA repository and update the existing ones skipping those specified in the exclude_folder parameter.<br/>
```update_addons_path.sh``` -> it writes the list of addons in the odoo configuration file <br/>
```update_odoo.sh``` -> it update odoo<br/>
```update_db.sh``` -> it install dependencies and update the database<br/>
```update_git_folders.sh``` -> it update folders that can be update by git
WARNING : 
* THE SCRIPT DOESN'T MAKE A BACKUP
* for the OCA update GitHub CLI must be installed 
https://github.com/cli/cli/blob/trunk/docs/install_linux.md

## Prerequisites 
* ubuntu
* odoo installed from source
* odoo configuration file need to be modified with "# end addons" after addon_path list

## Dependencies

```
$ type -p curl >/dev/null || (sudo apt update && sudo apt install curl -y)
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
&& sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
&& sudo apt update \
&& sudo apt install gh -y
```

if you don't have a github account token
```
gh config set -h github.com git_protocol https
```
else 
```
gh auth login --with-token < mytoken.txt 
```


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

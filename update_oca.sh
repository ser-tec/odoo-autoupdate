#!/bin/bash

dir=$(dirname $0)
cd $dir
. update.conf

[ ! -d "$OCA_FOLDER" ] && mkdir -p "$OCA_FOLDER"

cd "$OCA_FOLDER/.."

gh repo list OCA --limit $LIMIT | while read -r repo _; do
  if eval "$EXCLUDE_REPO"; then
    echo "Skip $repo"
    continue
  fi

  echo "$repo"

  # Directory esistente?
  if [ -d "$repo" ]; then
    cd "$repo"
    if [ -d .git ]; then
      echo " > pulling updates"
      git reset --hard HEAD
      git clean -fd
      git pull --rebase
    else
      echo " > not a git repo, removing and re-cloning"
      cd ..
      rm -rf "$repo"
      gh repo clone "$repo" "$repo" -- --branch $ODOO_VERS --depth=1
    fi
  else
    echo " > cloning repo"
    gh repo clone "$repo" "$repo" -- --branch $ODOO_VERS --depth=1
  fi
done

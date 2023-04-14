#!/bin/bash

dir=$(dirname $0)
cd $dir

# Import the configuration file
. update.conf

if [ ! -d $OCA_FOLDER ]; then
    mkdir $OCA_FOLDER
fi

cd "$OCA_FOLDER/.."
gh repo list OCA --limit $LIMIT | while read -r repo _; do
  if eval "$EXCLUDE_REPO"; then
    echo "Skip $repo"
    continue
  fi
  echo "$repo"
  gh repo clone "$repo" "$repo" -- --branch $ODOO_VERS --depth=1 || (
    cd "$repo"
    git checkout || true
    git pull
  )
done

#!/bin/bash

# Change to the directory of the script itself and get a username based on
# the path where the file resides. This assumes the typical Linux scheme of
# /home/username and will otherwise fail. The script then re-runs itself as 
# that user.

cd "$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
if [ "$(id -u)" = "0" ]; then
    USER="$(echo $PWD|sed 's|^/home/\([^/]\+\).*$|\1|')"
    SCRIPT="$(realpath $0)"
    exec su -l -c "$SCRIPT" "$USER"
fi


# Build process goes here

yarn=yarnpkg

# Install new deps
MD5="$(md5sum package.json)"
git pull || exit
[ "$MD5" = "$(md5sum package.json)" ] || $yarn install

# Build main site
$yarn build
rm -rf site
cp -a dist site

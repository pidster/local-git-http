#!/usr/bin/env bash
# 
################################################################

set -o errexit

echo "-----------------------------------------------------------------------"
env
echo "-----------------------------------------------------------------------"


readonly FCGIPROGRAM="/usr/bin/fcgiwrap"
#readonly GIT_PROJECT_ROOT="/etc/nginx/sites"
readonly GIT_HTTP_EXPORT_ALL="true"
readonly GIT_USER="git"
readonly GIT_GROUP="git"
readonly FCGISOCKET="/var/run/fcgiwrap.sock"
readonly SOCKUSERID="$USERID"
readonly USERID="nginx"


if [ ! -d /repos ]; then
  echo "/repos dir is missing!"
  exit 1
fi

DIRS=`find /repos -maxdepth 3 -type d -name '.git'`
for GIT_DIR in $DIRS
do
  if [ -d "$GIT_DIR" ]; then
    REPO_PATH="${GIT_DIR%/.git}"
    REPO_NAME="${REPO_PATH#/repos/}"
    
    echo "Making parent directories: /etc/nginx/sites/$REPO_NAME"
    mkdir -p /etc/nginx/sites/$REPO_NAME \
    && rmdir /etc/nginx/sites/$REPO_NAME
    
    echo "Mapping repo $REPO_PATH to: /etc/nginx/sites/$REPO_NAME"
    ln -sf $REPO_PATH /etc/nginx/sites/$REPO_NAME
    
    echo "Mapping repo $GIT_DIR to: /etc/nginx/sites/$REPO_NAME.git"
    ln -sf $GIT_DIR /etc/nginx/sites/$REPO_NAME.git
  fi
done

chown nginx:git /etc/nginx/sites

export HOME=/home/git

/usr/bin/spawn-fcgi \
    -s $FCGISOCKET \
    -F 4 \
    -u $USERID \
    -g $USERID \
    -U $USERID \
    -G $GIT_GROUP -- \
    "$FCGIPROGRAM"

exec nginx

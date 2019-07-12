#!/bin/bash
# 
################################################################

set -o errexit


readonly FCGIPROGRAM="/usr/bin/fcgiwrap"
#readonly GIT_PROJECT_ROOT="/etc/local-git-http"
#readonly GIT_HTTP_EXPORT_ALL="true"
readonly GIT_USER="git"
readonly GIT_GROUP="git"
readonly FCGISOCKET="/var/run/fcgiwrap.socket"
#readonly SOCKUSERID="$USERID"
readonly USERID="nginx"


if [ ! -d /repos ]; then
  echo "/repos dir is missing!"
  exit 1
fi

DIRS=`ls -d -- /repos/*`
for DIR in $DIRS
do
  if [ -d "$DIR/.git" ]; then
    NAME="${DIR:7}"
    echo "Mapping repo: $DIR/.git to: /etc/local-git-http/$NAME.git"
    ln -sf $DIR/.git /etc/local-git-http/$NAME.git
  fi
done

/usr/bin/spawn-fcgi \
    -s $FCGISOCKET \
    -F 4 \
    -u $USERID \
    -g $USERID \
    -U $USERID \
    -G $GIT_GROUP -- \
    "$FCGIPROGRAM"

exec nginx

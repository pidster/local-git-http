FROM nginx:alpine

RUN set -x \
 && apk --update upgrade \
 && apk --no-cache add git git-daemon bash fcgiwrap spawn-fcgi \
 && mkdir -p /etc/nginx \
 && mkdir -p /etc/local-git-http \
 && mkdir -p /repos/test \
 && cd /repos/test \
 && git init \
 && adduser git git \
 && adduser nginx git \
 && git config --system http.receivepack true \
 && git config --system http.uploadpack true \
 && git config --system user.email "gitserver@localhost" \
 && git config --system user.name "Git Server"

COPY etc /etc/nginx
COPY launch.sh /usr/bin/launch

ENTRYPOINT [ "launch" ]

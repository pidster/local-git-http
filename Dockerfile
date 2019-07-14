FROM nginx:alpine

RUN set -x \
 && apk --update upgrade \
 && apk --no-cache add git git-daemon bash fcgiwrap spawn-fcgi \
 && mkdir -p /etc/nginx \
 && mkdir -p /etc/nginx/sites \
 && mkdir -p /repos/test \
 && addgroup -S git \
 && adduser -S git -G git \
 && cd /repos/test \
 && git init \
 && git config --system http.receivepack true \
 && git config --system http.uploadpack true \
 && git config --system user.email "gitserver@localhost" \
 && git config --system user.name "Git Server" \
 && cp /etc/gitconfig /root/.gitconfig 
# && chown git:git /home/root/.gitconfig

#  && adduser -S nginx -G git \

COPY etc /etc/nginx
COPY launch.sh /usr/bin/launch

ENTRYPOINT [ "launch" ]

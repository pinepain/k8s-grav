FROM ubuntu:16.04

ENV DEBIAN_FRONTEND noninteractive

ARG GRAV_VERSION=1.2.4

#ENV LANG en_US.utf8
RUN apt-get update \
    && apt-get install -y nginx wget unzip \
    && apt-get install -y php7.0-cli php7.0-fpm php7.0-mbstring php7.0-curl php7.0-gd php7.0-xml php7.0-zip \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /var/run/php \
    && rm /etc/nginx/sites-enabled/default \
    # Build Grav application
    && cd /var/www/ \
    && wget -nv https://github.com/getgrav/grav/releases/download/$GRAV_VERSION/grav-admin-v$GRAV_VERSION.zip \
    && unzip -q grav-admin-v$GRAV_VERSION.zip \
    && mv grav-admin grav \
    && rm grav-admin-v$GRAV_VERSION.zip

# initial credentials for grav dmin plugin and pages
COPY data/accounts /var/www/grav/user/accounts
COPY data/pages /var/www/grav/user/pages

COPY build/www.conf /etc/php/7.0/fpm/pool.d/www.conf
COPY build/grav.conf /etc/nginx/conf.d/grav.conf
COPY build/nginx.conf /etc/nginx/nginx.conf

CMD php-fpm7.0 -R -d variables_order="EGPCS" && (tail -F /var/log/nginx/access.log &) && exec nginx -g "daemon off;"

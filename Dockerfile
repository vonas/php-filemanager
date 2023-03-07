FROM php:7.4-cli-alpine

RUN apk add --no-cache \
    libzip-dev \
    oniguruma-dev \
    libpng \
    libpng-dev

RUN docker-php-ext-install \
    zip \
    gd

# source: https://ghost.rivario.com/docker-php-7-2-fpm-alpine-imagick
RUN apk add --no-cache autoconf g++ imagemagick imagemagick-dev libtool make pcre-dev libgomp
RUN pecl install imagick \
    && docker-php-ext-enable imagick \
    && apk del autoconf g++ libtool make pcre-dev

# RUN apk del libzip-dev oniguruma-dev libpng-dev

RUN apk add --no-cache su-exec

WORKDIR /var/www/html

COPY index.php index.php
COPY install.php install.php
COPY artwork /var/www/html/artwork
COPY support /var/www/html/support

RUN mkdir -p /var/www/html/data
RUN chown -R www-data:www-data /var/www/html
RUN chmod g+s /var/www/html

CMD ["php", "-S", "0.0.0.0:80"]


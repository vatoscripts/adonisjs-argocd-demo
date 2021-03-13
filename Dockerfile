FROM php:7.4-fpm

RUN docker-php-ext-install
RUN yum update && yum install -y \
        libmcrypt-dev

RUN yum install -y nginx  supervisor && \
    rm -rf /var/lib/apt/lists/*
RUN yum install -y redis

COPY . /var/www/biokyc
WORKDIR /var/www/biokyc

RUN rm /etc/nginx/sites-enabled/default

COPY /docker/nginx/nginx.conf /etc/nginx/conf.d/default.conf

ADD https://getcomposer.org/download/1.6.2/composer.phar /usr/bin/composer
RUN chmod +rx /usr/bin/composer

RUN composer install

RUN cp .env.example .env
RUN php artisan key:generate

RUN chmod +x ./entrypoint

ENTRYPOINT ["./entrypoint"]

EXPOSE 80
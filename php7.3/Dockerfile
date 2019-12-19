FROM php:7.3
RUN apt update && apt install -y unzip apt-utils
RUN docker-php-ext-install -j$(nproc) pdo_mysql
RUN pecl install timezonedb && docker-php-ext-enable timezonedb
RUN php -m
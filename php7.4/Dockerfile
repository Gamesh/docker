# Build: docker build -t gamesh/php:7.4 .
# Publish: docker push gamesh/php:7.4
FROM php:7.4-apache

RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        zlib1g-dev \
        libicu-dev \
        libzip-dev \
        libxslt-dev \
        g++ \
        unzip \
        openssh-client \
        git \
        git-lfs \
        nano \
    && docker-php-ext-configure intl \
    && docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ \
    && docker-php-ext-configure xsl \
    && docker-php-ext-install -j$(nproc) pdo_mysql exif intl gd opcache zip xsl \
    && pecl install xdebug \
    && docker-php-source delete \
    && pecl clear-cache \
    && apt-get purge -y --auto-remove g++ make \
    && apt-get clean && apt-get autoclean -y && apt-get autoremove -y

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.2/install.sh | bash \
  && . /root/.bashrc \
  && nvm install lts/* \
  && nvm cache clear

ENV APACHE_DOCUMENT_ROOT /var/www/html
ENV PHP_DATE_TIMEZONE Europe/Vilnius
ENV COMPOSER_MEMORY_LIMIT=-1

RUN a2enmod rewrite \
  && mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini" \
  && echo "date.timezone = $PHP_DATE_TIMEZONE" >> "$PHP_INI_DIR/php.ini" \
  && echo 'memory_limit = 512M' >> "$PHP_INI_DIR/php.ini" \
  && echo 'upload_max_filesize = 50M' >> "$PHP_INI_DIR/php.ini" \
  && echo 'post_max_size = 80M' >> "$PHP_INI_DIR/php.ini" \
  && sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf

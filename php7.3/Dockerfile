# Build: docker build -t gamesh/php:7.3 .
# Publish: docker push gamesh/php:7.3
FROM php:7.3-apache

ENV APACHE_DOCUMENT_ROOT=/var/www/html
ENV PHP_DATE_TIMEZONE=Europe/Vilnius
ENV PHP_MEMORY_LIMIT=1G
ENV COMPOSER_MEMORY_LIMIT=-1
ENV COMPOSER_VERSION=2

RUN apt-get update && apt-get install -y \
        g++ \
        git \
        git-lfs \
        libfreetype6-dev \
        libicu-dev \
        libjpeg62-turbo-dev \
        libmemcached-dev \
        libpng-dev \
        libxslt-dev \
        libzip-dev \
        nano \
        openssh-client \
        unzip \
        zlib1g \
        zlib1g-dev \
        zlibc \
    && mkdir -p /usr/src/php/ext/memcached \
    && curl -Ls https://github.com/php-memcached-dev/php-memcached/archive/v3.1.5.tar.gz | tar xvz -C /usr/src/php/ext/ \
    && mv /usr/src/php/ext/php-memcached-3.1.5/* /usr/src/php/ext/memcached/ \
    && docker-php-ext-configure memcached \
    && docker-php-ext-configure intl \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-configure xsl \
    && docker-php-ext-install -j$(nproc) pdo_mysql exif intl gd opcache zip xsl memcached \
    && pecl install xdebug \
    && docker-php-source delete \
    && pecl clear-cache \
    && apt-get purge -y --auto-remove g++ make \
    && rm -rf /usr/src/php/ext/memcached \
    && apt-get clean && apt-get autoclean -y && apt-get autoremove -y

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --$COMPOSER_VERSION

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash \
  && . /root/.bashrc \
  && nvm install lts/* \
  && nvm cache clear

RUN a2enmod rewrite \
  && mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini" \
  && echo "date.timezone = $PHP_DATE_TIMEZONE" >> "$PHP_INI_DIR/php.ini" \
  && echo "memory_limit = $PHP_MEMORY_LIMIT" >> "$PHP_INI_DIR/php.ini" \
  && echo 'upload_max_filesize = 50M' >> "$PHP_INI_DIR/php.ini" \
  && echo 'post_max_size = 80M' >> "$PHP_INI_DIR/php.ini" \
  && sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf

WORKDIR $APACHE_DOCUMENT_ROOT

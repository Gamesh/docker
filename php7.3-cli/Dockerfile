# Build: docker build -t gamesh/php:7.3-cli .
# Publish: docker push gamesh/php:7.3-cli
FROM php:7.3-cli-alpine

RUN apk add --no-cache --update --virtual buildDeps g++ make autoconf \
    && apk add --no-cache --update --clean-protected bash \
        freetype-dev \
        libjpeg-turbo-dev \
        libpng-dev \
        zlib-dev \
        icu-dev \
        libzip-dev \
        libxslt-dev \
        unzip \
        zip \
        rsync \
        openssh-client \
        git \
        git-lfs \
        nano \
        nodejs \
    && docker-php-ext-configure intl \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-configure xsl \
    && docker-php-ext-install -j$(nproc) pdo_mysql exif intl gd opcache zip xsl \
    && pecl install xdebug \
    && docker-php-source delete \
    && pecl clear-cache \
    && apk del --purge buildDeps

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --2

ENV PHP_DATE_TIMEZONE Europe/Vilnius
ENV PHP_MEMORY_LIMIT=1G
ENV COMPOSER_MEMORY_LIMIT=-1

RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini" \
  && echo "date.timezone = $PHP_DATE_TIMEZONE" >> "$PHP_INI_DIR/php.ini" \
  && echo "memory_limit = $PHP_MEMORY_LIMIT" >> "$PHP_INI_DIR/php.ini" \
  && echo 'upload_max_filesize = 50M' >> "$PHP_INI_DIR/php.ini" \
  && echo 'post_max_size = 80M' >> "$PHP_INI_DIR/php.ini"

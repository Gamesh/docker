# Build: docker build -t gamesh/php:8.0-cli .
# Publish: docker push gamesh/php:8.0-cli
FROM composer:2 as composer
FROM php:8.0-cli-alpine

ENV PHP_DATE_TIMEZONE=Europe/Vilnius
ENV PHP_MEMORY_LIMIT=-1
ENV COMPOSER_MEMORY_LIMIT=-1
ENV PHP_UPLOAD_TMP_DIR=/tmp
ENV PHP_SYS_TEMP_DIR=/tmp

RUN apk add --no-cache --update --virtual buildDeps g++ make autoconf zlib-dev libmemcached-dev cyrus-sasl-dev \
    && apk add --no-cache --update --virtual .phpize-deps $PHPIZE_DEPS \
    && apk add --no-cache --update --clean-protected bash \
        freetype-dev \
        git \
        git-lfs \
        icu-dev \
        libjpeg-turbo-dev \
        libmemcached-libs \
        libpng-dev \
        libxslt-dev \
        libzip-dev \
        libwebp-dev \
        nano \
        nodejs \
        openssh-client \
        rsync \
        unzip \
        zip \
        zlib \
        zlib-dev \
    && docker-php-ext-configure intl \
    && docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ --with-webp=/usr/include \
    && docker-php-ext-configure xsl \
    && docker-php-ext-install -j$(nproc) pdo_mysql exif intl gd opcache zip xsl soap \
    && pecl install xdebug memcached \
    && echo "extension=memcached.so" > /usr/local/etc/php/conf.d/docker-php-ext-memcached.ini \
    && docker-php-source delete \
    && pecl clear-cache \
    && rm -rf /usr/share/php8 /tmp/* \
    && apk del --purge buildDeps .phpize-deps

COPY --from=composer /usr/bin/composer /usr/local/bin/composer


RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini" \
  && echo "date.timezone = $PHP_DATE_TIMEZONE" >> "$PHP_INI_DIR/php.ini" \
  && echo "memory_limit = $PHP_MEMORY_LIMIT" >> "$PHP_INI_DIR/php.ini" \
  && echo 'upload_max_filesize = 50M' >> "$PHP_INI_DIR/php.ini" \
  && echo "upload_tmp_dir = $PHP_UPLOAD_TMP_DIR" >> "$PHP_INI_DIR/php.ini" \
  && echo "sys_temp_dir = $PHP_SYS_TEMP_DIR" >> "$PHP_INI_DIR/php.ini" \
  && echo 'post_max_size = 80M' >> "$PHP_INI_DIR/php.ini"

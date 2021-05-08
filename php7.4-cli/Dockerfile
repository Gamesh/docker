# Build: docker build -t gamesh/php:7.4-cli .
# Publish: docker push gamesh/php:7.4-cli
FROM php:7.4-cli-alpine

ENV PHP_DATE_TIMEZONE=Europe/Vilnius
ENV PHP_MEMORY_LIMIT=-1
ENV COMPOSER_MEMORY_LIMIT=-1
ENV COMPOSER_VERSION=2
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
        nano \
        nodejs \
        openssh-client \
        rsync \
        unzip \
        zip \
        zlib \
        zlib-dev \
    && docker-php-ext-configure intl \
    && docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ --with-webp-dir=/usr/include \
    && docker-php-ext-configure xsl \
    && docker-php-ext-install -j$(nproc) pdo_mysql exif intl gd opcache zip xsl \
    && pecl install xdebug memcached \
    && echo "extension=memcached.so" > /usr/local/etc/php/conf.d/docker-php-ext-memcached.ini \
    && docker-php-source delete \
    && pecl clear-cache \
    && rm -rf /usr/share/php7 /tmp/* \
    && apk del --purge buildDeps .phpize-deps

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --$COMPOSER_VERSION


RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini" \
  && echo "date.timezone = $PHP_DATE_TIMEZONE" >> "$PHP_INI_DIR/php.ini" \
  && echo "memory_limit = $PHP_MEMORY_LIMIT" >> "$PHP_INI_DIR/php.ini" \
  && echo 'upload_max_filesize = 50M' >> "$PHP_INI_DIR/php.ini" \
  && echo "upload_tmp_dir = $PHP_UPLOAD_TMP_DIR" >> "$PHP_INI_DIR/php.ini" \
  && echo "sys_temp_dir = $PHP_SYS_TEMP_DIR" >> "$PHP_INI_DIR/php.ini" \
  && echo 'post_max_size = 80M' >> "$PHP_INI_DIR/php.ini"

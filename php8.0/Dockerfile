# Build: docker build -t gamesh/php:8.0 .
# Publish: docker push gamesh/php:8.0
FROM php:8.0-apache

ENV APACHE_DOCUMENT_ROOT=/var/www/html
ENV PHP_DATE_TIMEZONE=Europe/Vilnius
ENV PHP_MEMORY_LIMIT=1G
ENV COMPOSER_MEMORY_LIMIT=-1
ENV COMPOSER_VERSION=2
ENV PHP_UPLOAD_TMP_DIR=/tmp
ENV PHP_SYS_TEMP_DIR=/tmp

RUN apt update && apt install -y \
        g++ \
        git \
        git-lfs \
        libfreetype6 \
        libfreetype6-dev \
        libicu-dev \
        libicu67 \
        libjpeg62-turbo \
        libjpeg62-turbo-dev \
        libmemcached-dev \
        libmemcached11 \
        libpng-dev \
        libpng16-16 \
        libwebp-dev \
        libwebp6 \
        libxslt-dev \
        libxslt1.1 \
        libzip-dev \
        libzip4 \
        nano \
        openssh-client \
        unzip \
        zlib1g \
        zlib1g-dev \
    && mkdir -p /usr/src/php/ext/memcached \
    && curl -Ls https://github.com/php-memcached-dev/php-memcached/archive/v3.1.5.tar.gz | tar xvz -C /usr/src/php/ext/ \
    && mv /usr/src/php/ext/php-memcached-3.1.5/* /usr/src/php/ext/memcached/ \
    && docker-php-ext-configure memcached \
    && docker-php-ext-configure intl \
    && docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ --with-webp=/usr/include \
    && docker-php-ext-configure xsl \
    && docker-php-ext-install -j$(nproc) pdo_mysql exif intl gd opcache zip xsl memcached soap \
    && docker-php-source delete \
    && rm -rf /usr/src/php/ext/memcached /tmp/pear/cache \
    && apt-get purge -y \
      g++ \
      icu-devtools \
      libfreetype6-dev \
      libhashkit-dev \
      libicu-dev \
      libjpeg62-turbo-dev \
      libmemcached-dev \
      libpng-dev \
      libsasl2-dev \
      libstdc++-*-dev \
      libwebp-dev \
      libxslt-dev \
      libzip-dev \
      make \
      zlib1g-dev \
    && apt-get clean && apt-get autoclean -y

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --$COMPOSER_VERSION

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash \
  && . /root/.bashrc \
  && nvm install lts/* \
  && nvm cache clear

RUN a2enmod rewrite \
  && mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini" \
  && echo "date.timezone = $PHP_DATE_TIMEZONE" >> "$PHP_INI_DIR/php.ini" \
  && echo "memory_limit = $PHP_MEMORY_LIMIT" >> "$PHP_INI_DIR/php.ini" \
  && echo 'upload_max_filesize = 50M' >> "$PHP_INI_DIR/php.ini" \
  && echo 'post_max_size = 80M' >> "$PHP_INI_DIR/php.ini" \
  && echo "upload_tmp_dir = $PHP_UPLOAD_TMP_DIR" >> "$PHP_INI_DIR/php.ini" \
  && echo "sys_temp_dir = $PHP_SYS_TEMP_DIR" >> "$PHP_INI_DIR/php.ini" \
  && sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf

RUN version=$(php -r "echo PHP_MAJOR_VERSION.PHP_MINOR_VERSION;") \
    && curl -A "Docker" -o /tmp/blackfire-probe.tar.gz -D - -L -s https://blackfire.io/api/v1/releases/probe/php/linux/amd64/$version \
    && mkdir -p /tmp/blackfire \
    && tar zxpf /tmp/blackfire-probe.tar.gz -C /tmp/blackfire \
    && mv /tmp/blackfire/blackfire-*.so $(php -r "echo ini_get ('extension_dir');")/blackfire.so \
    && printf "extension=blackfire.so\nblackfire.agent_socket=tcp://blackfire:8707\n" > $PHP_INI_DIR/conf.d/blackfire.ini \
    && rm -rf /tmp/blackfire /tmp/blackfire-probe.tar.gz

WORKDIR $APACHE_DOCUMENT_ROOT

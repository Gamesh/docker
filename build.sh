#!/usr/bin/env bash

export DOCKER_BUILDKIT=1
docker build --pull -t gamesh/php:7.3 php7.3/ &&
docker build --pull -t gamesh/php:7.3-cli -t gamesh/php:7.3-cli-alpine php7.3-cli/ &&
docker build --pull -t gamesh/php:7.4 -t gamesh/php:latest php7.4/ &&
docker build --pull -t gamesh/php:7.4-cli -t gamesh/php:7.4-cli-alpine php7.4-cli/ &&
docker build --pull -t gamesh/php:8.0-cli -t gamesh/php:8.0-cli-alpine php7.4-cli/ &&
docker build --pull -t gamesh/php:8.0 -t gamesh/php:latest php8.0/ &&
docker push gamesh/php:7.3 &&
docker push gamesh/php:7.3-cli &&
docker push gamesh/php:7.4 &&
docker push gamesh/php:7.4-cli &&
docker push gamesh/php:8.0-cli &&
docker push gamesh/php:8.0

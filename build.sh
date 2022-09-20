#!/usr/bin/env bash
set -e

export DOCKER_BUILDKIT=1
docker build --pull -t gamesh/php:7.4 php7.4/
docker build --pull -t gamesh/php:7.4-cli -t gamesh/php:7.4-cli-alpine php7.4-cli/
docker build --pull -t gamesh/php:8.0 -t gamesh/php:8.0 php8.0/
docker build --pull -t gamesh/php:8.0-cli -t gamesh/php:8.0-cli-alpine php8.0-cli/
docker build --pull -t gamesh/php:8.1-cli -t gamesh/php:8.1-cli-alpine -t gamesh/php:latest php8.1-cli/
docker push --all-tags gamesh/php

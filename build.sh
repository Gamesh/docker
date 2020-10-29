#!/usr/bin/env bash

docker build -t gamesh/php:7.3 php7.3/
docker build -t gamesh/php:7.3-cli -t gamesh/php:7.3-cli-alpine php7.3-cli/
docker build -t gamesh/php:7.4 -t gamesh/php:latest php7.4/
docker build -t gamesh/php:7.4-cli -t gamesh/php:7.4-cli-alpine php7.4-cli/

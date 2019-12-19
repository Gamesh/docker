#!/usr/bin/bash
docker build -f php7.3/Dockerfile -t gamesh/php7.3-dev:latest php7.3/
docker push gamesh/php7.3-dev:latest
#!/usr/bin/env bash
set -u -e -o pipefail

hugo
rsync -avz public/ root@aduffy.io:/var/www/html

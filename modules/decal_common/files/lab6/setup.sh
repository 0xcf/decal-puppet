#!/bin/bash
set -euxo pipefail

# Don't bork the staff VM
[ "$(hostname)" != "staff" ] || exit 0

# Bork the Apache config, and change port to 8000
cp -a /opt/lab6/apache2_broken.conf /etc/apache2/apache2.conf
sed -i 's/^Listen 80$/Listen 8000/' /etc/apache2/ports.conf
cp -a /opt/lab6/000-default.conf /etc/apache2/sites-available/
systemctl stop apache2

# Set wrong permissions on /srv/www
mkdir -p /srv/www
cp -a /opt/lab6/index.html /srv/www/
chmod -R go-rwx /srv/www

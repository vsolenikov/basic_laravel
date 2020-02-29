#!/bin/bash

currentver="$(lsb_release -r -s)"
requiredver="18.00"
#check Ubuntu version
if [ "$(printf '%s\n' "$requiredver" "$currentver" | sort -V | head -n1)" = "$requiredver" ]; then
        echo "Greater than or equal to 18.04. Do nothing"
else
        #if vesion less than 18.04 add aditional repository for php7.2 . In oldest version of Ubuntu php7.0 by default
        echo "Less than 18.04"
        sudo apt-get install software-properties-common python-software-properties
        sudo add-apt-repository -y ppa:ondrej/php
        sudo apt-get update
fi

sudo apt install php7.2 php7.2-curl php7.2-common php7.2-cli php7.2-mysql php7.2-mbstring php7.2-fpm php7.2-gd php7.2-xml php7.2-zip -y
sudo apt install nginx -y
sudo apt install unzip curl -y
sudo apt install mariadb-server -y
curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
sudo cp ./laravel.conf /etc/nginx/sites-available/
sudo ln -s /etc/nginx/sites-available/laravel.conf /etc/nginx/sites-enabled/
sudo mysql_secure_installation

cd /var/www/
#change to your git repository if doesn't need default laravel project
sudo composer create-project --prefer-dist laravel/laravel laravel
sudo rm /etc/nginx/sites-available/default
sudo rm /etc/nginx/sites-enabled/default
sudo service nginx restart
nginx -t
sudo chown -R www-data:www-data /var/www/laravel/
sudo chmod -R 755 /var/www/laravel/

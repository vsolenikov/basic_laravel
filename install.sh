#!/bin/bash

#======---Данные пользователя---======

export usr='nameUser'
export pas='passwordUser'

#======-------------------------======

currentver="$(lsb_release -r -s)"
requiredver="18.00"
#check Ubuntu version
if [ "$(printf '%s\n' "$requiredver" "$currentver" | sort -V | head -n1)" = "$requiredver" ]; then
        echo "Greater than or equal to 18.04. Do nothing"
else
        #if vesion less than 18.04 add aditional repository for php7.3 . In oldest version of Ubuntu php7.0 by default
        echo "Less than 18.04"
        sudo apt-get install software-properties-common python-software-properties
fi
sudo apt-get install software-properties-common python-software-properties
sudo add-apt-repository -y ppa:ondrej/php
sudo apt-get update
sudo apt-get install php7.3 php7.3-curl php7.3-common php7.3-cli php7.3-mysql php7.3-mbstring php7.3-fpm php7.3-gd php7.3-xml php7.3-zip -y
sudo apt install nginx -y
sudo apt install unzip curl -y
sudo apt install mariadb-server -y
curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
sudo cp ./laravel.conf /etc/nginx/sites-available/
sudo ln -s /etc/nginx/sites-available/laravel.conf /etc/nginx/sites-enabled/
sudo mysql_secure_installation

cd /var/www/
#change to your git repository if doesn't need default laravel project
sudo git clone https://SolenikovVladimir@bitbucket.org/cryptoprof/crm-new.git laravel
sudo rm /etc/nginx/sites-available/default
sudo rm /etc/nginx/sites-enabled/default
sudo service nginx restart
nginx -t

cd /var/www/laravel
sudo composer install
sudo cp env_example .env

sudo cp .env /var/basic_laravel_lnmp/
cd /var/basic_laravel_lnmp/

sed -e "s/\${dbuser}/$usr/" -e "s/\${dbpass}/$pas/" .env > enver.txt

sudo cp enver.txt /var/www/laravel
sudo chmod -R 755 /var/basic_laravel_lnmp/
cd /var/www/laravel

sudo cp enver.txt .env
sudo rm enver.txt
cd /var/basic_laravel_lnmp

sudo mysql -u root -pvova200027 << EOF
CREATE DATABASE laravel;
CREATE USER '$usr'@'localhost' identified by '$pas';
EOF

sudo mysql -u root -pvova200027 << EOF
USE laravel;
GRANT ALL PRIVILEGES ON laravel.* to '$usr'@'localhost';
FLUSH PRIVILEGES;
EOF

cd /var/www/laravel
sudo php artisan migrate:fresh --seed

sudo rm enver.txt

sudo chown -R www-data:www-data /var/www/laravel/
sudo chmod -R 755 /var/www/laravel/

sudo php artisan key:generate
sudo chown -R www-data:www-data /var/www/laravel/
sudo chmod -R 755 /var/www/laravel/
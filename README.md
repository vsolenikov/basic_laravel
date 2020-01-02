# basic_laravel_lnmp
A basic laravel web server install package in Ubuntu 18(Nginx+MariaDB+php7.2)

Install basic lnmp server for laravel:
```
git clone https://github.com/cryptoprof/basic_laravel_lnmp.git  
cd basic_laravel_lnmp/
sudo sh install.sh
```
Do not forget to set password for MariaDB when mysql_secure_installation will ask you to change password.
In */etc/nginx/sites-available/laravel.conf* set *server_name* option
Restart nginx
```
service nginx restart
```

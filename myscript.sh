#!/bin/bash
sudo apt-get update
sudo apt-get install ssh -y
sudo apt install apache2 -y
sudo systemctl enable apache2
sudo systemctl start apache2
sudo apt install mysql-client mysql-server -y
db="test"
usr="test"
pswd=1234
mysql -uroot <<MYSQL_SCRIPT
CREATE DATABASE $db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER '$usr'@'localhost' IDENTIFIED BY '$pswd';
GRANT ALL PRIVILEGES ON $db.* TO '$usr'@'localhost';
FLUSH PRIVILEGES;
MYSQL_SCRIPT

echo "MySQL database created."
echo "Database:   $db"
echo "Username:   $usr"
echo "Password:   $pswd"
sudo apt install php7.4 php7.4-mysql libapache2-mod-php7.4 php7.4-cli php7.4-cgi php7.4-gd -y
cd /var/www/
sudo rm -r html/
sudo wget https://ru.wordpress.org/latest-ru_RU.tar.gz
sudo tar xzf latest-ru_RU.tar.gz
sudo apt-get install git -y
git clone https://github.com/DemyankovVladislav/March_task
cd March_task/
cp wp-config.php /var/www/wordpress/
cp eqzo.by.conf /etc/apache2/sites-available/
cd /var/www/wordpress
sudo chown vladislav ./*
cd /etc/apache2/sites-available/
rm 000-default.conf
systemctl reload apache2
sudo a2ensite eqzo.by.conf
systemctl reload apache2

#!/bin/bash
#Переменная сравнения = имя компьютера
name=$(hostname)
#Проверка на совпадение имени компьютера
if [[ "$name" == "Server" ]]; then
#Установка apache2 и php (+ библиотеки), БД
  sudo apt install apache2 php php-mysql php-mysqlnd php-ldap php-bcmath php-mbstring php-gd php-pdo php-xml libapache2-mod-php -y
  sudo apt install mariadb-server mariadb-client -y
#Создание базы данных zabbix, пользователя zabbix@localhost и к нему пароля 1234
  sudo mysql -uroot -e "create database zabbix character set utf8 collate utf8_bin;"
  sudo mysql -uroot -e "grant all privileges on zabbix.* to zabbix@localhost identified by '1234';"
  sudo mysql -uroot -e "FLUSH PRIVILEGES;"
  sudo mysql -uroot -e "quit"
#Скачивание и добавление официального репозитория Zabbix
  sudo wget https://repo.zabbix.com/zabbix/4.2/debian/pool/main/z/zabbix-release/zabbix-release_4.2-2+buster_all.deb
  sudo dpkg -i zabbix-release_4.2-2+buster_all.deb
  sudo apt update
#Установка сервера zabbix + веб интерфейс 
  sudo apt -y install zabbix-server-mysql zabbix-frontend-php
#Изменение файла конфигурации БД
  sudo echo "[mysqld]" | tee -a  /etc/mysql/my.cnf
  sudo echo "innodb_strict_mode=0 " | tee -a  /etc/mysql/my.cnf
#Останавливаем и перезапускаем службу mysql
  sudo systemctl stop mysql
  sudo systemctl start mysql
#Импортируем структуру и данные в базу Zabbix
  sudo zcat /usr/share/doc/zabbix-server-mysql/create.sql.gz | mysql -u zabbix -p zabbix -uroot -p1234
#Изменяем конфигурацию zabbix сервера DBHost=localhost DBPassword=1234
  sudo echo "DBHost=localhost" | tee -a  /etc/zabbix/zabbix_server.conf
  sudo echo "DBPassword=1234" | tee -a  /etc/zabbix/zabbix_server.conf
#Включение часового пояса удаляя #
  sudo sed -i 's/# php_value/php_value/g' /etc/zabbix/apache.conf
#Перезапуск apache2 и запуск zabbix-server
  sudo systemctl restart apache2
  sudo systemctl start zabbix-server
  systemctl enable zabbix-server
#Блок проверки для клиента NFS
elif [[ "$name" == "Client" ]]; then
#Скачивание и добавление официального репозитория Zabbix
  sudo wget https://repo.zabbix.com/zabbix/4.2/debian/pool/main/z/zabbix-release/zabbix-release_4.2-2+buster_all.deb
  sudo dpkg -i zabbix-release_4.2-2+buster_all.deb
  sudo apt update
#Скачиваем агента и запускаем  
  sudo apt install zabbix-agent
#Изменяем переменные конфига агента
  sudo sed -i 's/Server=127.0.0.1/Server=192.168.100.28/g' /etc/zabbix/zabbix_agentd.conf
  sudo sed -i 's/ServerActive=127.0.0.1/ServerActive=192.168.100.28/g' /etc/zabbix/zabbix_agentd.conf
  sudo sed -i 's/Hostname=Zabbix server/Hostname=Client/g' /etc/zabbix/zabbix_agentd.conf
  sudo echo "Timeout=10" | tee -a  /etc/zabbix/zabbix_agentd.conf
  sudo systemctl enable zabbix-agent
  sudo systemctl start zabbix-agent
  sudo reboot
fi


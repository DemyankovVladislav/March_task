#!/bin/bash
#Переменная имени компьютера и сравнение клиент ли он NFS
name=$(hostname)
if [[ "$name" == "Client"  &&   -d /mnt/shara_client ]]; then
#Создаем переменную и архив по имени день-месяц-год-час-мин-сек
  date=`date '+%d-%m-%Y-%H-%M-%S'`
  sudo tar czf "$date.tar.gz" /root/. /home/*/.*
  sudo chmod 766 "$date.tar.gz"
#Перемещаем наш архив в директорию NFS
  sudo cp "$date.tar.gz" /mnt/shara_client
#Создаем задачу крону для запуска нашего скрипта
  #cd /tmp
  #sudo touch crontab-arch
  #sudo echo "05 8 * * * /tmp/backup.sh" | tee -a  /tmp/crontab-arch
  #sudo crontab crontab-arch
else
  echo “Скрипт не для этого устройства, обращайтесь к системному    администратору”
fi


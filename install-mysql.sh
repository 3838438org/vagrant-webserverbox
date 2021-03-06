#!/bin/bash

sudo debconf-set-selections <<< 'mysql-apt-config mysql-apt-config/select-server select mysql-5.7'
sudo debconf-set-selections <<< 'mysql-apt-config mysql-apt-config/select-product select Ok'
sudo DEBIAN_FRONTEND=noninteractive dpkg -i /tmp/mysql-apt-config_0.7.3-1_all.deb
sudo apt-get update
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password '
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password '
sudo DEBIAN_FRONTEND=noninteractive apt-get install mysql-server mysql-client -y
sudo sed -i -- 's/bind-address/#bind-address/' /etc/mysql/mysql.conf.d/mysqld.cnf
sudo bash -c 'echo "" >> /etc/mysql/mysql.conf.d/mysqld.cnf'
sudo bash -c 'echo "skip-external-locking" >> /etc/mysql/mysql.conf.d/mysqld.cnf'
sudo bash -c 'echo "" >> /etc/mysql/mysql.conf.d/mysqld.cnf'
sudo bash -c 'echo "sql-mode=\"\"" >> /etc/mysql/mysql.conf.d/mysqld.cnf'
sudo /etc/init.d/mysql restart
sudo mysql -e "USE mysql; UPDATE user SET plugin='' WHERE user='root'; GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION; FLUSH PRIVILEGES;"
mysql_upgrade -u root --force
sudo /etc/init.d/mysql restart
mysql_tzinfo_to_sql /usr/share/zoneinfo/ | mysql -u root mysql

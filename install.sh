#!/usr/bin/env bash

# This is assumed to be run as root or with sudo

export DEBIAN_FRONTEND=noninteractive

# Import MySQL 5.7 Key
# gpg: key 5072E1F5: public key "MySQL Release Engineering <mysql-build@oss.oracle.com>" imported
apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys 5072E1F5
echo "deb http://repo.mysql.com/apt/ubuntu/ trusty mysql-5.7" | tee -a /etc/apt/sources.list.d/mysql.list

apt-get update

# Install MySQL

MYSQL_PASS="secret"

debconf-set-selections <<< "mysql-community-server mysql-community-server/data-dir select ''"
debconf-set-selections <<< "mysql-community-server mysql-community-server/root-pass password $MYSQL_PASS"
debconf-set-selections <<< "mysql-community-server mysql-community-server/re-root-pass password $MYSQL_PASS"
apt-get install -y mysql-server

# Replace my.cnf
sudo mv /etc/mysql/my.cnf /etc/mysql/my.cnf.backup
sudo mv /etc/mysql/mysql.conf.d/mysqld.cnf /etc/mysql/my.cnf

# Restart Mysql service
sudo service mysql restart

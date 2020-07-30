#!/bin/bash
#
# Script was created by: Akash Semil <semil19@hotmail.com>
# github.com/akashsemil
#
# This script will help you setup a LAMP Stack [Linux-Apache-MySQL-PHP]
#
# Distribution | Default PHP Version 
# CentOS_7     | PHP-5.4
# CentOS_8     | PHP-7.2
# Ubuntu_18    | PHP-7.2
# Ubuntu_20    | PHP-7.4
#
# Uncomment specify the php version you want to install 7.X where X can be {1,2,3,4}, Suggestion use PHP 7.4
# If not specified default php that comes with the distribution will be installed.
# PHP_VERSION=7.4
#
# Specify Database root password
DB_ROOT_PASSWORD="root@db"
#
# Exit Values
# 0             success
# 1             Run as root
# 2             distribution not supported
# 3             httpd or apache2 installation failed
# 4             php installation failed
# 5             sql installation failed
# 6             sql configuration failed
#
# If script failes look for script.out file in the working directory.
# 
function install_sql
{
    function configure_sql
    {
        if $(mysqladmin password "$DB_ROOT_PASSWORD")
	    then
		    mysql -uroot -p$DB_ROOT_PASSWORD <<EOF
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%';
FLUSH PRIVILEGES;
EOF
		    echo -e "\e[32mStatus: MYSQL_SECURE_INSTALLATION DONE"
	    else
		    echo -e "\e[31mError: MYSQL_SECURE_INSTALLATION FAILED"
            echo -e "\e[0m"
		    exit 6
	    fi
    }
    if [ $ID == "centos" ]
    then 
        if yum install -y mariadb-server &> script.out &&
            systemctl enable mariadb --now  &>> script.out
        then 
            echo -e "\e[32mStatus: MariaDB Installed"
            configure_sql
        else 
            echo -e "\e[31mError: Unable to install MariaDB"
            echo -e "\e[0m"
            exit 5
        fi
    fi
    if [ $ID == "ubuntu" ]
    then 
        if apt install -y mysql-server &> script.out &&
            systemctl enable mysql --now  &>> script.out
        then 
            echo -e "\e[32mStatus: MySQL Installed"
            configure_sql
        else 
            echo -e "\e[31mError: Unable to install MySQL"
            echo -e "\e[0m"
            exit 5
        fi
    fi
}
function install_php
{
    if [ -z $PHP_VERSION ]
    then
        if [ $ID == "centos" ]
        then 
            if yum install -y php php-mysqlnd  &> script.out
            then 
                echo -e "\e[32mStatus: PHP Installed"
            else 
                echo -e "\e[31mError: Unable to install PHP"
                echo -e "\e[0m"
                exit 4
            fi
        fi
        if [ $ID == "ubuntu" ]
        then 
            if apt install -y php php-mysql  &> script.out
            then 
                echo -e "\e[32mStatus: PHP Installed"
            else 
                echo -e "\e[31mError: Unable to install PHP"
                echo -e "\e[0m"
                exit 4
            fi
        fi
    else
        if [ $ID == "centos" ]
        then
            if yum install -y epel-release &> script.out &&
		        yum install -y https://rpms.remirepo.net/enterprise/remi-release-$VERSION_ID.rpm  &>> script.out &&
		        yum install -y yum-utils &>> script.out &&
		        if [ $VERSION_ID == 8 ]; then dnf -y module enable php:remi-$PHP_VERSION; else yum-config-manager --enable remi-php$(echo $PHP_VERSION | tr -d '.'); fi &>> script.out &&
                yum install -y php$(echo $PHP_VERSION | tr -d '.') php-mysqlnd php  &>> script.out
            then
                echo -e "\e[32mStatus: PHP-$PHP_VERSION Installed"
            else
                echo -e "\e[31mError: Unable to install PHP"
                echo -e "\e[0m"
                exit 4
            fi
        fi
        if [ $ID == "ubuntu" ]
        then
            if echo -e "\n" | add-apt-repository ppa:ondrej/php &> script.out &&
                apt update -y &>> script.out &&
                apt install -y php$PHP_VERSION php$PHP_VERSION-mysql &>> script.out
            then
                echo -e "\e[32mStatus: PHP-$PHP_VERSION Installed"
            else
                echo -e "\e[31mError: Unable to install PHP"
                echo -e "\e[0m"
                exit 4
            fi
        fi
    fi    
}
function install_apache
{
    if [ $ID == "centos" ]
    then 
        if yum install -y httpd &> script.out &&
            systemctl enable httpd --now &>> script.out
        then 
            echo -e "\e[32mStatus: HTTPD Installed" 
        else 
            echo -e "\e[31mError: Unable to install HTTPD"
            echo -e "\e[0m"
            exit 3
        fi
    fi
    if [ $ID == "ubuntu" ]
    then 
        if apt install -y apache2 &> script.out &&
            systemctl enable apache2 --now &>> script.out
        then 
            echo -e "\e[32mStatus: Apache2 Installed"
        else 
            echo -e "\e[31mError: Unable to install Apache2"
            echo -e "\e[0m"
            exit 3
        fi
    fi
}
if [ $(whoami) == "root" ]
then
	clear
    source /etc/os-release
	if [ $ID == "centos" ] || [ $ID == "ubuntu" ] 
	then
        echo "INFO: Script is running (it will take some time depends on your net connection).Have a coffee Break."
        install_apache
        install_php
        install_sql
        echo "Success: Script completed successfully"
        if [ $ID == "centos" ];then systemctl restart httpd; systemctl restart mariadb; fi
        if [ $ID == "ubuntu" ];then systemctl restart apache2; systemctl restart mysql; fi
    else
        echo -e "\e[31mError: Unsupported Distribution"
        exit 2
	fi
else
	echo -e "\e[31mError: Run script as root."
	exit 1
fi
echo -e "\e[0m"
exit 0

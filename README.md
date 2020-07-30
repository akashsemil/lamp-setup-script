# LAMP STACK SETUP SCRIPT
This script will help you setup LAMP (Linux-Apache-MySQL-PHP) stack with specified PHP version.
By default script will install PHP that comes with your distribution.
You can specify PHP version, just uncomment PHP_VERSION variable and specify the version.
## Supported Distribution
CentOS-7, CentOS-8, Ubuntu-18, Ubuntu 20
## Getting Started
Following command will help you to fetch and execute the script on your local system.
### Prerequisites
A Fresh Updated Linux Machine with git installed

Ubuntu:
```
$ sudo apt update -y && sudo apt upgrade -y && sudo apt install git
$ git clone https://github.com/akashsemil/lamp-setup-script.git
$ cd lamp-setup-script
$ chmod u+x lamp-setup-script
$ sudo ./lamp-setup-script
```

CentOS:
```
# yum update -y && yum install git -y
# git clone https://github.com/akashsemil/lamp-setup-script.git
# cd lamp-setup-script
# chmod u+x lamp-setup-script
# ./lamp-setup-script
```

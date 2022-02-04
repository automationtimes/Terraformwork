#!bin/bash

db_username=${db_username}
db_user_password=${db_user_password}
db_name=${db_name}
db_RDS=${db_RDS}


#!/bin/bash
sudo yum update -y
sudo amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd
sudo systemctl is-enabled httpd
sudo usermod -a -G apache ec2-user
sudo chown -R ec2-user:apache /var/www
sudo chmod 2775 /var/www && find /var/www -type d -exec sudo chmod 2775 {} \;
find /var/www -type f -exec sudo chmod 0664 {} \;
sudo yum install php-mbstring php-xml -y
sudo systemctl restart httpd
sudo systemctl restart php-fpm
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
cp wordpress/wp-config-sample.php wordpress/wp-config.php
cp -r wordpress/* /var/www/html/
sed -i "s/database_name_here/${db_name}/g" /var/www/html/wp-config.php 
sed -i "s/username_here/${db_username}/g" /var/www/html/wp-config.php 
sed -i "s/password_here/${db_user_password}/g" /var/www/html/wp-config.php
sed -i "s/localhost/${db_RDS}/g" /var/www/html/wp-config.php

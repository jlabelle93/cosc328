!#/bin/bash
PHP_FILE = "<?php
phpinfo();
?>"

sudo apt update
sudo apt install php7.4 apache2 mysql-server -y
sudo apt install php7.4-zip php7.4-dom php7.4-xml php7.4-mbstring php7.4-gd php7.4-simplexml php7.4-curl php7.4-intl php7.4-mysql -y
sudo cat /var/www/html/phpinfo.php < echo $PHP_FILE
sudo service apache2 restart
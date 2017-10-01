yum update -y --disableplugin=fastestmirror
systemctl restart sshd

yum install -y git
yum install -y httpd httpd-devel mod_ssl

# PHP 7.1 from https://webtatic.com/packages/php71/
rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
yum clean all
yum makecache fast
yum install -y php71w-cli.x86_64 \
php71w-common.x86_64 \
php71w-fpm.x86_64 \
php71w-gd.x86_64 \
php71w-mbstring.x86_64 \
php71w-mcrypt.x86_64 \
php71w-mysql.x86_64 \
php71w-odbc.x86_64 \
php71w-pdo.x86_64 \
php71w-xml.x86_64 \
mod_php71w \
php71w-opcache \
php71w-intl \
php71w-devel

echo "Include /vagrant/apache/*.conf" >> /etc/httpd/conf/httpd.conf
echo "date.timezone = Pacific/Auckland" >> /etc/php.ini
systemctl start httpd.service
systemctl enable httpd.service

yum install -y mariadb-server mariadb
systemctl start mariadb.service
systemctl enable mariadb.service

# install composer
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('SHA384', 'composer-setup.php') === '544e09ee996cdf60ece3804abc52599c22b1f40f4323403c44d44fdfdd586475ca9813a858088ffbc1f233e9b180f061') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"
mv composer.phar /usr/local/bin/composer


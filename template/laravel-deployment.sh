#!/bin/bash
# Update the system packages
sudo apt update

# Install Apache web server
sudo apt install apache2 -y

# Install PHP and required extensions
sudo apt install php php-curl php-bcmath php-json php-mbstring php-xml php-tokenizer php-zip php-mysql -y
sudo phpenmod pdo_mysql

# Install MySQL server and client
sudo apt install mysql-server mysql-client -y

# Secure MySQL installation
# sudo mysql_secure_installation

# Install Composer, a dependency manager for PHP
sudo apt install composer -y

# Create a new Laravel project in the /var/www/html directory
sudo composer create-project --prefer-dist laravel/laravel /var/www/html/laravel --no-interaction

# Change the ownership and permissions of the Laravel project directory
sudo chown -R www-data:www-data /var/www/html/laravel
sudo chmod -R 755 /var/www/html/laravel

# Create a new MySQL database and user for Laravel
sudo mysql -e "CREATE DATABASE laravel;"
sudo mysql -e "CREATE USER 'laravel'@'localhost' IDENTIFIED BY 'abc1234';"
sudo mysql -e "GRANT ALL PRIVILEGES ON laravel.* TO 'laravel'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES;"

# Edit the .env file of the Laravel project to configure the database connection
sudo sed -i "s/DB_DATABASE=laravel/DB_DATABASE=laravel/g" /var/www/html/laravel/.env
sudo sed -i "s/DB_USERNAME=root/DB_USERNAME=laravel/g" /var/www/html/laravel/.env
sudo sed -i "s/DB_PASSWORD=/DB_PASSWORD=abc1234/g" /var/www/html/laravel/.env


# Run the database migrations and seeders
cd /var/www/html/laravel
php artisan migrate --seed

# Create a new Apache virtual host configuration file for Laravel
sudo tee /etc/apache2/sites-available/laravel.conf > /dev/null <<EOF
<VirtualHost *:80>
    ServerAdmin admin@example.com
    ServerName laravel.dev
    ServerAlias www.laravel.dev
    DocumentRoot /var/www/html/laravel/public
    <Directory /var/www/html/laravel>
            Options Indexes FollowSymLinks MultiViews
            AllowOverride All
            Order allow,deny
            allow from all
            Require all granted
    </Directory>
    LogLevel debug
    ErrorLog $${APACHE_LOG_DIR}/error.log
    CustomLog $${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF

# Disable the default apache2
sudo mv /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/000-default.conf-OLD

# Enable the Laravel virtual host and the rewrite module
sudo a2ensite laravel.conf
sudo a2enmod rewrite

# Restart Apache service to apply the changes
sudo systemctl restart apache2


# git clone https://github.com/laravel/laravel.git
# composer install --no-dev
# sudo chown -R www-data:www-data /var/www/html/laravel
# sudo chmod -R 775 /var/www/html/laravel
# sudo chmod -R 775 /var/www/html/laravel/storage
# sudo chmod -R 775 /var/www/html/laravel/bootstrap/cache
# php artisan key:generate
# php artisan config:cache
# php artisan migrate

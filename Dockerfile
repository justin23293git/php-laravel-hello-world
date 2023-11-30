FROM php:7.4-apache

# Install additional dependencies
RUN apt-get update -y \
    && apt-get install -y libmcrypt-dev libzip-dev libonig-dev zip unzip

# Install Composer globally
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set the working directory
WORKDIR /app

# Copy the application files
COPY . /app

RUN mkdir -p storage/framework/sessions
RUN chown -R www-data:www-data storage

# Superuser for Composer
ENV COMPOSER_ALLOW_SUPERUSER=1


# Install PHP extensions and dependencies
RUN docker-php-ext-install pdo mbstring zip \
    && composer install --no-scripts --no-autoloader \
    && composer dump-autoload

# Expose port 8000 for the application
EXPOSE 8000

# Start the application
#CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]
CMD php artisan serve --host=0.0.0.0 --port=8000

# Install MySQL client and PDO MySQL extension
RUN apt-get install -y default-mysql-client \
    && docker-php-ext-install pdo_mysql

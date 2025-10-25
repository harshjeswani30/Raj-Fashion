# FleetCart Railway.app Dockerfile
# Production-ready Docker image for FleetCart e-commerce platform

FROM php:8.2-apache

# Install system dependencies and PHP extensions in one layer
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libicu-dev \
    zip \
    unzip \
    nodejs \
    npm \
    mariadb-client \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
        pdo_mysql \
        mbstring \
        exif \
        pcntl \
        bcmath \
        gd \
        zip \
        intl \
    && a2enmod rewrite headers expires \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Install Yarn
RUN npm install -g yarn && npm cache clean --force

# Set working directory
WORKDIR /var/www/html

# Copy application files first (needed for composer-merge-plugin to access modules/*/composer.json)
COPY . .

# Install PHP dependencies (merge-plugin will now find module dependencies)
# First install without scripts to get the merge plugin working
RUN composer install --no-scripts --prefer-dist --no-interaction

# Run composer update to ensure all merged dependencies are installed
RUN composer update --no-scripts --prefer-dist --no-interaction

# Install Node dependencies
RUN yarn install --production=false

# Now run dump-autoload with scripts to trigger package discovery
RUN composer dump-autoload --optimize --no-scripts

# Manually run package discovery if needed
RUN php artisan package:discover --ansi || true

# Build frontend assets
RUN yarn build && yarn cache clean

# Configure Apache for Laravel
COPY <<EOF /etc/apache2/sites-available/000-default.conf
<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/html/public

    <Directory /var/www/html/public>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF

# Set correct permissions
RUN chown -R www-data:www-data /var/www/html \
    && find /var/www/html -type f -exec chmod 644 {} \; \
    && find /var/www/html -type d -exec chmod 755 {} \; \
    && chmod -R 775 /var/www/html/storage \
    && chmod -R 775 /var/www/html/bootstrap/cache

# Copy and make startup script executable
COPY startup.sh /usr/local/bin/startup.sh
RUN chmod +x /usr/local/bin/startup.sh

# Health check with longer timeout for Railway
HEALTHCHECK --interval=30s --timeout=10s --start-period=120s --retries=5 \
    CMD curl -f http://localhost/ || exit 1

# Expose port
EXPOSE 80

# Use startup script
ENTRYPOINT ["/usr/local/bin/startup.sh"]
CMD ["apache2-foreground"]


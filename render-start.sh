#!/bin/bash

# Render.com start script for FleetCart
set -e

echo "🚀 Starting FleetCart on Render.com..."

# Wait for database to be ready
echo "⏳ Waiting for database connection..."
max_attempts=30
attempt=0

while [ $attempt -lt $max_attempts ]; do
    if php artisan db:show --database=pgsql > /dev/null 2>&1; then
        echo "✅ Database connected!"
        break
    fi
    
    attempt=$((attempt + 1))
    echo "Database not ready, waiting 2 seconds... (attempt $attempt/$max_attempts)"
    sleep 2
    
    if [ $attempt -eq $max_attempts ]; then
        echo "⚠️ Database connection timeout, starting anyway..."
        break
    fi
done

# Generate app key if not exists
if ! grep -q "APP_KEY=base64:" .env 2>/dev/null; then
    echo "🔑 Generating application key..."
    php artisan key:generate --force
fi

# Run database migrations (only if database is connected)
if [ $attempt -lt $max_attempts ]; then
    echo "📊 Running database migrations..."
    php artisan migrate --force
fi

# Create storage symlink
echo "🔗 Creating storage symlink..."
php artisan storage:link || echo "Storage link already exists"

# Clear and cache config for production
echo "⚡ Optimizing application..."
php artisan config:clear
php artisan route:clear
php artisan view:clear
php artisan cache:clear

# Cache configuration for better performance (only if database is connected)
if [ $attempt -lt $max_attempts ]; then
    php artisan config:cache
    php artisan route:cache
    php artisan view:cache
fi

echo "✅ FleetCart ready to serve!"

# Start Apache
exec apache2-foreground